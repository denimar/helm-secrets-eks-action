#!/bin/sh

set -e

kubectlVersion="$1"
kubeConfigData="$2"
command="$3"

if [ "$kubectlVersion" = "latest" ]; then
  kubectlVersion=$(curl -Ls https://dl.k8s.io/release/stable.txt)
fi

echo "using kubectl@$kubectlVersion"

curl -sLO "https://dl.k8s.io/release/$kubectlVersion/bin/linux/amd64/kubectl" -o kubectl
chmod +x kubectl
mv kubectl /usr/local/bin

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$kubeConfigData" | base64 -d > /tmp/kubeConfigData
export KUBECONFIG=/tmp/kubeConfigData

sh -c "kubectl $command"
