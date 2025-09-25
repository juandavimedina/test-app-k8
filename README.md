# Test App K8

Una aplicación de prueba para experimentar con Kubernetes y despliegues en contenedores.

## 📋 Descripción

Esta es una aplicación de prueba diseñada para aprender y experimentar con:

- Despliegues en Kubernetes
- Configuración de contenedores
- CI/CD pipelines
- Monitoreo y logging

## 🚀 Características

- [ ] Aplicación web básica
- [ ] Configuración de Kubernetes
- [ ] Scripts de despliegue
- [ ] Configuración de CI/CD
- [ ] Monitoreo básico

## 🛠️ Tecnologías

- **Backend**: Node.js / Python / Go (por definir)
- **Frontend**: React / Vue.js / HTML (por definir)
- **Containerización**: Docker
- **Orquestación**: Kubernetes
- **CI/CD**: GitHub Actions / GitLab CI

## 📦 Instalación

### Prerrequisitos

- Docker instalado
- kubectl configurado
- Minikube o cluster de Kubernetes

### Pasos de instalación

1. Clona el repositorio:

```bash
git clone <url-del-repositorio>
cd test-app-k8
```

2. Construye la imagen Docker:

```bash
docker build -t test-app-k8 .
```

3. Despliega en Kubernetes:

```bash
kubectl apply -f k8s/
```

## 🏃‍♂️ Uso

### Desarrollo local

```bash
# Ejecutar la aplicación localmente
npm start
# o
python app.py
# o
go run main.go
```

### En Kubernetes

```bash
# Verificar el estado del despliegue
kubectl get pods
kubectl get services

# Acceder a la aplicación
kubectl port-forward service/test-app-k8 8080:80
```

## 📁 Estructura del proyecto

```
test-app-k8/
├── src/                    # Código fuente de la aplicación
├── k8s/                    # Manifiestos de Kubernetes
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
├── docker/                 # Archivos de Docker
│   └── Dockerfile
├── scripts/                # Scripts de utilidad
├── tests/                  # Tests unitarios e integración
├── docs/                   # Documentación adicional
└── README.md
```

## 🧪 Testing

### Tests unitarios

```bash
npm test
# o
python -m pytest
# o
go test ./...
```

### Tests de integración

```bash
# Ejecutar tests contra el cluster
kubectl apply -f tests/integration/
```

## 🚀 Despliegue

### Desarrollo

```bash
# Desplegar en namespace de desarrollo
kubectl apply -f k8s/ -n development
```

### Producción

```bash
# Desplegar en namespace de producción
kubectl apply -f k8s/ -n production
```

## 📊 Monitoreo

### Logs

```bash
# Ver logs de la aplicación
kubectl logs -f deployment/test-app-k8
```

### Métricas

```bash
# Ver métricas del pod
kubectl top pod
```

## 🔧 Configuración

### Variables de entorno

Las siguientes variables pueden ser configuradas:

- `PORT`: Puerto de la aplicación (default: 8080)
- `ENV`: Entorno de ejecución (development/production)
- `LOG_LEVEL`: Nivel de logging (debug/info/warn/error)

### ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: test-app-config
data:
  PORT: "8080"
  ENV: "development"
  LOG_LEVEL: "info"
```

## 🐛 Troubleshooting

### Problemas comunes

1. **Pod no inicia**

   ```bash
   kubectl describe pod <pod-name>
   kubectl logs <pod-name>
   ```

2. **Servicio no accesible**

   ```bash
   kubectl get services
   kubectl describe service <service-name>
   ```

3. **Problemas de recursos**
   ```bash
   kubectl top nodes
   kubectl top pods
   ```

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Changelog

### [0.1.0] - 2024-01-XX

- Versión inicial
- Configuración básica de Kubernetes
- Documentación inicial

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 📞 Contacto

- **Desarrollador**: [Tu Nombre]
- **Email**: [tu-email@ejemplo.com]
- **Proyecto**: [https://github.com/tu-usuario/test-app-k8]

## 🙏 Agradecimientos

- Comunidad de Kubernetes
- Documentación oficial de Docker
- Tutoriales y ejemplos de la comunidad

---

**Nota**: Este es un proyecto de prueba. No usar en producción sin las debidas consideraciones de seguridad y rendimiento.
