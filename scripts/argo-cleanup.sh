#!/bin/bash

# Script para limpiar aplicaciones de ArgoCD
# Uso: ./scripts/argo-cleanup.sh [test|staging|all]

set -e

ENVIRONMENT=${1:-all}

echo "🧹 Limpiando aplicaciones de ArgoCD..."

# Verificar que ArgoCD está instalado
if ! kubectl get namespace argocd &> /dev/null; then
    echo "❌ Namespace argocd no existe. ArgoCD no está instalado."
    exit 1
fi

cleanup_application() {
    local app_name=$1
    local namespace=$2
    
    echo "🗑️  Limpiando aplicación: $app_name"
    
    if kubectl get application $app_name -n argocd &> /dev/null; then
        # Eliminar aplicación de ArgoCD
        kubectl delete application $app_name -n argocd
        echo "✅ Aplicación $app_name eliminada de ArgoCD"
        
        # Esperar a que se eliminen los recursos
        echo "⏳ Esperando eliminación de recursos..."
        sleep 10
        
        # Eliminar namespace si existe
        if kubectl get namespace $namespace &> /dev/null; then
            kubectl delete namespace $namespace --ignore-not-found=true
            echo "✅ Namespace $namespace eliminado"
        fi
    else
        echo "ℹ️  Aplicación $app_name no existe"
    fi
    echo ""
}

case $ENVIRONMENT in
    "test")
        cleanup_application "myapp-test" "myapp-test"
        ;;
    "staging")
        cleanup_application "myapp-staging" "myapp-staging"
        ;;
    "all")
        cleanup_application "myapp-test" "myapp-test"
        cleanup_application "myapp-staging" "myapp-staging"
        ;;
    *)
        echo "❌ Opción no válida. Usa: test, staging o all"
        exit 1
        ;;
esac

echo "🎉 Limpieza completada!"
echo "🔍 Para verificar: kubectl get applications -n argocd"
