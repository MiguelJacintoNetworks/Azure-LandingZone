resource "msgraph_resource" "group" {
  url = "groups"

  body = {
    displayName     = var.display_name
    description     = var.description
    mailEnabled     = false
    mailNickname    = var.mail_nickname
    securityEnabled = true
  }
}

resource "msgraph_resource" "group_member" {
  for_each = toset(var.member_object_ids)

  url = "groups/${msgraph_resource.group.id}/members/$ref"

  body = {
    "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/${each.value}"
  }
}