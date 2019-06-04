
{
    "app_database": {
        "database": "example_service",
        "username": env.APP_DB_USERNAME,
        "password": env.APP_DB_PASSWORD,
        "hostname": env.APP_DB_HOSTNAME,
        "port": env.APP_DB_PORT
    },
    "vendor_database": {
        "database": "vendor_db",
        "username": env.VENDOR_DB_USERNAME,
        "password": env.VENDOR_DB_PASSWORD,
        "hostname": env.VENDOR_DB_HOSTNAME,
        "port": env.VENDOR_DB_PORT
    },
    "external_service": {
        "hostname": env.EXT_SVC_HOSTNAME,
        "api_token": env.EXT_SVC_API_TOKEN
    },
    "redis": {
        "hostname": env.REDIS_HOSTNAME,
        "port": env.REDIS_PORT
    }
}
