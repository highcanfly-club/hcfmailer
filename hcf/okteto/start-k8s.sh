#!/bin/sh
SCRIPT_DIR=`dirname $0`
envsubst < $SCRIPT_DIR/k8s.yml | kubectl apply --kubeconfig $SCRIPT_DIR/okteto-kube.config -f -