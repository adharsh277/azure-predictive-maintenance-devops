STORAGE_ACCOUNT_NAME="pmpstorage$(terraform output -raw random_suffix)"

az monitor diagnostic-settings create \
  --resource $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP \
  --name "storage-diagnostics" \
  --workspace $(az monitor log-analytics workspace show --resource-group $RESOURCE_GROUP --workspace-name $WORKSPACE_NAME --query id -o tsv) \
  --logs '[{"category": "StorageRead","enabled": true},{"category": "StorageWrite","enabled": true},{"category": "StorageDelete","enabled": true}]' \
  --metrics '[{"category": "AllMetrics","enabled": true}]'

# Example: Check last 24h IoT Hub events
az monitor log-analytics query \
  --workspace $(az monitor log-analytics workspace show --resource-group $RESOURCE_GROUP --workspace-name $WORKSPACE_NAME --query id -o tsv) \
  --query "IoTHubDiagnostics | where TimeGenerated > ago(24h)"
