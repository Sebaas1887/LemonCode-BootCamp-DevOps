RETO 1

```bash
docker network create lemoncode_seba
```
Creamos la red.

```bash
docker network ls
```
Verificamos que se creo correctamente.

```bash
docker volume create database_seba
```
Creamos el volumen para la base de datos.

```bash
docker run -d --name mongodb_seba --network lemoncode_seba -p 27017:27017 --mount type=volume,source=database_seba,target=/data/db -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password mongo:8.2-rc
```
Creamos el contenedor de Mongo, lo conectamos a la red, exponemos el puerto `27017`, montamos el volumen y usamos la imagen oficial (`mongo:8.2-rc`).

```bash
docker container ls
```
Verificamos que el contenedor se creo correctamente.

Nota: la extension de Dev Containers no funciono correctamente.

Capturas:
No hay capturas para este reto.

RETO 2

Desde Visual Studio, con la extension de containers: `> Containers: Add Dockerfile to current workspace`.

```bash
docker build -t backend_seba:v1 .
```
Desde la carpeta del backend (Node) construimos la imagen.

```bash
docker image ls
```
Revisamos que la imagen este creada.

```bash
docker run -d --name backend_seba --network lemoncode_seba -p 5000:5000 -e DATABASE_URL="mongodb://admin:password@mongodb_seba:27017/?authSource=admin" -e DATABASE_NAME="LemoncodeCourseDb" -e HOST="0.0.0.0" -e PORT="5000" backend_seba:v1
```
Levantamos el contenedor del backend con sus variables de entorno.

```bash
docker container ls
```
Verificamos que este levantado.

```bash
docker logs backend_seba
```
Comprobamos en logs la conexion con la base de datos (conexion exitosa).

Con Postman probamos:

```bash
GET http://localhost:5000/api/classes
```

Capturas:

![Reto 2 - Docker y backend](./Reto2/reto2.png)
![Reto 2 - GET clases](./Reto2/reto2get.png)
![Reto 2 - POST clases](./Reto2/reto2post.png)

RETO 3

Desde Visual Studio, con la extension de containers: `> Containers: Add Dockerfile to current workspace` (puerto 3000).

Modificacion en `env.sample`:

```bash
API_URL=http://backend_seba:5000/api/classes
```

```bash
docker build -t frontend_seba:v1 .
```
Construimos la imagen del frontend.

```bash
docker image ls
```
Validamos que la imagen exista.

```bash
docker run -d --name frontend_seba --network lemoncode_seba -p 3000:3000 --env-file .env-sample frontend_seba:v1
```
Levantamos el contenedor del frontend.

```bash
docker container ls
```
Comprobamos que el contenedor este activo.

```bash
docker logs frontend_seba
```
Revisamos logs (todo OK).

Prueba en navegador:

```bash
http://localhost:3000/
```

Capturas:

![Reto 3 - Frontend funcionando](./Reto3/reto3.png)

RETO 4

Desde `node-stack`:

```bash
docker compose up -d
docker ps
```

Capturas:

![Reto 4 - Compose](./Reto4/reto4.png)
![Reto 4 - Web](./Reto4/reto4web.png)
