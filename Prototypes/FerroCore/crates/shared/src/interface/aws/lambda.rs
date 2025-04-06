// crates/shared/src/interface/lambda.rs

/// This trait defines the abstract operation of invoking a Lambda function.
#[async_trait]
pub trait LambdaInvoker {
    /// The error type that can be returned from the `invoke` method.
    type Error;

    /// Call the function with the specified Lambda function name and JSON-formatted payload.
    /// # Arguments
    ///
    /// * `function_name` - The name of the Lambda function to invoke
    /// * `payload` - Input data to the Lambda function in JSON format
    ///
    /// Returns the result of the invocation as a string (e.g., in JSON format).
    fn invoke(&self, function_name: &str, payload: &str) -> Result<String, Self::Error>;

    /// Asynchronously execute the Lambda function with basical retry logic.
    ///
    /// # Arguments
    /// * `function_name` - The name of the Lambda function to invoke
    /// * `payload` - Input data to the Lambda function in JSON format
    /// * `retry_count` - The number of times to retry the invocation
    ///
    /// Returns the result of the invocation as a string (e.g., in JSON format).
    async fn invoke_with_retry(
        &self,
        function_name: &str,
        payload: &str,
        retry_count: u32,
    ) -> Result<String, Self::Error> {
        let mut attempts = 0;
        loop {
            match self.invoke(function_name, payload).await {
                Ok(result) => return Ok(result),
                Err(e) if attempts < retry_count => {
                    attempts += 1;
                    // 재시도 전, 필요한 경우 지연(backoff) 로직을 추가할 수 있습니다.
                }
                Err(e) => return Err(e),
            }
        }
    }
}
