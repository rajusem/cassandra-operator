#You can get token and url from ther openshift cluster. Login  into openshift cluster, click on your login name on top right corner, click on 'Copy Login Command'
export OC_TOKEN='<Token to login into Openshift Cluster>'
export OC_URI='<Openshift server url with port 6443 Ex: https://test.xyz.com:6443>'
#availaibity zone uses to deploy cassandra nodes into different zone
export AVALIBILITY_ZONE='<Openshift Node/Worker availaibity zone Ex: us-east-1>'
export NAMESPACE='<Namespace under which you want to deploy cassandra>'
export STORAGE_CLASS_NAME='<Storage class from where cassandra will get PV Ex: gp2/ocs-storagecluster-ceph-rbd>'
# No need to change CASSANDRA_SERVICE_ACCOUNT unless you are changing into CRD and other places
export CASSANDRA_SERVICE_ACCOUNT='cassandra-performance'