/**
 * Toggle the bus schedule panel visibility.
 */
document.addEventListener("DOMContentLoaded", function () {
    const panel = document.getElementById("busSchedulePanel");
    const list = document.getElementById("busSchedule");
    const button = document.getElementById("toggleBusSchedule");

    if (!panel || !list || !button) {
        return;
    }

    button.addEventListener("click", function () {
        if (panel.classList.contains("collapsed")) {
            panel.classList.remove("collapsed");
            list.style.display = "block";
            button.innerHTML = "▲"; // Expanded 상태
        } else {
            panel.classList.add("collapsed");
            list.style.display = "none";
            button.innerHTML = "▼"; // Collapsed 상태
        }
    });
});

// Bus routes list
const BUS_ROUTES = {
    "30번": ["251000068"],
    "34번": ["251000082"],
    "34-1번": ["251000331"],
};

/**
 * Populate the busSelector dropdown dynamically.
 */
function populateBusSelector() {
    const selector = document.getElementById("busSelector");
    selector.innerHTML = ""; // Clear existing options

    Object.keys(BUS_ROUTES).forEach((busName) => {
        const option = document.createElement("option");
        option.value = BUS_ROUTES[busName][0]; // Use the first route ID
        option.textContent = busName;
        selector.appendChild(option);
    });

    // console.log("✅ Bus selector populated!");
}

/**
 * Change the selected bus route and reload data.
 */
function changeBusRoute() {
    selectedRouteId = document.getElementById("busSelector").value;

    // console.log(`🔄 ${selectedRouteId}`);
    loadBusRoute(selectedRouteId);

    // Update the bus schedule
    displayBusSchedule(selectedRouteId);
}

// Global variable for user location marker
let userMarker = null;

/**
 * Move the map to the user's current location.
 */
function findUserLocation() {
    if (!navigator.geolocation) {
        alert("⚠️ Geolocation is not supported by your browser.");
        return;
    }

    navigator.geolocation.getCurrentPosition(
        (position) => {
            const { latitude, longitude } = position.coords;

            // Move the map to the user's location
            map.setView([latitude, longitude], 16);

            // Remove the old marker if it exists
            if (userMarker) {
                map.removeLayer(userMarker);
            }

            // Add a marker at the user's location
            userMarker = L.marker([latitude, longitude], {
                icon: L.icon({
                    iconUrl: "https://maps.google.com/mapfiles/ms/icons/green-dot.png",
                    iconSize: [30, 30],
                }),
            }).addTo(map).bindPopup("📍 내 위치").openPopup();
        },
        (error) => {
            alert("⚠️ 위치 정보를 가져올 수 없습니다.");
            console.error(error);
        }
    );
}

// Attach the function to the button
document.getElementById("findMeBtn").addEventListener("click", findUserLocation);