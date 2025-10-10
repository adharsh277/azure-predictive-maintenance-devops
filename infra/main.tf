# Random suffix for unique names
resource "random_integer" "suffix" {
  min = 100
  max = 999
}

# Use existing Resource Group
data "azurerm_resource_group" "rg" {
  name = "rg-predictive-maintenance"
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "pmpstorage${random_integer.suffix.result}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# IoT Hub
resource "azurerm_iothub" "iot" {
  name                = "pmpiothub${random_integer.suffix.result}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku {
    name     = "S1"
    capacity = 1
  }
}

# Event Hub Namespace
resource "azurerm_eventhub_namespace" "eh_ns" {
  name                = "pmp-eventhub-ns${random_integer.suffix.result}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Standard"
}

# Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "pmpregistry${random_integer.suffix.result}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "pmp-aks"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "pmpaks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}
