// src/main.rs

use services::scheduler::{load_route_ids_from_file, start_scheduler};
use shared::config::AppConfig;
use tokio::{
    task,
    time::{Duration, sleep},
};

mod clients;
mod db;
mod services;

#[tokio::main]
async fn main() -> std::io::Result<()> {
    // Load configuration from environment variables.
    let _ = AppConfig::from_env();

    // Load route IDs from a JSON file.
    let route_map = match load_route_ids_from_file("routeIds.json") {
        Ok(map) => map,
        Err(e) => {
            eprintln!("Failed to load routes: {}", e);
            return Ok(());
        }
    };

    // Start fetching bus locations asynchronously.
    for (bus_number, routes) in route_map {
        task::spawn(start_scheduler(bus_number.clone(), routes));
    }

    // Keep the main thread alive.
    loop {
        sleep(Duration::from_secs(60)).await;
    }
}
