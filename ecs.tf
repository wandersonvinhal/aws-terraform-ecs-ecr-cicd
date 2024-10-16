# Criar o cluster ECS
resource "aws_ecs_cluster" "my_cluster" {
  name = "__ECS_CLUSTER_NAME__"
}

# Criar a IAM Role para a execução da tarefa
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRoleTerraForm"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Criar a política IAM para a execução da tarefa
resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "ecsTaskExecutionPolicyTerraform"
  description = "Policy for ECS Task Execution"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Anexar a política à role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_attachment" {
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task"
  execution_role_arn        = aws_iam_role.ecs_task_execution_role.arn  # Role de execução
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = "__ECS_TASK_CPU__"
  memory                    = "__ECS_TASK_MEM__"

  container_definitions = <<DEFINITION
[
  {
    "name": "__ECS_CONTAINER_NAME__",
    "image": "__ECR_REGISTRY__:__ECR_BUILD__",
    "essential": true,
    "portMappings": [
      {
        "containerPort": __ECS_CONTAINER_PORT__,
        "hostPort": __ECS_CONTAINER_PORT__
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/__ECS_CONTAINER_NAME__",
        "awslogs-region": "__S3_REGION__",              
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_attachment]  # Dependência
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_logs" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"  # Permissão para CloudWatch Logs
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/__ECS_CONTAINER_NAME__"
  retention_in_days = 7  # Define por quantos dias os logs devem ser mantidos
}


# Definir o serviço ECS (já existente)
resource "aws_ecs_service" "my_service" {
  name            = "__ECS_SERVICE_NAME__"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = __ECS_CONTAINER_COUNT__
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [for s in aws_subnet.private : s.id]
    security_groups = [aws_security_group.sg_ssh_http.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "__ECS_CONTAINER_NAME__"
    container_port   = __ECS_CONTAINER_PORT__
  }

  depends_on = [aws_lb.alb]  # Dependência existente
}