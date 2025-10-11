# Variables
RESOURCE_GROUP="rg-predictive-maintenance"
LOCATION="eastasia"
WORKSPACE_NAME="pmp-log-analytics"

# Create Log Analytics workspace
az monitor log-analytics workspace create \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $WORKSPACE_NAME \
  --location $LOCATION

# Variables
IOT_HUB_NAME="pmpiothub$(terraform output -raw random_suffix)"
DIAG_NAME="iothub-diagnostics"

# Enable diagnostic logs to Log Analytics
az monitor diagnostic-settings create \
  --resource $IOT_HUB_NAME \
  --resource-group $RESOURCE_GROUP \
  --name $DIAG_NAME \
  --workspace $(az monitor log-analytics workspace show --resource-group $RESOURCE_GROUP --workspace-name $WORKSPACE_NAME --query id -o tsv) \
  --logs '[{"category": "OperationsMonitoringEvents","enabled": true}]' \
  --metrics '[{"category": "AllMetrics","enabled": true}]'
