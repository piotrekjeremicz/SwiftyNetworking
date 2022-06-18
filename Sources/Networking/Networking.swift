struct GetRequest: Request {
    var request: some Request {
        GET("api/2/get")
            .headers([
                "Auth": "sdffsdfsdfds-dsfsdfds-fsdfsddsfdfs"
            ])
    }
}
