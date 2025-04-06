// src/db/redis.rs

use chrono::Utc;
use redis::{AsyncCommands, RedisError, aio::MultiplexedConnection};
use serde_json::json;

pub async fn save_to_redis(
    route_id: &str,
    vehicle_no: &str,
    latitude: f64,
    longitude: f64,
    stop_id: &str,
    stop_name: &str,
    stop_order: i64,
) -> Result<(), RedisError> {
    // Redis 클라이언트 생성
    let client = redis::Client::open("redis://127.0.0.1/")?;

    // MultiplexedConnection 사용 (get_multiplexed_async_connection)
    let mut con: MultiplexedConnection = client.get_multiplexed_async_connection().await?;

    // Redis 키 설정
    let key = format!("busLoc:{}:{}", route_id, vehicle_no);

    // JSON 직렬화
    let value = serde_json::to_string(&json!({
        "latitude": latitude,
        "longitude": longitude,
        "stop_id": stop_id,
        "stop_name": stop_name,
        "stop_order": stop_order,
        "timestamp": Utc::now().timestamp()
    }))
    .map_err(|e| {
        RedisError::from((
            redis::ErrorKind::TypeError,
            "JSON Serialization Error",
            e.to_string(),
        ))
    })?;

    // Redis에 저장 (반환 값을 명확히 지정)
    let _: () = con.set_ex(key, value, 600).await?;

    Ok(())
}
