#!/usr/bin/bash
#Get the kubectl utility and move it to the users local bin/ directory
#get helm too ...
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
mkdir -p ~/bin/
chmod a+x kubectl
mv kubectl ~/bin/
kubectl version
echo "installing helm 3"
#helm 3.
wget https://get.helm.sh/helm-v3.0.0-rc.2-linux-amd64.tar.gz
tar xzf helm-v3.0.0-rc.2-linux-amd64.tar.gz
mv linux-amd64/helm ~/bin/
rm -f helm-v3.0.0-rc.2-linux-amd64.*
helm version
#bootstrap helm ...
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update
