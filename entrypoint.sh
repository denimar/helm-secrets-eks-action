#!/bin/sh

set -e

kubectlVersion="$1"
helmVersion="$2"
helmSecretsVersion="$3"
kubeConfigData="$4"
command="$5"

if [ "$kubectlVersion" = "latest" ]; then
  kubectlVersion=$(curl -Ls https://dl.k8s.io/release/stable.txt)
fi

echo "using kubectl@$kubectlVersion"
echo "using helm@$helmVersion"
echo "using helm-secrets@$helmSecretsVersion"

curl -sLO "https://dl.k8s.io/release/$kubectlVersion/bin/linux/amd64/kubectl" -o kubectl
chmod +x kubectl
mv kubectl /usr/local/bin

# Installing helm secrets
helm plugin install "https://github.com/jkroepke/helm-secrets" --version v3.8.3

# Installing sops
go get -u go.mozilla.org/sops/v3/cmd/sops
cd $GOPATH/src/go.mozilla.org/sops/
git checkout develop
make install

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$kubeConfigData" | base64 -d > /tmp/kubeConfigData
export KUBECONFIG=/tmp/kubeConfigData

echo "*************************************"
sh -c "$command"
echo "*************************************"
