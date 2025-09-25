#!/bin/bash

# Script para acceder a la UI de ArgoCD
# Uso: ./scripts/argo-ui.sh

set -e

echo "🌐 Accediendo a la UI de ArgoCD..."

# Verificar que ArgoCD está instalado
if ! kubectl get namespace argocd &> /dev/null; then
    echo "❌ Namespace argocd no existe. Por favor instala ArgoCD primero."
    exit 1
fi

# Verificar que el servicio de ArgoCD está disponible
if ! kubectl get svc argocd-server -n argocd &> /dev/null; then
    echo "❌ Servicio argocd-server no encontrado. Verifica la instalación de ArgoCD."
    exit 1
fi

# Obtener la contraseña del admin
echo "🔑 Obteniendo contraseña del admin..."
ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "📋 Información de acceso a ArgoCD:"
echo "  - URL: https://localhost:8080"
echo "  - Usuario: admin"
echo "  - Contraseña: $ADMIN_PASSWORD"
echo ""

# Iniciar port-forward
echo "🚀 Iniciando port-forward..."
echo "   Presiona Ctrl+C para detener"
echo ""

kubectl port-forward -n argocd svc/argocd-server 8080:443
