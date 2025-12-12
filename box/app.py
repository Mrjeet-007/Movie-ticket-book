from flask import Flask, render_template, request, redirect, send_file, abort, session, flash, url_for, jsonify
from fpdf import FPDF
from datetime import datetime
import mysql.connector
import io
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = "MOVIEX_SECRET_KEY"

# ---------------- DATABASE CONNECT ----------------
def get_db_connection():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="movie_booking"
        )
        if conn.is_connected():
            return conn
    except mysql.connector.Error as err:
        print("Database Error:", err)
    return None

# ---------------- helper: get movie by id ----------------
def get_movie_by_id(movie_id):
    con = get_db_connection()
    if not con:
        return None
    cur = con.cursor(dictionary=True)
    cur.execute("SELECT * FROM movies WHERE id=%s", (movie_id,))
    movie = cur.fetchone()
    cur.close()
    con.close()
    return movie

# ---------------- helper: get movie by title ----------------
def get_movie_by_title(title):
    con = get_db_connection()
    if not con:
        return None
    cur = con.cursor(dictionary=True)
    cur.execute("SELECT * FROM movies WHERE title=%s OR name=%s", (title, title))
    movie = cur.fetchone()
    cur.close()
    con.close()
    return movie

# ============================================================
#                       AUTH SYSTEM
# ============================================================

# ---------------- SIGNUP ----------------
@app.route("/signup", methods=["GET", "POST"])
def signup():
    if request.method == "POST":
        name = request.form["name"]
        email = request.form["email"]
        phone = request.form["phone"]
        password = generate_password_hash(request.form["password"])

        con = get_db_connection()
        cur = con.cursor()
        cur.execute(
            "INSERT INTO users (name, email, phone, password) VALUES (%s, %s, %s, %s)",
            (name, email, phone, password)
        )
        con.commit()
        cur.close()
        con.close()

        flash("Signup successful! Please login.")
        return redirect("/login")

    return render_template("signup.html")


# ---------------- LOGIN ----------------
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]

        con = get_db_connection()
        cur = con.cursor(dictionary=True)
        cur.execute("SELECT * FROM users WHERE email=%s", (email,))
        user = cur.fetchone()
        cur.close()
        con.close()

        if user and check_password_hash(user["password"], password):
            session["user_id"] = user["id"]
            session["user_name"] = user["name"]
            session["email"] = user["email"]
            session["phone"] = user["phone"]
            return redirect("/")
        else:
            flash("Incorrect email or password")
            return redirect("/login")

    return render_template("login.html")


# ---------------- LOGOUT ----------------
@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")


# ============================================================
#                       MOVIE SYSTEM
# ============================================================

# ---------------- HOME PAGE ----------------
@app.route("/")
def index():
    con = get_db_connection()
    cur = con.cursor(dictionary=True)
    cur.execute("SELECT * FROM movies")
    movies = cur.fetchall()
    cur.close()
    con.close()

    return render_template("index.html", movies=movies)


@app.route("/book/<int:movie_id>")
def book(movie_id):
    # If user NOT logged in → send to signup
    if "user_id" not in session:
        flash("Please sign up or log in to continue.")
        return redirect(url_for("signup"))

    # If logged in → continue
    movie = get_movie_by_id(movie_id)
    if not movie:
        flash("Movie not found.")
        return redirect(url_for("index"))
    # fetch seats for this movie to show in booking page
    con = get_db_connection()
    cur = con.cursor(dictionary=True)
    cur.execute("SELECT seat_number, is_booked FROM seats WHERE movie_id=%s ORDER BY seat_number", (movie_id,))
    seats = cur.fetchall()
    cur.close()
    con.close()

    return render_template("book.html", movie=movie, seats=seats)


# ---------------- API: seats for a movie (by title) ----------------
@app.route("/seats/<movie_title>")
def seats_api(movie_title):
    # movie_title in URL will be encoded; decode handled by Flask
    movie = get_movie_by_title(movie_title)
    if not movie:
        return jsonify({"error": "movie not found"}), 404

    movie_id = movie["id"]
    con = get_db_connection()
    cur = con.cursor(dictionary=True)
    cur.execute("SELECT seat_number, is_booked FROM seats WHERE movie_id=%s", (movie_id,))
    rows = cur.fetchall()
    cur.close()
    con.close()

    available = [r["seat_number"] for r in rows if not r["is_booked"]]
    price = movie.get("price") or 0
    return jsonify({"available_seats": available, "price": price})


# ---------------- API: book (JSON) used by front-end booking script ----------------
@app.route("/book", methods=["POST"])
def book_api():
    # expects JSON: { movie: "<title>", seats: [1,2,...] }
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"success": False, "message": "Invalid JSON"}), 400

    movie_title = data.get("movie")
    seats = data.get("seats", [])
    if not movie_title or not seats:
        return jsonify({"success": False, "message": "Missing movie or seats"}), 400

    movie = get_movie_by_title(movie_title)
    if not movie:
        return jsonify({"success": False, "message": "Movie not found"}), 404

    movie_id = movie["id"]
    con = get_db_connection()
    if not con:
        return jsonify({"success": False, "message": "DB connection failed"}), 500

    cur = con.cursor()
    # check availability
    format_strings = ",".join(["%s"] * len(seats))
    cur.execute(f"SELECT seat_number FROM seats WHERE movie_id=%s AND seat_number IN ({format_strings}) AND is_booked=0", (movie_id, *seats))
    available_rows = cur.fetchall()
    available_numbers = [r[0] for r in available_rows]

    missing = [s for s in seats if s not in available_numbers]
    if missing:
        cur.close()
        con.close()
        return jsonify({"success": False, "message": f"Seats already booked or invalid: {missing}"}), 409

    # book seats
    try:
        cur.executemany("UPDATE seats SET is_booked=1 WHERE movie_id=%s AND seat_number=%s",
                        [(movie_id, s) for s in seats])
        con.commit()
    except Exception as e:
        con.rollback()
        cur.close()
        con.close()
        return jsonify({"success": False, "message": "Failed to book seats", "error": str(e)}), 500

    # calculate total
    price_per = movie.get("price") or 0
    total = price_per * len(seats)

    cur.close()
    con.close()

    return jsonify({"success": True, "seats": seats, "total": total})


# ---------------- BOOK SEAT (form) ----------------
@app.route("/confirm", methods=["POST"])
def confirm():
    movie_id = request.form.get("movie_id")
    seat = request.form.get("seat")

    con = get_db_connection()
    cur = con.cursor()
    cur.execute(
        "UPDATE seats SET is_booked=1 WHERE movie_id=%s AND seat_number=%s",
        (movie_id, seat)
    )
    con.commit()
    cur.close()
    con.close()

    return redirect(f"/ticket/{movie_id}/{seat}")


# ---------------- TICKET PAGE ----------------
@app.route("/ticket/<int:movie_id>/<seat>")
def ticket(movie_id, seat):
    con = get_db_connection()
    cur = con.cursor(dictionary=True)
    cur.execute("SELECT * FROM movies WHERE id=%s", (movie_id,))
    movie = cur.fetchone()
    cur.close()
    con.close()

    return render_template(
        "ticket.html",
        movie=movie,
        seat=seat,
        user_name=session.get("user_name"),
        email=session.get("email"),
        phone=session.get("phone")
    )


# ---------------- PDF DOWNLOAD ----------------
@app.route("/download/<int:movie_id>/<seat>")
def download(movie_id, seat):
    con = get_db_connection()
    cur = con.cursor(dictionary=True)
    cur.execute("SELECT * FROM movies WHERE id=%s", (movie_id,))
    movie = cur.fetchone()
    cur.close()
    con.close()

    # Movie name (flexible keys)
    movie_name = movie.get("title") or movie.get("name") or movie.get("movie_name")

    # User info
    user_name = session.get("user_name", "Guest User")
    email = session.get("email", "Not Provided")
    phone = session.get("phone", "Not Provided")

    # Time & ID
    now = datetime.now()
    show_date = now.strftime("%Y-%m-%d")
    show_time = now.strftime("%H:%M:%S")
    ticket_id = f"T{now.strftime('%Y%m%d%H%M%S%f')}"

    # PDF CREATE
    pdf = FPDF()
    pdf.add_page()

    pdf.set_font("Arial", 'B', 16)
    pdf.cell(0, 10, "Movie Ticket", ln=1, align="C")
    pdf.ln(5)

    pdf.set_font("Arial", size=12)
    pdf.cell(0, 10, f"Movie: {movie_name}", ln=1)
    pdf.cell(0, 10, f"Seat: {seat}", ln=1)
    pdf.cell(0, 10, f"Price: ${movie.get('price')}", ln=1)

    pdf.ln(4)
    pdf.cell(0, 10, f"Name: {user_name}", ln=1)
    pdf.cell(0, 10, f"Email: {email}", ln=1)
    pdf.cell(0, 10, f"Phone: {phone}", ln=1)

    pdf.ln(4)
    pdf.cell(0, 10, f"Date: {show_date}", ln=1)
    pdf.cell(0, 10, f"Time: {show_time}", ln=1)

    pdf.ln(6)
    pdf.multi_cell(0, 10, "Please arrive 15 minutes early.\nEnjoy your movie!")

    pdf.ln(5)
    pdf.cell(0, 10, f"Ticket ID: {ticket_id}", ln=1)

    pdf_bytes = pdf.output(dest="S").encode("latin1")

    return send_file(
        io.BytesIO(pdf_bytes),
        as_attachment=True,
        download_name="ticket.pdf",
        mimetype="application/pdf"
    )


# ---------------- OPTIONAL PAGES ----------------
@app.route("/movies")
def movies_page():
    return redirect("/")

@app.route("/about")
def about():
    return render_template("about.html")

@app.route("/contact")
def contact():
    return render_template("contact.html")


# ---------------- RUN ----------------
if __name__ == "__main__":
    app.run(debug=True)
