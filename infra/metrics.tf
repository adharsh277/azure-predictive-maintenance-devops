resource "azurerm_monitor_metric_alert" "iot_msg_alert" {
  name                = "iot-msg-alert-${random_integer.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_iothub.iot.id]
  description         = "Alert if messages exceed threshold"
  severity            = 3
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Devices/IotHubs"
    metric_name      = "TotalMessages"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 100
  }
}
