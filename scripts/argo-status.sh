#!/bin/bash

# Script para verificar el estado de las aplicaciones de ArgoCD
# Uso: ./scripts/argo-status.sh

set -e

echo "🔍 Verificando estado de las aplicaciones de ArgoCD..."
echo ""

# Verificar que ArgoCD está instalado
if ! kubectl get namespace argocd &> /dev/null; then
    echo "❌ Namespace argocd no existe. Por favor instala ArgoCD primero."
    exit 1
fi

# Verificar aplicaciones de ArgoCD
echo "📦 Aplicaciones de ArgoCD:"
kubectl get applications -n argocd | grep myapp || echo "No se encontraron aplicaciones de myapp"
echo ""

# Verificar estado detallado de cada aplicación
echo "📊 Estado detallado:"
for app in myapp-test myapp-staging; do
    if kubectl get application $app -n argocd &> /dev/null; then
        echo "🔍 Aplicación: $app"
        kubectl get application $app -n argocd -o jsonpath='{.status.sync.status}' 2>/dev/null && echo " - Sync Status: $(kubectl get application $app -n argocd -o jsonpath='{.status.sync.status}')" || echo " - Sync Status: Unknown"
        kubectl get application $app -n argocd -o jsonpath='{.status.health.status}' 2>/dev/null && echo " - Health Status: $(kubectl get application $app -n argocd -o jsonpath='{.status.health.status}')" || echo " - Health Status: Unknown"
        echo ""
    else
        echo "❌ Aplicación $app no existe"
        echo ""
    fi
done

# Verificar namespaces de destino
echo "🏷️  Namespaces de destino:"
kubectl get namespaces | grep myapp || echo "No se encontraron namespaces de myapp"
echo ""

# Verificar recursos en cada namespace
for namespace in myapp-test myapp-staging; do
    if kubectl get namespace $namespace &> /dev/null; then
        echo "📊 Recursos en $namespace:"
        kubectl get all -n $namespace 2>/dev/null || echo "No hay recursos en $namespace"
        echo ""
    else
        echo "❌ Namespace $namespace no existe"
        echo ""
    fi
done

# Verificar logs de ArgoCD
echo "📝 Logs de ArgoCD (últimas 10 líneas):"
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server --tail=10 2>/dev/null || echo "No se pudieron obtener logs de ArgoCD"
echo ""

echo "🎯 Comandos útiles:"
echo "  - Ver aplicaciones: kubectl get applications -n argocd"
echo "  - Ver detalles: kubectl describe application myapp-test -n argocd"
echo "  - Sincronizar: kubectl patch application myapp-test -n argocd --type merge -p '{\"operation\":{\"sync\":{}}}'"
echo "  - Ver UI de ArgoCD: kubectl port-forward -n argocd svc/argocd-server 8080:443"
