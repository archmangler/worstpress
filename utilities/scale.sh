#!/usr/bin/bash
#wrapper script to simply scale the wordpress web
#application pod replica count 
#
#Usage: ./scale <replica count integer>

replicas=$1

echo "current ..."
kubectl get pods --namespace worstpress -l app=wordpress

echo "scaling to: $1"

kubectl scale --replicas $1 deployment/wordpress -n worstpress

echo "scaling ... hit ctrl-c when done ..."
watch kubectl get pods --namespace worstpress -l app=wordpress

