use actix_web::{web, App, HttpRequest, HttpServer, Responder};
use std::env;

fn greet(req: HttpRequest) -> impl Responder {
    let name = req.match_info().get("name").unwrap_or("World");
    format!("Hello {}!", &name)
}

fn main() {
    let key = "PORT";
    let env_value;
    match env::var(key) {
        Ok(val) => env_value = val,
        Err(_) => env_value = "8080".to_string(),
    }

    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(greet))
            .route("/{name}", web::get().to(greet))
    })
    .bind(format!("0.0.0.0:{}", env_value))
    .expect("Can not bind to port")
    .run()
    .unwrap();
}
