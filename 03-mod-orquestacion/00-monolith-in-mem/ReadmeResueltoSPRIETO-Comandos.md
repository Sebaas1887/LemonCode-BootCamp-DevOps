Lo primero, desde docker hub hago un pull de la imagen: lemoncodersbc/lc-todo-monolith:v5-2024

docker images para revisar si esta la imagen y la ejecutamos localmente

```bash
docker images
```

```bash
docker run -p 3000:3000 lemoncodersbc/lc-todo-monolith:v5-2024
```
![02pruebalocal](./capturas/02pruebalocal.png)
![01pruebalocal](./capturas/01pruebalocal.png)

Lo que hago ahora es desde docker ver mas o menos cuanto consume

![03pruebalocal](./capturas/03pruebalocal.png)

Uso eso para setear los request y le doy un poquito mas para los limites. Tambien agrego liveness y readiness probes

Hacemos un 

```bash
minikube start
```

![01minikube](./capturas/01minikube.png)

```bash
kubectl apply -f .
```
Ejecuto los siguientes commandos:

```bash
kubectl get deployments
kubectl get pods
kubectl get svc
kubectl get ns
kubectl get pods -n default
```
![02minikube](./capturas/02minikube.png)

Me di cuenta que no especifique namespace.

Agrego namespace "seba" en el deployment.yaml y "kubectl apply -f ." de nuevo

![03minikube](./capturas/03minikube.png)

Ejecuto "minikube service todo-monolith-lb-seba -n seba" para ver como entrar al service

```bash
minikube service todo-monolith-lb-seba -n seba
```
![04minikube](./capturas/04minikube.png)

![05minikube](./capturas/05minikube.png)