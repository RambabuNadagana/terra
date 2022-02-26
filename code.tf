provider "aws" {
  region = "us-east-2"
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls11"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0f607673eab7d2eb7"
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/20"]
     }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "myrdsnewone"
  identifier           = "myrdsnewone"
  username             = "admin"
  password             = "Ramrebel56"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = ["sg-0bb5391635b3c304e"]
}
resource "aws_launch_configuration" "as_conf" {
  name_prefix   = var.name_prefix
  image_id      = var.image_id
  instance_type = var.instance_type
  security_groups    = var.security_groups
   key_name = "jenkins"
  iam_instance_profile = "ram-s3-role"
   user_data = templatefile("${path.module}/userdata.tftpl", {endpoint = aws_db_instance.default.endpoint,password = aws_db_instance.default.password})
}
resource "aws_autoscaling_group" "bar" {
  name                 = var.name 
  depends_on           = ["aws_launch_configuration.as_conf"]
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  target_group_arns   = [var.target_group_arns]
 availability_zones = var.availability_zones
 }

resource "aws_lb" "front_end" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0bb5391635b3c304e"]
  subnets            = ["subnet-004e41b3ff4a0aa5f","subnet-0080182dff1d4159a"]
}
resource "aws_lb_target_group" "front_end" {
  name     = "my-targets"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "vpc-0f607673eab7d2eb7"
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "80"
  protocol          = "HTTP"
   certificate_arn  = "arn:aws:elasticloadbalancing:us-east-2:931430496116:targetgroup/my-targets/26b72c4337de35a4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn

      }
}
