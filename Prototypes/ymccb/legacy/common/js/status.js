// Store last update timestamps for ea bus
const busStatus = {};

/**
 * Update bus icons if they are stalled (0 km/h for 5+ minutes).
 */
function checkBusStalled(bus) {
    const busId = bus.plateNo;
    const currentTime = Date.now();

    if (bus.runSped === 0) {
        if (!busStatus[busId]) {
            busStatus[busId] = currentTime; // First time detected as stopped
        } else {
            const elapsedTime = (currentTime - busStatus[busId]) / 60000; // Convert to minutes
            if (elapsedTime >= 5) {
                return true; // 🚨 Stalled for over 5 minutes
            }
        }
    } else {
        delete busStatus[busId]; // 🚀 Moving again, reset timer
    }

    return false;
}