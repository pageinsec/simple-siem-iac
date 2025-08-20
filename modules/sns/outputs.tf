output "siem_notification_topic_arn" {
  value = aws_sns_topic.siem_notification_topic.arn
}

output "aws_sns_topic_subscription_panther_arn" {
  value = aws_sns_topic_subscription.panther_subscription.arn
}
