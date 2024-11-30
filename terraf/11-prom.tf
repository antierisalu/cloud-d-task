
# IAM Policy for Prometheus
resource "aws_iam_policy" "prometheus_policy" {
  name        = "PrometheusPolicy"
  description = "Policy for Prometheus to access AWS services"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "ec2:DescribeTags",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM Role for Prometheus
resource "aws_iam_role" "prometheus_role" {
  name               = "prom-eks"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Prometheus Policy to Prometheus Role
resource "aws_iam_role_policy_attachment" "prometheus_policy_attachment" {
  role       = aws_iam_role.prometheus_role.name
  policy_arn = aws_iam_policy.prometheus_policy.arn
}

# IAM Policy for Grafana (Optional: CloudWatch Metrics)
resource "aws_iam_policy" "grafana_policy" {
  name        = "GrafanaPolicy"
  description = "Policy for Grafana to access AWS services"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "cloudwatch:DescribeAlarms"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM Role for Grafana
resource "aws_iam_role" "grafana_role" {
  name               = "graf-eks"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Grafana Policy to Grafana Role
resource "aws_iam_role_policy_attachment" "grafana_policy_attachment" {
  role       = aws_iam_role.grafana_role.name
  policy_arn = aws_iam_policy.grafana_policy.arn
}


output "prometheus_role_arn" {
  value = aws_iam_role.prometheus_role.arn
}

output "grafana_role_arn" {
  value = aws_iam_role.grafana_role.arn
}