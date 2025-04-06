// Initialize OpenStreetMap
const map = L.map("map").setView([37.278925, 127.902296], 17);
L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution: "&copy; OpenStreetMap contributors",
}).addTo(map);

// Default selected bus route
let selectedRouteId = "251000068";

// Markers and route lines storage
let busMarkers = []; // 🚌 Bus markers list
let busStopMarkers = []; // 🚏 Bus stop markers list
let routeLines = []; // Bus route polylines

// Refresh bus data every 7 seconds
setInterval(() => loadBusRoute(selectedRouteId), 7000);

// Load initial bus data
loadBusRoute(selectedRouteId);

// Run this function when the page loads
populateBusSelector();

// Predefined icons for bus markers
const busIcons = {
    up: L.icon({ iconUrl: "common/images/bus-icon-ur.png", iconSize: [64, 64], iconAnchor: [32, 32] }),
    down: L.icon({ iconUrl: "common/images/bus-icon-dl.png", iconSize: [64, 64], iconAnchor: [32, 32] }),
    upZoomed: L.icon({ iconUrl: "common/images/bus-icon-ur.png", iconSize: [100, 100], iconAnchor: [50, 50] }),
    downZoomed: L.icon({ iconUrl: "common/images/bus-icon-dl.png", iconSize: [100, 100], iconAnchor: [50, 50] }),
    stalled: L.icon({ iconUrl: "common/images/bus-icon-stalled.png", iconSize: [64, 64], iconAnchor: [32, 32] }), // 🔴 Stalled bus icon
    stalledZoomed: L.icon({ iconUrl: "common/images/bus-icon-stalled.png", iconSize: [100, 100], iconAnchor: [50, 50] }),
};

// Predefined pin icons for bus stops
const pinIcons = {
    red: L.icon({
        iconUrl: "https://maps.google.com/mapfiles/ms/icons/red-dot.png",
        iconSize: [25, 25],
    }),
    blue: L.icon({
        iconUrl: "https://maps.google.com/mapfiles/ms/icons/blue-dot.png",
        iconSize: [25, 25],
    }),
    green: L.icon({
        iconUrl: "https://maps.google.com/mapfiles/ms/icons/green-dot.png",
        iconSize: [25, 25],
    }),
};

/**
 * Update bus icon sizes based on the current zoom level.
 */
const updateBusIconSize = () => {
    // Update only bus markers
    busMarkers.forEach((marker) => {
        const busData = marker.options.busData; // Store bus data inside marker.options
        if (!busData) return; // Skip if no data

        const zoomLevel = map.getZoom();
        const busIcon =
            busData.updown === "0"
                ? zoomLevel > 17
                    ? busIcons.upZoomed
                    : busIcons.up
                : zoomLevel > 17
                    ? busIcons.downZoomed
                    : busIcons.down;

        marker.setIcon(busIcon);
    });

    // console.log(`🔍 Zoom Level: ${zoomLevel}, Bus Icon Size: ${newSize}px`);
};

// Listen for zoom changes to update bus icon sizes
map.on("zoomend", updateBusIconSize);

// Listen for zoom changes to update bus icon sizes
map.on("zoomend", updateBusIconSize);

/**
 * Display bus data on the map.
 * @param {Object} data - Bus data from the API
 */
function updateMap(data) {
    if (!data) return;

    // Update bus list panel
    updateBusList(data.busP);

    // Remove existing markers and route lines
    busMarkers.forEach((marker) => map.removeLayer(marker));
    busStopMarkers.forEach((marker) => map.removeLayer(marker));
    routeLines.forEach((line) => map.removeLayer(line));

    busMarkers = [];
    busStopMarkers = [];
    routeLines = [];

    // Path storage for bus route
    const upPath = [];
    const downPath = [];

    // Draw bus route path
    if (data.busL) {
        data.busL.forEach((line) => {
            const coords = line.latlng.split(",").map(parseFloat); // Convert string to float

            for (let i = 0; i < coords.length; i += 2) {
                if (!isNaN(coords[i]) && !isNaN(coords[i + 1])) {
                    const latLng = [coords[i], coords[i + 1]];
                    if (line.updnDir === "0") upPath.push(latLng);
                    else downPath.push(latLng);
                }
            }
        });

        if (upPath.length)
            routeLines.push(
                L.polyline(upPath, { color: "blue", weight: 3 }).addTo(map),
            );

        if (downPath.length)
            routeLines.push(
                L.polyline(downPath, { color: "red", weight: 3 }).addTo(map),
            );
    }

    // Add bus stops to the map
    data.busStop.forEach((stop) => {
        busStopMarkers.push(
            L.marker([stop.localY, stop.localX], { icon: pinIcons.blue })
                .addTo(map)
                .bindPopup(`<b>${stop.stationNm}</b><br>ID: ${stop.mobiNum}`),
        );
    });

    // Add bus locations to the map
    data.busP.forEach((bus) => {
        const directionText = bus.updown === "0" ? "연세대 방향" : "장양리 방향";
        const zoomLevel = map.getZoom();

        // Select the correct bus icon based on `updown` value and zoom level
        const busIcon =
            bus.updown === "0"
                ? zoomLevel > 17
                    ? busIcons.upZoomed
                    : busIcons.up
                : zoomLevel > 17
                    ? busIcons.downZoomed
                    : busIcons.down;

        busMarkers.push(
            L.marker([bus.localY, bus.localX], { icon: busIcon })
                .addTo(map)
                .bindPopup(
                    `<b>${data.MapInfo.routeNm}번</b> ${directionText}<br>${bus.plateNo}, ${bus.runSped} km/h`,
                ),
        );
    });
}

/**
 * Fetch bus data from the API.
 * @param {string} routeId - Bus route ID
 * @returns {Promise<Object>} Bus data
 */
async function loadBusRoute(routeId) {
    const data = await fetchBusData(routeId);
    updateMap(data);
}

/**
 * Update the bus list panel.
 * @param {Array} buses - Bus data from the API
 */
function updateBusList(buses) {
    const busList = document.getElementById("busList");
    busList.innerHTML = ""; // Clear existing list

    buses.forEach((bus) => {
        const directionText = bus.updown === "0" ? "연세대 방향" : "장양리 방향";
        const listItem = document.createElement("li");

        listItem.innerHTML = `<b>${bus.plateNo}</b> (${directionText})`;

        // Click to focus on the selected bus
        listItem.onclick = () => map.setView([bus.localY, bus.localX], 16);

        busList.appendChild(listItem);
    });
}
