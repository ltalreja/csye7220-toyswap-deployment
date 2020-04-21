#!/usr/bin/env bash

# Terraform
printf -- '\033[32m *** Terraform Setup  *** \033[0m\n';
printf -- '\033[33m *** Intializing Terraform *** \033[0m\n';
terraform init &&
printf -- '\033[33m *** Planning Terraform *** \033[0m\n';
terraform plan &&
printf -- '\033[33m *** Applying Terraform*** \033[0m\n';
terraform apply --auto-approve &&

# Kubectl Setup
printf -- '\033[32m *** Kubectl Setup  *** \033[0m\n';
printf -- '\033[33m *** Saving toyswap config map in local *** \033[0m\n';
terraform output config_map_aws_auth > toyswap_config_map_aws_auth.yaml &&
printf -- '\033[33m *** Appending kubeconfig to local *** \033[0m\n';
terraform output kubeconfig > ~/.kube/config &&
printf -- '\033[33m *** Applying toyswap configmap *** \033[0m\n';
kubectl apply -f toyswap_config_map_aws_auth.yaml &&

# Apply Backend Deployments
printf -- '\033[32m *** Backend Deployments  *** \033[0m\n';
printf -- '\033[33m *** Backend Deployment-1: toyswap-register *** \033[0m\n';
kubectl apply -f ./deployments/deployment-toyswap-register.yaml &&
printf -- '\033[33m ***  Backend Deployment-2: toyswap-exchange *** \033[0m\n';
kubectl apply -f ./deployments/deployment-toyswap-exchange.yaml &&

# Apply Backend Services
printf -- '\033[32m *** Backend Services  *** \033[0m\n';
printf -- '\033[33m *** Backend Service-1: toyswap-register *** \033[0m\n';
kubectl apply -f ./services/service-toyswap-register.yaml &&
printf -- '\033[33m *** Backend Service-2: toyswap-exchange *** \033[0m\n';
kubectl apply -f ./services/service-toyswap-exchange.yaml &&

# Get External-IPs
printf -- '\033[32m *** Get SVCs URLS  *** \033[0m\n';
printf -- '\033[33m *** Loading . . . *** \033[0m\n';
sleep 15 &&
printf -- '\033[33m *** Get SVC Backend Service-1 *** \033[0m\n';
kubectl get svc toyswap-register &&
printf -- '\033[33m *** Get SVC Backend Service-2 *** \033[0m\n';
kubectl get svc toyswap-exchange &&

# Helm - Ingress Controller Setup
printf -- '\033[32m *** Helm - Ingress Controller Setup  *** \033[0m\n';
printf -- '\033[33m *** Intializing Helm *** \033[0m\n';
helm init &&
printf -- '\033[33m *** Creating tiller service account *** \033[0m\n';
kubectl create serviceaccount --namespace kube-system tiller &&
printf -- '\033[33m *** Creating Cluster Rolebinding for tiller *** \033[0m\n';
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller &&
printf -- '\033[33m *** Deploying tiller *** \033[0m\n';
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}' &&
printf -- '\033[33m *** Initializing service account for tiller *** \033[0m\n';
helm init --service-account tiller --upgrade &&
sleep 30 &&
printf -- '\033[33m *** Retrieving deployments *** \033[0m\n';
kubectl get deployments -n kube-system &&
printf -- '\033[33m *** Installing Nginx ingress controller *** \033[0m\n';
sleep 25 &&
helm install --name nginx-ingress stable/nginx-ingress --set rbac.create=true &&
printf -- '\033[33m *** Nginx ingress controller service created *** \033[0m\n';
sleep 20 &&
kubectl get service nginx-ingress-controller &&
printf -- '\033[33m *** Deploying ingress service resource to the controller to map backend services *** \033[0m\n';
kubectl apply -f toyswap-ingress.yaml &&
printf -- '\033[33m *** Ingress resoource created *** \033[0m\n';
kubectl get ingress toyswap-ingress &&
printf -- '\033[33m *** Retrieving all services *** \033[0m\n';
kubectl get svc &&
sleep 2 &&

# Apply Frontend Deployments
printf -- '\033[32m *** Frontend Deployments  *** \033[0m\n';
printf -- '\033[33m *** Deploying Frontend *** \033[0m\n';
kubectl apply -f ./deployments/deployment-toyswap-frontend.yaml &&
printf -- '\033[33m *** Loading . . . *** \033[0m\n';
sleep 15 &&
kubectl get deployment toyswap-frontend &&

# Apply Frontend Services
printf -- '\033[32m *** Frontend Services  *** \033[0m\n';
printf -- '\033[33m *** Deploying Frontend Services *** \033[0m\n';
kubectl apply -f ./services/service-toyswap-frontend.yaml &&

# Get External-IPs
printf -- '\033[32m *** Get Frontend SVCs URLS  *** \033[0m\n';
printf -- '\033[33m *** Loading . . . *** \033[0m\n';
sleep 15 &&
kubectl get svc toyswap-frontend &&

# Prometheus Dashboard Setup
printf -- '\033[32m *** Prometheus Dashboard Setup  *** \033[0m\n';
printf -- '\033[33m *** Create Namespace Monitoring *** \033[0m\n';
kubectl create namespace monitoring &&
printf -- '\033[33m *** Creating clusterRole *** \033[0m\n';
kubectl create -f ./deployments/monitoring/clusterRole.yaml &&
printf -- '\033[33m *** Creating configMap  *** \033[0m\n';
kubectl create -f ./deployments/monitoring/config-map.yaml &&
printf -- '\033[33m *** Deploying prometheus *** \033[0m\n';
kubectl create -f ./deployments/monitoring/prometheus-deployment.yaml &&
printf -- '\033[33m *** Retrieving deployments in monitoring namespace *** \033[0m\n';
kubectl get deployments --namespace=monitoring &&
printf -- '\033[33m *** Deploying prometheus service *** \033[0m\n';
kubectl create -f ./deployments/monitoring/prometheus-service.yaml --namespace=monitoring &&
printf -- '\033[33m *** Retrieving service in monitoring namespace  *** \033[0m\n';
sleep 20 &&
kubectl get svc --namespace=monitoring &&

# Grafana Dashboard Setup 
printf -- '\033[32m *** Grafana Dashboard Setup  *** \033[0m\n';
printf -- '\033[33m *** Creating config for grafana *** \033[0m\n';
kubectl create -f ./deployments/monitoring/grafana-datasource-config.yaml &&
printf -- '\033[33m *** Deploying grafana *** \033[0m\n';
kubectl create -f ./deployments/monitoring/grafana-datasource-deploy.yaml &&
printf -- '\033[33m *** Deploying grafana service *** \033[0m\n';
kubectl create -f ./deployments/monitoring/grafana-datasource-service.yaml &&
printf -- '\033[33m *** Retrieving service in monitoring namespace *** \033[0m\n';
sleep 20 &&
kubectl get svc --namespace=monitoring &&

printf -- '\033[33m *** Update Route53 *** \033[0m\n';
kubectl get ingress toyswap-ingress &&
printf -- '\033[33m *** Access Frontend *** \033[0m\n';
kubectl get svc toyswap-frontend

printf -- '\033[32m *** Completed *** \033[0m\n';