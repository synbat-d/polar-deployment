#!/bin/sh

echo "\n📦 Deploying applications...\n"

kubectl apply -k catalog-service/staging
kubectl apply -k order-service/staging
kubectl apply -k dispatcher-service/staging
kubectl apply -k edge-service/staging

echo "\n⛵ Done!\n"