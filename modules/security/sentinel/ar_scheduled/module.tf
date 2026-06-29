resource "azurerm_sentinel_alert_rule_scheduled" "scheduled" {
  name                       = var.name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  display_name               = var.display_name
  severity                   = var.severity
  query                      = var.query
  alert_rule_template_guid   = var.alert_rule_template_guid
  description                = var.description
  enabled                    = var.enabled
  query_frequency            = var.query_frequency
  query_period               = var.query_period
  suppression_duration       = var.suppression_duration
  suppression_enabled        = var.suppression_enabled
  tactics                    = var.tactics
  trigger_operator           = var.trigger_operator
  trigger_threshold          = var.trigger_threshold

  dynamic "event_grouping" {
    for_each = lookup(var.settings, "event_grouping", {}) != {} ? [1] : []

    content {
      aggregation_method = lookup(var.settings.event_grouping, "aggregation_method", null)
    }
  }

  dynamic "incident" {
    for_each = lookup(var.settings, "incident", {}) != {} || lookup(var.settings, "incident_configuration", {}) != {} ? [merge(try(var.settings.incident, {}), try(var.settings.incident_configuration, {}))] : []

    content {
      create_incident_enabled = try(incident.value.create_incident_enabled, incident.value.create_incident, null)

      dynamic "grouping" {
        for_each = [try(incident.value.grouping, {})]

        content {
          enabled                 = try(grouping.value.enabled, true)
          lookback_duration       = try(grouping.value.lookback_duration, "PT5M")
          reopen_closed_incidents = try(grouping.value.reopen_closed_incidents, false)
          entity_matching_method  = try(grouping.value.entity_matching_method, null)
          by_entities             = try(grouping.value.by_entities, grouping.value.group_by_entities, null)
          by_alert_details        = try(grouping.value.by_alert_details, grouping.value.group_by_alert_details, null)
          by_custom_details       = try(grouping.value.by_custom_details, grouping.value.group_by_custom_details, null)
        }
      }
    }
  }
}
