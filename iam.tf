## 
## The IAM roles related to the Test Lambda function.
##
resource "aws_iam_role" "test_lambda" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "test_lambda" {
  policy_arn = "${aws_iam_policy.test_lambda.arn}"
  role = "${aws_iam_role.test_lambda.name}"
}

resource "aws_iam_policy" "test_lambda" {
  policy = "${data.aws_iam_policy_document.test_lambda.json}"
}

data "aws_iam_policy_document" "test_lambda" {

  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.aws_region}:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.aws_region}:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

}