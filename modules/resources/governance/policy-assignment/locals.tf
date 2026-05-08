locals {
  normalized_subscription_id = (
    startswith(var.subscription_id, "/subscriptions/")
    ? var.subscription_id
    : "/subscriptions/${var.subscription_id}"
  )
}