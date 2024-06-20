data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "access_cloudwatch" {
  statement {
    effect    = "Allow"
    actions   = ["logs:*"]
    resources = [
      "${aws_cloudwatch_log_group.backend.arn}:*",
      "${aws_cloudwatch_log_group.frontend.arn}:*",
      "${aws_cloudwatch_log_group.database.arn}:*",
      "${aws_cloudwatch_log_group.nginx.arn}:*",
    ]
  }
}

resource "aws_iam_role" "cloudwatch" {
  name               = "CloudWatchLogsRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "cloudwatch" {
  role   = aws_iam_role.cloudwatch.id
  policy = data.aws_iam_policy_document.access_cloudwatch.json
}
