#!/bin/bash

kubectl delete -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/crds/charts_v1alpha1_xl_cr.yaml -n "${NAMESPACE}"

#export NS=turbonomic
# Remove the turbonomic operator subscription
echo "Remove the operator by running with OLM ..."
oc delete Subscription t8c-certified -n "${NAMESPACE}"
oc delete ClusterServiceVersion t8c-operator.v42.4.0 -n "${NAMESPACE}"
oc delete ns "${NAMESPACE}"


echo "remove the operator by running without OLM ..."
kubectl delete -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/operator.yaml -n "${NAMESPACE}"
kubectl delete -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/role_binding.yaml -n "${NAMESPACE}"
kubectl delete -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/role.yaml -n "${NAMESPACE}"
kubectl delete -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/service_account.yaml -n "${NAMESPACE}"
kubectl delete -f https://raw.githubusercontent.com/turbonomic/t8c-install/master/operator/deploy/crds/charts_v1alpha1_xl_crd.yaml
kubectl delete ns "${NAMESPACE}"