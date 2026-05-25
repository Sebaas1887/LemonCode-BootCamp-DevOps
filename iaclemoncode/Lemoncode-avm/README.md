# Lemoncode AVM

Version alternativa del ejercicio que refactoriza la red para usar el Azure Verified Module de Virtual Network:

```hcl
source  = "Azure/avm-res-network-virtualnetwork/azurerm"
version = "0.17.1"
```

La VM se mantiene en el modulo local `modules/vm`. El NSG y la Public IP quedan en `modules/network` porque no son el equivalente directo del modulo VPC de AWS.

Esta carpeta usa la misma key de backend que la implementacion original (`tfstatelemon`) y nombres de recursos con sufijo `-avm` para no pisar los recursos existentes.
