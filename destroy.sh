#!/usr/bin/env bash
printf -- '\033[33m *** Deleting toyswap_configmap *** \033[0m\n';
rm toyswap_config_map_aws_auth.yaml &&

printf -- '\033[33m *** Deleting Kubernetes Resources *** \033[0m\n';
kubectl delete all --all --all-namespaces &&
kubectl delete serviceaccounts nginx-ingress &&
kubectl delete serviceaccounts nginx-ingress-backend &&
kubectl delete  serviceaccounts tiller --namespace kube-system &&
kubectl delete clusterrolebinding tiller-cluster-rule &&

printf -- '\033[33m *** Destroying Terraform Resources *** \033[0m\n';
terraform destroy --auto-approve &&

printf -- '\033[33m *** Deleting terraform folder from local *** \033[0m\n';
rm -r ./.terraform &&

printf -- '\033[33m *** Deleting terraform state from local *** \033[0m\n';
rm terraform.tfstate