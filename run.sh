#!/bin/bash
cd terragrunt/bilenkis-staging/eu01/staging/kutt
terragrunt apply
cd -
aws --profile bilenkis-staging eks update-kubeconfig --name infra01 --alias company
# Update DB password in kubernetes/chart-values/kutt/staging/secrets.yaml
helmfile -f kubernetes/helmfiles/kutt/helmfile.yaml sync
# Beer!!! 🍺🍺🍺
