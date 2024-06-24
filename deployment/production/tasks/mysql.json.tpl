[
  {
    "name": "mysql",
    "image": "${mysql_image}",
    "networkMode": "awsvpc",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${aws_region}",
        "awslogs-group": "/ecs/mysql",
        "awslogs-stream-prefix": "/ecs"
      }
    },
    "environment": [
      {
        "name": "MYSQL_ROOT_PASSWORD",
        "value": "${mysql_root_password}"
      },
      {
        "name": "MYSQL_DATABASE",
        "value": "${mysql_database}"
      },
      {
        "name": "MYSQL_USER",
        "value": "${mysql_username}"
      },
      {
        "name": "MYSQL_PASSWORD",
        "value": "${mysql_password}"
      }
    ],
    "portMappings": [
      {
        "name": "mysql",
        "containerPort": 3306,
        "hostPort": 3306
      }
    ],
    "healthCheck": {
      "command": [
        "CMD-SHELL",
        "mysqladmin ping -h localhost"
      ],
      "interval": 30,
      "timeout": 10,
      "retries": 3
    }
  }
]
