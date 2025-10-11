resource "azurerm_log_analytics_workspace" "law" {
  name                = "pmp-law-${random_integer.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


## diagnostic setting 

resource "azurerm_monitor_diagnostic_setting" "iot_diag" {
  name               = "iot-diagnostics-${random_integer.suffix.result}"
  target_resource_id = azurerm_iothub.iot.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  log {
    category = "OperationsMonitoringEvents"
    enabled  = true
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
