#!/bin/bash

# Script para sincronizar aplicaciones de ArgoCD
# Uso: ./scripts/argo-sync.sh [test|staging|all]

set -e

ENVIRONMENT=${1:-all}

echo "🔄 Sincronizando aplicaciones de ArgoCD..."

# Verificar que ArgoCD está instalado
if ! kubectl get namespace argocd &> /dev/null; then
    echo "❌ Namespace argocd no existe. Por favor instala ArgoCD primero."
    exit 1
fi

sync_application() {
    local app_name=$1
    
    echo "🔄 Sincronizando aplicación: $app_name"
    
    if kubectl get application $app_name -n argocd &> /dev/null; then
        # Forzar sincronización
        kubectl patch application $app_name -n argocd --type merge -p '{"operation":{"sync":{}}}'
        echo "✅ Sincronización iniciada para $app_name"
        
        # Esperar a que se complete la sincronización
        echo "⏳ Esperando sincronización..."
        kubectl wait --for=condition=Synced application/$app_name -n argocd --timeout=300s || true
        
        # Verificar estado
        local sync_status=$(kubectl get application $app_name -n argocd -o jsonpath='{.status.sync.status}')
        local health_status=$(kubectl get application $app_name -n argocd -o jsonpath='{.status.health.status}')
        
        echo "📊 Estado de $app_name:"
        echo "  - Sync: $sync_status"
        echo "  - Health: $health_status"
    else
        echo "❌ Aplicación $app_name no existe"
    fi
    echo ""
}

case $ENVIRONMENT in
    "test")
        sync_application "myapp-test"
        ;;
    "staging")
        sync_application "myapp-staging"
        ;;
    "all")
        sync_application "myapp-test"
        sync_application "myapp-staging"
        ;;
    *)
        echo "❌ Opción no válida. Usa: test, staging o all"
        exit 1
        ;;
esac

echo "🎉 Sincronización completada!"
echo "🔍 Para ver el estado: ./scripts/argo-status.sh"
