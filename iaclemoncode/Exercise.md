# IaC Ejercicios

## Terraform AWS

1. Crea una VPC (recurso VPC) que tenga acceso a internet, para ello debes tener en cuenta los siguientes puntos:
   - Asigna un CIDR block para la VPC
   - Elige una región adecuada
   - Crea un recurso internet gateway y asícialo al recurso de la VPC

2. Crea una subnet dentro la VPC, la subnet debe tener acceso a internet
   - Crea un recurso de subnet
   - Crea un recurso de route table
     - Define una ruta que redireccione a todas las IPs a la internet gateway
   - Asocia la tabla de rutas anterior con la subnet

3. Crea un security groups que permitan el tráfico sobre el puerto 80 para todas las IPs, y sólo para la tuya en el puerto 22 (opcional)

4. Crea un recurso key pair (https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair.html) para poder acceder a una EC2

5. Crea una instancia que se despliegue en la subnet que has creado
   - Asocia el key pair name a la instancia
   - Conéctate vía SSH  
   IMPORTANTE: Usa una free tier AMI

6. Añade una entrada en el `user_data` que instale Docker

7. Crea un output con la IP pública de la instancia que has desplegado
   - Para poder ver algo vía HTTP, debes tener algo que nos sirva en el puerto 80. Conéctate vía SSH y despliega un NGINX container vía docker

8. Refactoriza tu código para que use el VPC Module (https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)

## Notas

Los puntos 1, 2, 3, 4 son gratuitos, a partir del 5, empezamos a incurrir en gastos.  
Recuerda siempre usar `terraform destroy` para no incurrir en gastos innecesarios.