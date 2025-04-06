// crates/shared/src/interface/storage.rs

/// This interface abstracts the basic CRUD operations in key-value format.
#[async_trait]
pub trait Storage {
    /// All errors that can occur in the storage.
    type Error;

    /// Put or Update the data in the storage corresponding to the given key.
    async fn put(&self, key: &str, value: &str) -> Result<(), Self::Error>;

    /// Get the data corresponding to the given key.
    async fn get(&self, key: &str) -> Result<Option<String>, Self::Error>;

    /// Deletes the data corresponding to the given key.
    async fn delete(&self, key: &str) -> Result<(), Self::Error>;
}
