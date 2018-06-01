#!/usr/bin/env bash

set -e

export PROJECT=techperk-201607
export NAME=thx_app_prod
export TAG=$1
export IMAGE="asia.gcr.io/$PROJECT/$NAME:$TAG"

echo "deploying $IMAGE"

kubectl delete job deploy-tasks 2&> /dev/null || true

cat kube/deploy-tasks-job.yml.tmpl | envsubst | kubectl create -f -

while [ true ]; do
  phase=`kubectl get pods -a --selector="name=deploy-tasks" -o 'jsonpath={.items[0].status.phase}' || 'false'`
if [[ "$phase" != 'Pending' ]]; then
    break
  fi
done

echo '=============== deploy_tasks output'
kubectl attach $(kubectl get pods -a --selector="name=deploy-tasks" -o 'jsonpath={.items[0].metadata.name}')
echo '==============='

while [ true ]; do
  succeeded=`kubectl get jobs deploy-tasks -o 'jsonpath={.status.succeeded}'`
  failed=`kubectl get jobs deploy-tasks -o 'jsonpath={.status.failed}'`
if [[ "$succeeded" == "1" ]]; then
    break
  elif [[ "$failed" -gt "0" ]]; then
    kubectl describe job deploy-tasks
    kubectl delete job deploy-tasks
    echo '!!! Deploy canceled. deploy-tasks failed.'
    exit 1
  fi
done

kubectl set image deployments/web "web=$IMAGE"
kubectl describe deployment web
kubectl delete job deploy-tasks || true
kubectl rollout status deployment/web