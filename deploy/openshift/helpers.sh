
function tool_is_installed() {
# Check if given command is available on this machine
    local cmd=$1

    if ! [ -x "$(command -v $cmd)" ]; then
        echo "Error: ${cmd} command is not available. Please install it. See README.md file for more information." >&2
        exit 1
    fi
}

function openshift_login() {
    oc login --token="${OC_TOKEN}" --server="${OC_URI}" 
}

function oc_apply() {
    # echo -e "\\n Applying template - $1 \\n"
    # echo -e "\\n oc apply  -f "$1"\\n"

    oc apply -f "$1"
}

function oc_process_apply() {
    # echo -e "\\n Processing template - $1 \\n"
    # echo -e "\\n oc process -f "$1" | oc apply -f -\\n"

    oc process -f "$1" | oc apply -f -
}


function is_set_or_fail() {
    local name=$1
    local value=$2

    if [ $value == "" ] || [ "${value}" == "not-set" ]; then
        echo "You have to set $name" >&2
        exit 1
    fi
}


function oc_new_project() {
    local name=$1

    query=`oc projects | grep "$name" | wc -l | xargs`
    # echo "${query}"
    query_output="${query}"

    if [ $query_output -eq 0 ]; then
        echo "Creating Project $name"
        # echo -e "\\n Creating new project - ${name} \\n"
        oc new-project "$name"
    else
        echo "Project already exist"
        oc project "$name"
    fi
}


function oc_adm_policy_add_scc_to_anyuid() {
    # echo -e "\\n oc adm policy add-scc-to-user anyuid system:serviceaccount:$1:$2 \\n"
    oc adm policy add-scc-to-user anyuid system:serviceaccount:$1:default
    oc adm policy add-scc-to-user anyuid system:serviceaccount:$1:$2
}