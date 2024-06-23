[
    {
        "name": "frontend",
        "image": "${app_frontend_image}",
        "cpu": 256,
        "memory": 256,
        "networkMode": "awsvpc",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-region": "${aws_region}",
                "awslogs-group": "${app_frontend_log_group}",
                "awslogs-stream-prefix": "/ecs"
            }
        },
        "portMappings": [
            {
                "name": "http",
                "containerPort": 3000,
                "hostPort": 3000
            }
        ],
        "environment": [
            {
                "name": "NEXT_PRIVATE_API_URL",
                "value": "fixme"
            }
        ],
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "wget --no-verbose --tries=1 --spider http://localhost:3000"
            ],
            "interval": 30,
            "timeout": 10,
            "retries": 3
        },
        "repositoryCredentials": {
            "credentialsParameter": "${ghcr_credentials_arn}"
        }
    }
]
