// main booking logic + search
document.addEventListener("DOMContentLoaded", function () {
    let selectedSeats = [];
    let availableSeats = [];
    let pricePerSeat = 10;
    let currentMovie = "";

    const modal = document.getElementById('modal');
    const close = document.getElementById('close');
    const seatsContainer = document.getElementById('seats-container');
    const count = document.getElementById('count');
    const total = document.getElementById('total');
    const modalTitle = document.getElementById('modal-title');
    const confirmBtn = document.getElementById('confirmBtn');

    // ----------------- BOOK BUTTONS -----------------
    function attachBookButtons() {
        document.querySelectorAll('.book-btn').forEach(btn => {
            if (btn._listener) return; // avoid duplicates

            const listener = async () => {
                const card = btn.closest('.movie-card');
                currentMovie = card.dataset.movie;
                modalTitle.innerText = currentMovie;

                const data = await fetch(`/seats/${encodeURIComponent(currentMovie)}`)
                    .then(r => r.json())
                    .catch(() => ({ available_seats: [], price: 10 }));

                pricePerSeat = data.price || pricePerSeat;
                selectedSeats = [];
                availableSeats = data.available_seats || [];

                createSeats();
                updateInfo();
                modal.style.display = "flex";
            };

            btn._listener = listener;
            btn.addEventListener('click', listener);
        });
    }

    attachBookButtons();

    // ----------------- MODAL LOGIC -----------------
    close && (close.onclick = () => modal.style.display = "none");
    window.onclick = e => { if (e.target === modal) modal.style.display = "none"; };

    function createSeats() {
        if (!seatsContainer) return;
        seatsContainer.innerHTML = '';

        for (let i = 1; i <= 30; i++) {
            const seat = document.createElement('div');
            seat.classList.add('seat');
            seat.dataset.seat = i;
            seat.innerText = i;

            if (!availableSeats.includes(i)) seat.classList.add('booked');
            if (selectedSeats.includes(i)) seat.classList.add('selected');

            seat.addEventListener('click', () => toggleSeat(seat));
            seatsContainer.appendChild(seat);
        }
    }

    function toggleSeat(seat) {
        const num = parseInt(seat.dataset.seat);
        if (seat.classList.contains('booked')) return;

        seat.classList.toggle('selected');
        if (selectedSeats.includes(num)) {
            selectedSeats = selectedSeats.filter(n => n !== num);
        } else {
            selectedSeats.push(num);
        }
        updateInfo();
    }

    function updateInfo() {
        if (count) count.innerText = selectedSeats.length;
        if (total) total.innerText = (selectedSeats.length * pricePerSeat).toFixed(2);
    }

    // ----------------- CONFIRM BUTTON -----------------
    confirmBtn && confirmBtn.addEventListener('click', async () => {
        if (selectedSeats.length === 0) return alert("Select seats first!");

        try {
            const res = await fetch('/book', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ movie: currentMovie, seats: selectedSeats })
            });

            const data = await res.json();

            if (data.success) {
                window.location.href = `/ticket?movie=${currentMovie}&seats=${encodeURIComponent(data.seats.join(','))}&total=${data.total}`;
            } else {
                alert(data.message || "Booking failed");
                await fetchSeats();
                updateInfo();
            }
        } catch (err) {
            alert("Server error. Try again.");
        }
    });

    // ----------------- SEARCH BAR (FINAL FIXED VERSION) -----------------
    const searchInput = document.getElementById('searchInput');

    if (searchInput) {
        searchInput.addEventListener('input', () => {
            const q = searchInput.value.trim().toLowerCase();

            document.querySelectorAll('.movie-card').forEach(card => {
                const name = (card.dataset.movie || "").toLowerCase();
                card.style.display = name.includes(q) ? '' : 'none';
            });
        });
    }
});
