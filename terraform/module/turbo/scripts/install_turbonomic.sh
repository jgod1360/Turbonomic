#!/bin/bash

###############################################################################
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2021. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
###############################################################################

echo
echo "Creating Turbonomic namespace ..."
kubectl create -f -<<EOF
${NAMESPACE_FILE_CONTENT}
EOF
echo

echo "Creating Turbonomic Service Account ..."
kubectl create -f -<<EOF
${SERVICE_ACCOUNT_FILE_CONTENT}
EOF
echo

echo "Creating Turbonomic Service Account Role Binding ..."
kubectl create -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/role.yaml -n "${TURBO_PROJECT}"
echo

echo "Creating Turbonomic Service Account Role Binding ..."
kubectl create -f -<<EOF
${ROLE_BINDING_FILE_CONTENT}
EOF
echo

echo "Installing Turbonomic Platform Operator"
kubectl create -f -<<EOF
${OPERATOR_GROUP_FILE_CONTENT}
EOF
echo

echo "Creating Turbonomic Platform Subscription ..."
kubectl create -f -<<EOF
${SUBSCRIPTION_FILE_CONTENT}
EOF
until oc get crd xls.charts.helm.k8s.io >> /dev/null 2>&1; do sleep 5; done
echo

echo "Creating Custom Resource Definition (xls.charts.helm.k8s.io) ..."
kubectl create -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/crds/charts_v1alpha1_xl_crd.yaml
echo

echo "Configuring the NGINX or the Ingress/Route ..."
kubectl create -f -<<EOF
${NGINX_INGRESS_FILE_CONTENT}
EOF
echo

echo "Creating Turbonomic ConfigMap ..."
kubectl create -f -<<EOF
${CONFIGMAP_FILE_CONTENT}
EOF
echo

echo "Deploying Turbonomic ..."
kubectl create -f -<<EOF
${KUBETURBO_DEPLOY_FILE_CONTENT}
EOF
echo


echo "Creating Turbonomic Platform Deployment..."
kubectl create -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/operator.yaml -n "${TURBO_PROJECT}"
echo

sleep 15
kubectl get pods -n "${TURBO_PROJECT}"
