here=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source helpers.sh

#Check for configuration file
if ! [ -f "${here}/env.sh" ]
then
    echo '`env.sh` configuration file is missing. You can create one from the template:'
    echo 'cp env-template.sh env.sh'
    echo
    echo 'Modify the `env.sh` configuration file as necessary. See README.md file for more information.'
    exit 1
fi

tool_is_installed oc

#Load configuration from env variables
source env.sh

is_set_or_fail OC_TOKEN "${OC_TOKEN}"
is_set_or_fail OC_URI "${OC_URI}"

openshift_login
sleep 5

oc_new_project ${NAMESPACE}
sleep 5

oc_adm_policy_add_scc_to_anyuid ${NAMESPACE} ${CASSANDRA_SERVICE_ACCOUNT}
sleep 5

cd ..
here=$( pwd )
# echo "${here}"

echo "Setting up CRD, Service Account, Pod Security policy etc"
oc_apply "${here}/crds.yaml"
sleep 10
oc_apply "${here}/bundle.yaml"
sleep 10

echo "Creating Cassandra pods"
cd ../examples
here=$( pwd )

# echo "${here}"
oc_apply "${here}/example-openshift-datacenter.yaml"

x=15
pod_created=false
while [ $x -gt 0 ];
do
    # echo "inside while loop. x: ${x}, pod_created : ${pod_created}"
    pod_count="$(oc get pods | grep 'cassandra-test*' | grep 'Running' | wc -l)"
    echo "No of pod created : ${pod_count}"

    if [ $pod_count == 3 ] ; then
        pod_created=true
        break
    else
        echo "Still waiting for all cassandra pod to come up in running state"
    fi

    x=$(( $x - 1 ))
    sleep 30
done

if [ $pod_created == true ] ; then
    echo "cassandra deployed successfully"
else
    echo "Either facing some issue or its taking more time to install. You can check log manually on openshift."
fi