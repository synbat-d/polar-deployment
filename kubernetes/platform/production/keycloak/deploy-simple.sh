#!/bin/sh

set -euo pipefail

clientSecret=$(openssl rand -hex 10)

kubectl apply -f resources/namespace.yml
sed "s/polar-keycloak-secret/$clientSecret/" resources/keycloak-config.yml | kubectl apply -f -
kubectl apply -f resources/keycloak-deployment.yml

echo "Waiting for Keycloak..."
kubectl wait \
  --for=condition=ready pod \
  --selector=app=polar-keycloak \
  --timeout=600s \
  --namespace=keycloak-system

kubectl delete secret polar-keycloak-client-credentials --namespace=default || true
kubectl create secret generic polar-keycloak-client-credentials \
    --from-literal=spring.security.oauth2.client.registration.keycloak.client-secret="$clientSecret"

echo "Done! Admin: user / password"