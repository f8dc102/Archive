// src/services/scheduler.rs

use crate::clients::get_location;

use futures::future::join_all;
use serde_json::Value;
use std::collections::HashMap;
use std::fs::File;
use std::io::Read;
use tokio::time::{Duration, sleep};

/// Start a scheduler that calls the bus location API every 10 seconds for a given `route_id`.
/// - `bus_number`: Bus number i.e, 30, 34, 34-1
/// - `route_id`: Request parameter
pub async fn start_scheduler(bus_number: String, route_ids: Vec<String>) {
    loop {
        let fetch_tasks = route_ids.iter().map(|route_id| {
            let route_id = route_id.clone();
            let bus_number = bus_number.clone(); // 💡 bus_number 클론 추가

            async move {
                match get_location::fetch_bus_location(&route_id).await {
                    Ok(response) => println!(
                        "[Bus {}] Location API response for {}: {}",
                        bus_number, route_id, response
                    ),
                    Err(e) => eprintln!(
                        "[Bus {}] Error fetching bus location for {}: {}",
                        bus_number, route_id, e
                    ),
                }
            }
        });

        join_all(fetch_tasks).await;
        sleep(Duration::from_secs(10)).await;
    }
}

/// Load route ids from a json file
/// - `file_path`: Path to route ids json file
pub fn load_route_ids_from_file(
    file_path: &str,
) -> Result<HashMap<String, Vec<String>>, Box<dyn std::error::Error>> {
    let mut file = File::open(file_path)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;

    let json_data: Value = serde_json::from_str(&contents)?;
    let mut all_routes = HashMap::new();

    for (bus_number, value) in json_data.as_object().unwrap() {
        if let Some(routes) = value.as_array() {
            let route_list = routes
                .iter()
                .map(|r| r.as_str().unwrap().to_string())
                .collect();
            all_routes.insert(bus_number.clone(), route_list);
        }
    }

    Ok(all_routes)
}
