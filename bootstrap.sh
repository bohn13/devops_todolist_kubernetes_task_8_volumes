#!/bin/bash
kubectl apply -f .infrastructure/namespace.yml

sleep 2

kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/confgiMap.yml

sleep 2

kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml

sleep 2

kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/clusterIp.yml

sleep 2

kubectl apply -f .infrastructure/deployment.yml

sleep 2

kubectl apply -f .infrastructure/hpa.yml

sleep 2

echo "Deployment finished! Checking status..."
kubectl get all -n todoapp