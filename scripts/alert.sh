# Create metric alert for IoT Hub CPU / message count
az monitor metrics alert create \
  --name "IoTMessageAlert" \
  --resource-group $RESOURCE_GROUP \
  --scopes $(az iot hub show --name $IOT_HUB_NAME --resource-group $RESOURCE_GROUP --query id -o tsv) \
  --condition "total messages > 100" \
  --description "Alert if IoT Hub messages exceed 100 in 5 minutes" \
  --action "/subscriptions/<sub_id>/resourceGroups/<rg>/providers/Microsoft.Insights/actionGroups/<actiongroup>"
