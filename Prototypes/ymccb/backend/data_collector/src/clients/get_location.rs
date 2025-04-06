// src/clients/bus_location.rs

use reqwest;
use shared::config::CONFIG;
use std::error::Error;

/// Call the bus location API and return the response body.
/// - `route_id`: Request parameters
/// - Returns a `Result` with the response body as a `String`.
pub async fn fetch_bus_location(route_id: &str) -> Result<String, Box<dyn Error>> {
    let city_code = std::env::var("CITY_CODE").unwrap_or_else(|_| "32020".to_string());

    let url = format!(
        "{}/getRouteAcctoBusLcList?serviceKey={}&cityCode={}&routeId={}&numOfRows=32&pageNo=1&_type=json",
        CONFIG.api_bus_location_info_url, CONFIG.api_key, city_code, route_id
    );

    let res = reqwest::get(&url).await?;
    let body = res.text().await?;

    Ok(body)
}
