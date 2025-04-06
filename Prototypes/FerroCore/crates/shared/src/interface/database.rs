// crates/shared/src/interface/database.rs

use async_trait::async_trait;

/// Basic database operations are abstracted by this interface.
#[async_trait]
pub trait Database {
    type Error;

    /// Put or Update the data in the storage corresponding to the given key.
    async fn put(&self, key: &str, value: &str) -> Result<(), Self::Error>;

    /// Get the data corresponding to the given key.
    async fn get(&self, key: &str) -> Result<Option<String>, Self::Error>;

    /// Deletes the data corresponding to the given key.
    async fn delete(&self, key: &str) -> Result<(), Self::Error>;
}
