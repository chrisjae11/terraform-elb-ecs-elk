[
  {
    "name": "tf-nginx-container",
    "revision": "1",
    "image": "${ecr_repository_url}",
    "cpu": 1,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 8080
      }
    ]
  }
]