resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3_bucket_lb_write.json
}




data "aws_iam_policy_document" "s3_bucket_lb_write" {
  policy_id = "s3_bucket_lb_logs"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]

    principals {
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect    = "Allow"
    resources = ["arn:aws:s3:::alb-logs-tk/tf-alb/AWSLogs/123905443795/*"]
    principals {
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
      type        = "Service"
    }
  }


  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.this.arn}"]
    principals {
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
      type        = "Service"
    }
  }
}
