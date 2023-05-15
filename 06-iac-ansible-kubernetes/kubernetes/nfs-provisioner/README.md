helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/


helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=192.168.7.149 \
    --set nfs.path=/data/nfsdata

helm install stable/nfs-client-provisioner --set nfs.server=192.168.7.149 --set nfs.path=/data/nfsdata