// src/services/processer.rs

use crate::db::redis::save_to_redis;
use serde_json::Value;

async fn process_bus_data(response: &str, route_id: &str) {
    // JSON 파싱 에러 처리
    let json: Value = match serde_json::from_str(response) {
        Ok(parsed) => parsed,
        Err(e) => {
            eprintln!("Failed to parse JSON response: {}", e);
            return;
        }
    };

    if let Some(items) = json["response"]["body"]["items"]["item"].as_array() {
        for item in items {
            let vehicle_no = item["vehicleno"].as_str().unwrap_or("Unknown");
            let latitude = item["gpslati"].as_f64().unwrap_or(0.0);
            let longitude = item["gpslong"].as_f64().unwrap_or(0.0);
            let stop_id = item["nodeid"].as_str().unwrap_or("Unknown Stop ID"); // 정류소 ID 추가
            let stop_name = item["nodenm"].as_str().unwrap_or("Unknown Stop"); // 정류소명 추가
            let stop_order = item["nodeord"].as_i64().unwrap_or(0); // 정류소 순서 추가

            // Redis에 저장 (비동기 처리)
            if let Err(e) = save_to_redis(
                route_id, vehicle_no, latitude, longitude, stop_id, stop_name, stop_order,
            )
            .await
            {
                eprintln!("Failed to save to Redis for route {}: {}", route_id, e);
            }
        }
    } else {
        eprintln!("No bus location data found for route {}", route_id);
    }
}
