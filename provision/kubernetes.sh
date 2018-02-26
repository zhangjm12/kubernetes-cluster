#!/bin/bash
export PS4='+[${LINENO}:${FUNCNAME[0]}:$(basename "${BASH_SOURCE[0]}")] '
LOCATION_PATH="$( cd $(dirname ${BASH_SOURCE[0]}); pwd )"

# if ${SHELLOPTS} include "xtrace"
[[ "${SHELLOPTS}" =~ "xtrace" ]] && setx="-x" || setx="+x"
unsetx="+x"
# uncomment the next line to print all commands as they are executed.
#setx="-x"; unsetx="${setx}"

KUBERNETES_VERSION="v1.9.2"

# c45cf9e9d27b9d1bfc6d26f86856271fec6f8e7007f014597d27668f72f8c349
[[ -f /vagrant/kubernetes-client-linux-amd64.tar.gz ]] || \
  curl -sSL -o /vagrant/kubernetes-client-linux-amd64.tar.gz \
  https://dl.k8s.io/${KUBERNETES_VERSION}/kubernetes-client-linux-amd64.tar.gz
tar -zxf /vagrant/kubernetes-client-linux-amd64.tar.gz -C /vagrant

cp /vagrant/kubernetes/client/bin/kubectl /usr/bin/


# 2218fe0b939273b57ce00c7d5f3f7d2c34ebde5ae500ba2646eea6ba26c7c63d
[[ -f /vagrant/kubernetes-server-linux-amd64.tar.gz ]] || \
  curl -sSL -o /vagrant/kubernetes-server-linux-amd64.tar.gz \
  https://dl.k8s.io/${KUBERNETES_VERSION}/kubernetes-server-linux-amd64.tar.gz
tar -zxf /vagrant/kubernetes-server-linux-amd64.tar.gz -C /vagrant

cp /vagrant/kubernetes/server/bin/{kube-apiserver,kube-controller-manager,kube-scheduler,kube-proxy,kubelet} /usr/bin
mkdir -p /etc/kubernetes
cp ${LOCATION_PATH}/etc/kubernetes/{config,apiserver,controller-manager,scheduler,proxy,kubelet} /etc/kubernetes
mkdir -p /var/lib/kubelet
cp ${LOCATION_PATH}/var/lib/kubelet/kubeconfig /var/lib/kubelet
cp ${LOCATION_PATH}/usr/lib/systemd/system/{kube-apiserver.service,kube-controller-manager.service,kube-scheduler.service,kube-proxy.service,kubelet.service} \
  /usr/lib/systemd/system/

systemctl daemon-reload
systemctl enable kube-apiserver kube-controller-manager kube-scheduler kube-proxy kubelet
