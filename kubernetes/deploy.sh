#!/usr/bin/env bash
set -eo pipefail

if [[ -r environment.sh ]]; then
  source environment.sh
fi

########################################################################################################################
#                                       cert-manager                                                                   #
########################################################################################################################
kustomize build --enable-alpha-plugins "cert-manager" | kubectl apply -f -

kubectl wait --namespace cert-manager \
  --for=condition=ready pod \
  --selector=app=cert-manager \
  --timeout=90s

########################################################################################################################
#                                       istio                                                                          #
########################################################################################################################
kustomize build --enable-alpha-plugins "istio" | kubectl apply -f -

kubectl wait --namespace istio-system \
  --for=condition=ready pod \
  --selector=app=istio-ingressgateway \
  --timeout=90s

kubectl wait --namespace istio-system \
  --for=condition=ready pod \
  --selector=app=istiod \
  --timeout=90s

########################################################################################################################
#                                       oauth2-proxy                                                                   #
########################################################################################################################
kustomize build --enable-alpha-plugins "oauth2-proxy" | kubectl apply -f -

kubectl wait --namespace oauth2-proxy \
  --for=condition=ready pod \
  --selector=app=oauth2-proxy \
  --timeout=90s

########################################################################################################################
#                                       springboot-petclinic                                                           #
########################################################################################################################
kustomize build --enable-alpha-plugins "springboot-petclinic-v1" | kubectl apply -f -

kubectl wait --namespace springboot-petclinic \
  --for=condition=ready pod \
  --selector=app=springboot-petclinic-v1 \
  --timeout=90s