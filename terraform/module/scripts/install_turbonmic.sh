#!/bin/bash

#export NAMESPACE=turbonomic
#oc new-project ${NAMESPACE}
#oc project ${NAMESPACE}

echo
echo "Creating Turbonomic namespace ..."
kubectl apply -f -<<EOF
${NAMESPACE_FILE_CONTENT}
EOF
echo

echo "Creating Turbonomic Service Account ..."
kubectl apply -f -<<EOF
${SERVICE_ACCOUNT_FILE_CONTENT}
EOF
echo

echo "Creating Turbonomic Service Account Role Binding ..."
kubectl create -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/role.yaml -n "${NAMESPACE}"
echo

echo "Creating Turbonomic Service Account Role Binding ..."
kubectl apply -f -<<EOF
${ROLE_BINDING_FILE_CONTENT}
EOF
echo

echo "Installing Turbonomic Platform Operator"
kubectl apply -f -<<EOF
${OPERATOR_GROUP_FILE_CONTENT}
EOF
echo

echo "Creating Turbonomic Platform Subscription ..."
kubectl apply -f -<<EOF
${SUBSCRIPTION_FILE_CONTENT}
EOF
until oc get crd xls.charts.helm.k8s.io >> /dev/null 2>&1; do sleep 5; done
echo

echo "Creating Custom Resource Definition (xls.charts.helm.k8s.io) ..."
kubectl create -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/crds/charts_v1alpha1_xl_crd.yaml
echo

echo "Configuring the NGINX or the Ingress/Route ..."
kubectl apply -f -<<EOF
${NGINX_INGRESS_FILE_CONTENT}
EOF
echo

echo "Creating Turbonomic ConfigMap ..."
kubectl apply -f -<<EOF
${CONFIGMAP_FILE_CONTENT}
EOF
echo

echo "Deploying Turbonomic ..."
kubectl apply -f -<<EOF
${KUBETURBO_DEPLOY_FILE_CONTENT}
EOF
echo


echo "Creating Turbonomic Platform Deployment..."
kubectl create -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/operator.yaml -n turbonomic
echo

sleep 15
kubectl get pods -n "${NAMESPACE}"



#cat << EOF | oc -n ${NAMESPACE} apply -f -
#apiVersion: operators.coreos.com/v1
#kind: OperatorGroup
#metadata:
#  annotations:
#    olm.providedAPIs: Xl.v1.charts.helm.k8s.io
#  name: turbonomic-mkk5d
#  namespace: ${NAMESPACE}
#spec:
#  targetNamespaces:
#  - ${NAMESPACE}
#EOF

#
#cat << EOF | oc -n ${NAMESPACE} apply -f -
#apiVersion: operators.coreos.com/v1alpha1
#kind: Subscription
#metadata:
#  labels:
#    operators.coreos.com/t8c-certified.turbonomic: ""
#  name: t8c-certified
#  namespace: ${NAMESPACE}
#spec:
#  name: t8c-certified
#  source: certified-operators
#  sourceNamespace: openshift-marketplace
#EOF

#kubectl apply -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/crds/charts_v1alpha1_xl_cr.yaml -n ${NAMESPACE}