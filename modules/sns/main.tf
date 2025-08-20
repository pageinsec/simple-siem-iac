# SNS topic to send notifications when S3 buckets receive logs
# Sets up SNS topic for log processing
# One time per account

resource "aws_sns_topic" "siem_notification_topic" {
  name = "${var.env}-siem-notification-topic"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_sns_topic_policy" "siem_sns_policy" {
  arn    = aws_sns_topic.siem_notification_topic.arn
  policy = data.aws_iam_policy_document.siem_notification_policy.json
}

data "aws_iam_policy_document" "siem_notification_policy" {
  statement {
    sid       = "AllowS3EventNotifications"
    actions   = ["SNS:Publish"]
    effect    = "Allow"
    resources = [aws_sns_topic.siem_notification_topic.arn]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }

  statement {
    sid       = "AllowCloudTrailNotifications"
    actions   = ["SNS:Publish"]
    effect    = "Allow"
    resources = [aws_sns_topic.siem_notification_topic.arn]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid       = "AllowSubscriptionToPanther"
    actions   = ["SNS:Subscribe"]
    effect    = "Allow"
    resources = [aws_sns_topic.siem_notification_topic.arn]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.panther_account_id}:root"]
    }
  }
}

# Panther Subscription
resource "aws_sns_topic_subscription" "panther_subscription" {
  topic_arn            = aws_sns_topic.siem_notification_topic.arn
  protocol             = "sqs"
  endpoint             = "arn:aws:sqs:${var.panther_region}:${var.panther_account_id}:panther-input-data-notifications-queue"
  raw_message_delivery = false
}

# Scanner Subrciption
resource "aws_sns_topic_subscription" "scanner_subscription" {
  topic_arn = aws_sns_topic.siem_notification_topic.arn
  protocol  = "sqs"
  endpoint  = "arn:aws:sqs:${var.scanner_region}:${var.scanner_account_id}:scnr-S3ObjectCreatedNotificationsQueue"
}