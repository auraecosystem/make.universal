# Create the Application Load Balancer
resource "aws_lb" "eln_balancer" {
  name               = "eln-app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = ["subnet-abc12345", "subnet-def67890"] # Multi-AZ Subnets
}

# Define Target Group (Where ELB sends traffic)
resource "aws_lb_target_group" "eln_target_group" {
  name        = "eln-backend-targets"
  port        = 8080 # The internal port your ELN software listens on
  protocol    = "HTTP"
  vpc_id      = "vpc-12345678"
  target_type = "instance"

  # Health Check to ensure the ELN application is active
  health_check {
    path                = "/healthz" # Your repository's health endpoint
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Listen on HTTP Port 80
resource "aws_lb_listener" "eln_http_listener" {
  load_balancer_arn = aws_lb.eln_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eln_target_group.arn
  }
}
