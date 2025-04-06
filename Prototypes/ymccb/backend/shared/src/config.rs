// shared/src/config.rs

use once_cell::sync::Lazy;
use serde::Deserialize;
use std::env;

/// Global application configuration.
/// This is lazy-loaded and can be accessed from anywhere in the application.
pub static CONFIG: Lazy<AppConfig> = Lazy::new(|| AppConfig::from_env());

#[derive(Debug, Deserialize)]
pub struct AppConfig {
    // API Settings
    pub api_bus_route_info_url: String,
    pub api_bus_location_info_url: String,
    pub api_key: String,
    pub api_city_code: u16,
    // Server Settings
    pub server_address: String,
    pub server_port: u16,
    pub sqlite_db_path: String,
}

impl AppConfig {
    pub fn from_env() -> Self {
        // If there is a .env file, load it.
        dotenv::dotenv().expect("Failed to load .env file"); // Better error reporting

        // Get a u16 value from an environment variable or use a default value.
        let get_u16 = |var: &str, default: u16| {
            env::var(var)
                .ok()
                .and_then(|s| s.parse::<u16>().ok())
                .unwrap_or(default)
        };

        // Get a string value from an environment variable or use a default value.
        let get_str = |var: &str, default: &str| {
            env::var(var).unwrap_or_else(|_| default.to_string())
        };

        // Load environment variables or use default values.
        AppConfig {
            api_key: env::var("API_KEY").expect(
                "BUS_API_KEY must be set in environment variables (required to access bus data)"
            ),
            api_bus_route_info_url: get_str("API_BUS_ROUTE_INFO_URL", "http://apis.data.go.kr/1613000/BusRouteInfoInqireService"),
            api_bus_location_info_url: get_str("API_BUS_LOCATION_INFO_URL", "http://apis.data.go.kr/1613000/BusLcInfoInqireService"),
            api_city_code: get_u16("API_CITY_CODE", 32020),
            server_address: get_str("SERVER_ADDRESS", "127.0.0.1"),
            server_port: get_u16("SERVER_PORT", 8080),
            sqlite_db_path: get_str("SQLITE_DB_PATH", "busData.db"),
        }
    }

    pub fn validate(&self) -> Result<(), String> {
        // Validate API_KEY
        if self.api_key.is_empty() {
            return Err("API_KEY cannot be empty".to_string());
        }
        
        // Validate API_BUS_ROUTE_INFO_URL
        if self.api_bus_route_info_url.is_empty() {
            return Err("API_BUS_ROUTE_INFO_URL cannot be empty".to_string());
        }

        // Validate API_BUS_LOCATION_INFO_URL
        if self.api_bus_location_info_url.is_empty() {
            return Err("API_BUS_LOCATION_INFO_URL cannot be empty".to_string());
        }

        // Validate API_CITY_CODE
        if self.api_city_code == 0 {
            return Err("API_CITY_CODE cannot be 0".to_string());
        }        

        // @TODO: Add more vaildations

        Ok(())
    }
}