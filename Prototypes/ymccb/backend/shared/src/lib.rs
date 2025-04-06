// shared/src/lib.rs

pub mod config;

#[cfg(test)]
mod tests {
    use crate::config::AppConfig;

    #[test]
    fn get_env_variables() {
        // Call the from_env function to load the configuration from the environment variables.
        let app_config = AppConfig::from_env();

        // Debug print the app configuration.
        println!("App configuration: {:?}", app_config);
    }
}
