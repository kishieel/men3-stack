[
    {
        "name": "backend",
        "image": "${app_backend_image}",
        "networkMode": "awsvpc",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-region": "${aws_region}",
                "awslogs-group": "${app_backend_log_group}",
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
                "name": "DATABASE_URL",
                "value": "${app_database_url}"
            }
        ],
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "wget --no-verbose --tries=1 --spider http://localhost:3000/api/health/readiness"
            ],
            "interval": 30,
            "timeout": 10,
            "retries": 3
        },
        "dependsOn": [
            {
                "containerName": "backend-migrate",
                "condition": "SUCCESS"
            }
        ]
    },
    {
        "name": "backend-migrate",
        "image": "${app_backend_image}",
        "essential": false,
        "networkMode": "awsvpc",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-region": "${aws_region}",
                "awslogs-group": "${app_backend_migration_log_group}",
                "awslogs-stream-prefix": "/ecs"
            }
        },
        "environment": [
            {
                "name": "DATABASE_URL",
                "value": "${app_database_url}"
            }
        ],
        "command": [
            "yarn",
            "prisma:deploy"
        ]
    }
]
