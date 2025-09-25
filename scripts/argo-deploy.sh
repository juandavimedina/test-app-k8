#!/bin/bash

# Script para desplegar aplicaciones con ArgoCD
# Uso: ./scripts/argo-deploy.sh [test|staging|all]

set -e

ENVIRONMENT=${1:-all}

echo "🚀 Desplegando aplicaciones con ArgoCD..."

# Verificar que kubectl está configurado
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl no está instalado. Por favor instala kubectl primero."
    exit 1
fi

# Verificar que ArgoCD está instalado
if ! kubectl get namespace argocd &> /dev/null; then
    echo "❌ Namespace argocd no existe. Por favor instala ArgoCD primero."
    echo "   Instrucciones: https://argo-cd.readthedocs.io/en/stable/getting_started/"
    exit 1
fi

deploy_application() {
    local app_name=$1
    local app_file=$2
    
    echo "📦 Desplegando aplicación: $app_name"
    
    if kubectl get application $app_name -n argocd &> /dev/null; then
        echo "🔄 Aplicación $app_name ya existe, actualizando..."
        kubectl apply -f $app_file
    else
        echo "🆕 Creando nueva aplicación: $app_name"
        kubectl apply -f $app_file
    fi
    
    echo "⏳ Esperando sincronización..."
    kubectl wait --for=condition=Synced application/$app_name -n argocd --timeout=300s || true
    
    echo "✅ Aplicación $app_name desplegada"
}

case $ENVIRONMENT in
    "test")
        deploy_application "myapp-test" "argocd/myapp-test.yaml"
        ;;
    "staging")
        deploy_application "myapp-staging" "argocd/myapp-staging.yaml"
        ;;
    "all")
        deploy_application "myapp-test" "argocd/myapp-test.yaml"
        deploy_application "myapp-staging" "argocd/myapp-staging.yaml"
        ;;
    *)
        echo "❌ Opción no válida. Usa: test, staging o all"
        exit 1
        ;;
esac

echo ""
echo "🎉 Despliegue con ArgoCD completado!"
echo "🔍 Para ver el estado de las aplicaciones:"
echo "   kubectl get applications -n argocd"
echo "   kubectl get pods -n myapp-test"
echo "   kubectl get pods -n myapp-staging"
