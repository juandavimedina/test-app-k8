# MyApp K8 - Helm Chart con ArgoCD

Una aplicación de prueba con Helm Charts y ArgoCD para experimentar con GitOps, Kubernetes y despliegues en contenedores con dos entornos.

## 📋 Descripción

Esta es una aplicación de prueba diseñada para aprender y experimentar con:

- **Helm Charts** básicos para gestión de aplicaciones
- **ArgoCD** para GitOps y despliegues automáticos
- **Dos entornos**: Test y Staging
- **Solo Deployment y Service** - sin características adicionales
- Despliegues en Kubernetes
- Configuración de contenedores
- **GitOps** con sincronización automática

## 🚀 Características

- ✅ **Helm Chart** simple con solo deployment y service
- ✅ **ArgoCD** para GitOps y despliegues automáticos
- ✅ **Dos entornos**: Test y Staging
- ✅ **Scripts de despliegue** automatizados
- ✅ **Configuración flexible** con values files
- ✅ **Sincronización automática** con Git
- ✅ **Sin complejidades** - solo lo esencial

## 🛠️ Tecnologías

- **Orquestación**: Kubernetes + Helm
- **GitOps**: ArgoCD
- **Containerización**: Docker
- **Gestión de configuración**: Helm Values
- **Sincronización**: Git + ArgoCD

## 📦 Instalación

### Prerrequisitos

- **Helm 3.x** instalado
- **kubectl** configurado
- **ArgoCD** instalado en el cluster
- **Minikube** o cluster de Kubernetes
- **Docker** para construir imágenes
- **Git** repository con acceso

### Instalación de Helm

```bash
# macOS
brew install helm

# Linux
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Windows
choco install kubernetes-helm
```

### Instalación de ArgoCD

```bash
# Crear namespace
kubectl create namespace argocd

# Instalar ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Esperar a que esté listo
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Obtener contraseña del admin
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Pasos de instalación

1. **Clona el repositorio:**

```bash
git clone https://github.com/juandavimedina/test-app-k8.git
cd test-app-k8
```

2. **Construye la imagen Docker:**

```bash
docker build -t djmedinapkvelostics/test-1:0.1.0 .
```

3. **Despliega usando Helm:**

```bash
# Entorno de TEST
./scripts/deploy-test.sh

# Entorno de STAGING
./scripts/deploy-staging.sh
```

## 🏃‍♂️ Uso

### Despliegue rápido con ArgoCD

```bash
# Desplegar aplicaciones con ArgoCD
./scripts/argo-deploy.sh all

# Verificar estado de las aplicaciones
./scripts/argo-status.sh

# Sincronizar aplicaciones
./scripts/argo-sync.sh all

# Acceder a la UI de ArgoCD
./scripts/argo-ui.sh
```

## 🚀 Despliegue con ArgoCD (GitOps)

### Despliegue automático con ArgoCD

```bash
# Desplegar aplicaciones con ArgoCD
./scripts/argo-deploy.sh test
./scripts/argo-deploy.sh staging
./scripts/argo-deploy.sh all

# Verificar estado de las aplicaciones
./scripts/argo-status.sh

# Sincronizar aplicaciones
./scripts/argo-sync.sh test
./scripts/argo-sync.sh staging
./scripts/argo-sync.sh all

# Acceder a la UI de ArgoCD
./scripts/argo-ui.sh

# Limpiar aplicaciones de ArgoCD
./scripts/argo-cleanup.sh all
```

### Despliegue manual con ArgoCD

```bash
# Aplicar aplicaciones de ArgoCD
kubectl apply -f argocd/myapp-test.yaml
kubectl apply -f argocd/myapp-staging.yaml

# Verificar aplicaciones
kubectl get applications -n argocd

# Sincronizar manualmente
kubectl patch application myapp-test -n argocd --type merge -p '{"operation":{"sync":{}}}'
kubectl patch application myapp-staging -n argocd --type merge -p '{"operation":{"sync":{}}}'
```

### Despliegue manual con Helm (alternativo)

```bash
# Entorno TEST
helm upgrade --install myapp-test ./myapp \
  --namespace myapp-test \
  --create-namespace \
  --values ./myapp/values-test.yaml

# Entorno STAGING
helm upgrade --install myapp-staging ./myapp \
  --namespace myapp-staging \
  --create-namespace \
  --values ./myapp/values-staging.yaml
```

### Verificar despliegues

```bash
# Ver todos los releases
helm list --all-namespaces

# Ver estado de los pods
kubectl get pods -n myapp-test
kubectl get pods -n myapp-staging

# Ver servicios
kubectl get svc -n myapp-test
kubectl get svc -n myapp-staging
```

### Acceder a la aplicación

```bash
# TEST (namespace: myapp-test)
kubectl port-forward -n myapp-test service/myapp-test 8080:8080

# STAGING (namespace: myapp-staging)
kubectl port-forward -n myapp-staging service/myapp-staging 8080:8080

# Luego visita: http://localhost:8080
```

### Verificar namespaces

```bash
# Ver todos los namespaces de myapp
kubectl get namespaces | grep myapp

# Ver recursos en cada namespace
kubectl get all -n myapp-test
kubectl get all -n myapp-staging

# Ver estado completo con ArgoCD
./scripts/argo-status.sh
```

## 📁 Estructura del proyecto

```
test-app-k8/
├── myapp/                     # Helm Chart
│   ├── Chart.yaml            # Metadatos del chart
│   ├── values.yaml           # Valores por defecto
│   ├── values-test.yaml      # Configuración para TEST
│   ├── values-staging.yaml   # Configuración para STAGING
│   └── templates/            # Templates de Kubernetes
│       ├── deployment.yaml   # Template de deployment
│       ├── service.yaml      # Template de service
│       └── _helpers.tpl      # Funciones auxiliares
├── argocd/                  # Configuración de ArgoCD
│   ├── myapp-test.yaml      # Aplicación TEST
│   ├── myapp-staging.yaml   # Aplicación STAGING
│   └── app-of-apps.yaml     # App of Apps
├── scripts/                  # Scripts de ArgoCD
│   ├── argo-deploy.sh       # Desplegar con ArgoCD
│   ├── argo-status.sh       # Estado de ArgoCD
│   ├── argo-sync.sh         # Sincronizar ArgoCD
│   ├── argo-cleanup.sh      # Limpiar ArgoCD
│   └── argo-ui.sh           # Acceder a UI de ArgoCD
└── README.md
```

## 🔧 Configuración

### Namespaces separados

Cada entorno se ejecuta en su propio namespace para garantizar el aislamiento completo:

- **TEST**: `myapp-test` namespace
- **STAGING**: `myapp-staging` namespace

Esto significa que:

- ✅ Los recursos están completamente separados
- ✅ No hay conflictos entre entornos
- ✅ Cada entorno puede tener configuraciones diferentes
- ✅ Fácil limpieza y gestión independiente

### Entornos disponibles

#### TEST Environment

- **Namespace**: `myapp-test`
- **Replicas**: 1
- **Imagen**: `djmedinapkvelostics/test-1:test-latest`
- **Service**: ClusterIP en puerto 8080

#### STAGING Environment

- **Namespace**: `myapp-staging`
- **Replicas**: 3
- **Imagen**: `djmedinapkvelostics/test-1:staging-latest`
- **Service**: ClusterIP en puerto 8080

### Personalizar configuración

```bash
# Editar configuración de TEST
vim myapp/values-test.yaml

# Editar configuración de STAGING
vim myapp/values-staging.yaml

# Aplicar cambios
helm upgrade myapp-test ./myapp -n myapp-test --values ./myapp/values-test.yaml
```

## 🧪 Testing

### Tests del Chart

```bash
# Validar el chart
helm lint ./myapp

# Probar el template
helm template myapp ./myapp --values ./myapp/values-test.yaml

# Dry-run del despliegue
helm install myapp-test ./myapp --dry-run --debug
```

### Tests de integración

```bash
# Verificar que los pods están funcionando
kubectl get pods -n myapp-test
kubectl get pods -n myapp-staging

# Verificar logs
kubectl logs -n myapp-test deployment/myapp-test
kubectl logs -n myapp-staging deployment/myapp-staging
```

## 🚀 Despliegue

### Desarrollo (TEST)

```bash
# Desplegar en TEST
./scripts/deploy-test.sh

# Verificar
kubectl get all -n myapp-test
```

### Pre-producción (STAGING)

```bash
# Desplegar en STAGING
./scripts/deploy-staging.sh

# Verificar
kubectl get all -n myapp-staging
```

## 📊 Monitoreo

### Logs

```bash
# Logs de TEST
kubectl logs -f -n myapp-test deployment/myapp-test

# Logs de STAGING
kubectl logs -f -n myapp-staging deployment/myapp-staging
```

### Estado de los recursos

```bash
# Ver todos los recursos
kubectl get all -n myapp-test
kubectl get all -n myapp-staging

# Ver detalles de los pods
kubectl describe pods -n myapp-test
kubectl describe pods -n myapp-staging
```

## 🔧 Configuración avanzada

### Variables de entorno

```yaml
# En values-test.yaml o values-staging.yaml
env:
  - name: ENV
    value: "test" # o "staging"
  - name: PORT
    value: "8080"
```

### Cambiar imagen

```bash
# Cambiar imagen para TEST
helm upgrade myapp-test ./myapp -n myapp-test \
  --set app.image.repository=mi-registry/mi-app \
  --set app.image.tag=v2.0.0

# Cambiar imagen para STAGING
helm upgrade myapp-staging ./myapp -n myapp-staging \
  --set app.image.repository=mi-registry/mi-app \
  --set app.image.tag=v2.0.0
```

### Cambiar número de réplicas

```bash
# Cambiar réplicas para TEST
helm upgrade myapp-test ./myapp -n myapp-test \
  --set deployment.replicas=2

# Cambiar réplicas para STAGING
helm upgrade myapp-staging ./myapp -n myapp-staging \
  --set deployment.replicas=5
```

## 🐛 Troubleshooting

### Problemas comunes

1. **Chart no se instala**

   ```bash
   helm lint ./myapp
   helm template myapp ./myapp --debug
   ```

2. **Pod no inicia**

   ```bash
   kubectl describe pod -n myapp-test <pod-name>
   kubectl logs -n myapp-test <pod-name>
   ```

3. **Servicio no accesible**
   ```bash
   kubectl get svc -n myapp-test
   kubectl describe svc -n myapp-test myapp-test
   ```

### Comandos útiles

```bash
# Ver todos los recursos
kubectl get all -n myapp-test
kubectl get all -n myapp-staging

# Ver eventos
kubectl get events -n myapp-test --sort-by='.lastTimestamp'
kubectl get events -n myapp-staging --sort-by='.lastTimestamp'

# Debug del chart
helm get values myapp-test -n myapp-test
helm get values myapp-staging -n myapp-staging
```

## 🧹 Limpieza

```bash
# Limpiar aplicaciones de ArgoCD
./scripts/argo-cleanup.sh test
./scripts/argo-cleanup.sh staging
./scripts/argo-cleanup.sh all

# Limpieza manual de Helm (si se usó)
helm uninstall myapp-test -n myapp-test
helm uninstall myapp-staging -n myapp-staging
kubectl delete namespace myapp-test
kubectl delete namespace myapp-staging
```

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Changelog

### [0.1.0] - 2024-01-XX

- Versión inicial con Helm Chart simple
- Configuración para entornos TEST y STAGING
- Solo deployment y service
- Scripts de despliegue automatizados
- Documentación completa

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 📞 Contacto

- **Desarrollador**: Juan David Medina
- **Email**: djmedinapkvelostics@example.com
- **Proyecto**: [https://github.com/juandavimedina/test-app-k8]

## 🙏 Agradecimientos

- Comunidad de Kubernetes
- Documentación oficial de Helm
- Tutoriales y ejemplos de la comunidad

---

**Nota**: Este es un proyecto de prueba simple. Solo incluye deployment y service para mantener la simplicidad.
