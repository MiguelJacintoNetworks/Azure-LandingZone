data "azurerm_client_config" "current" {}

resource "azuread_application" "github_actions" {
  display_name = "gh-${var.project_name}-oidc"
}

resource "azuread_service_principal" "github_actions" {
  client_id = azuread_application.github_actions.client_id
}

resource "azuread_application_federated_identity_credential" "github_oidc" {
  application_id = azuread_application.github_actions.id

  display_name = "github-actions-oidc"

  audiences = ["api://AzureADTokenExchange"]

  issuer = "https://token.actions.githubusercontent.com"

  subject = "repo:${var.github_repository}:ref:refs/heads/${var.github_branch}"
}

resource "azuread_application_federated_identity_credential" "github_oidc_pull_request" {
  application_id = azuread_application.github_actions.id

  display_name = "github-actions-pull-request"

  audiences = ["api://AzureADTokenExchange"]

  issuer = "https://token.actions.githubusercontent.com"

  subject = "repo:${var.github_repository}:pull_request"
}

resource "azurerm_role_assignment" "github_actions_contributor" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.github_actions.object_id
}