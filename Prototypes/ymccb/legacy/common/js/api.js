const API_URL = "https://bpnwx48z37.execute-api.ap-northeast-2.amazonaws.com";

/**
 * Fetch bus data of a specific route
 */
async function fetchBusData(routeId) {
  try {
    const response = await fetch(
      `${API_URL}/bus/busDetail.do?routeId=${routeId}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
      },
    );

    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }

    const data = await response.json();
    console.log(routeId);
    console.log(data);
    return data;
  } catch (error) {
    console.error("❌ Request failed:", error);
    return null;
  }
}

