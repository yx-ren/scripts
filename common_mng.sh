#!/bin/bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

#### support environment variables
## MYC_GRACE_SHUTDOWN: 1 means call shutdown API, otherwise kill -9 pid, default is 0
typeset g_urlbase="http://localhost:9088"
typeset g_rest_ver="v1"
typeset g_api_init="init"
typeset g_api_close="close"
typeset g_api_shutdown="shutdown"
typeset g_api_status="status"
typeset g_api_statedb_open="statedb/open"
typeset g_api_statedb_close="statedb/close"
typeset g_api_statedb_get="statedb/get"
typeset g_api_statedb_update="statedb/update"
typeset g_api_statedb_write="statedb/write"
typeset g_api_statedb_makesnapshot="statedb/makesnapshot"
typeset g_api_statedb_deleteundolog="statedb/deleteundolog"
typeset g_api_statedb_prune="statedb/prune"
typeset g_api_statedb_switch_merkle_type="statedb/switchmerkletype"
typeset g_api_statedb_getstateroot="statedb/getstateroot"
typeset g_api_statedb_putaddresscontent="statedb/putaddresscontent"
typeset g_api_statedb_getaddresscontent="statedb/getaddresscontent"
typeset g_api_statedb_fetchaddresscontent="statedb/fetchaddresscontent"
typeset g_api_statedb_syncaddresscontent="statedb/syncaddresscontent"
typeset g_api_statedb_updatetwolayer="statedb/updatetwolayer"
typeset g_api_statedb_isopen="statedb/isopenstate"
typeset g_api_statedb_enableautoprune="statedb/enableautoprune"
typeset g_api_statedb_setautoprunereservedwindow="statedb/setautoprunereservedwindow"
typeset g_api_statedb_getpruneinfo="statedb/getpruneinfo"
typeset g_api_make_mem_snapshot="statedb/makememsnapshot"
typeset g_api_destroy_mem_snapshot="statedb/destroymemsnapshot"
typeset g_api_query_mem_snapshot_info="statedb/querymemsnapshotinfo"
typeset g_api_fast_fetch_packet="statedb/fastfetchpacket"
typeset g_api_fast_sync_packet="statedb/fastsyncpacket"
typeset g_api_flush_fast_sync="statedb/flushfastsync"
typeset g_api_kvdb_open="kvdb/open"
typeset g_api_statedb_enableautoprune="statedb/enableautoprune"
typeset g_api_statedb_setautoprunereservedwindow="statedb/setautoprunereservedwindow"
typeset g_api_statedb_getpruneinfo="statedb/getpruneinfo"
typeset g_api_kvdb_close="kvdb/close"
typeset g_api_kvdb_get="kvdb/get"
typeset g_api_kvdb_range_get="kvdb/rangeget"
typeset g_api_kvdb_set="kvdb/set"
typeset g_api_kvdb_del="kvdb/delete"
typeset g_api_kvdb_range_del="kvdb/rangedelete"
typeset g_api_kvdb_isopen="kvdb/isopenKVDB"
typeset g_api_kvdb_makesnapshot="kvdb/makesnapshot"
typeset g_api_meta_init="meta/init"
typeset g_api_meta_uninit="meta/uninit"
typeset g_api_meta_get="meta/get"
typeset g_api_meta_set="meta/set"
typeset g_api_meta_del="meta/delete"
typeset g_conf_file="/mnt/zhaoyong.zzy/mychain/dev/aldaba/src/programs/storage/svc.conf"

typeset g_api_statedb_writeblock="benchmark/createblock"
typeset g_api_statedb_genblock="benchmark/genblock"
typeset g_api_statedb_readblock="benchmark/getblock"
typeset g_api_benchmarkstatedb_open="benchmark/openstate"
typeset g_api_benchmarkstatedb_stop="benchmark/stop"

typeset g_st_running="RUNNING"
typeset g_st_stopping="STOPPING"
typeset g_st_shutdown="shutdown"
typeset g_st_error="error"
typeset g_st_unknown="unknown"

typeset g_storage_block_db_id=1
typeset g_storage_extra_db_id=2
typeset g_storage_related_db_id=3
typeset g_storage_addressable_db_id=4
typeset g_storage_state_db_id=5
typeset g_domain_id="member_default"

alias GET_NODE_INFO='
    get_node_attr ${g_testdm} ${id} "ip" IP;               BCS_CHK_RC0 "error: cannot get ip for ${id}"
    get_node_attr ${g_testdm} ${id} "user" RUSER;          BCS_CHK_RC0 "error: cannot get ruser for ${id}"
    get_node_attr ${g_testdm} ${id} "deploydir" RDIR;      BCS_CHK_RC0 "error: cannot get rdir for ${id}"
    get_node_attr ${g_testdm} ${id} "myid" MYID;           BCS_CHK_RC0 "error: cannot get myid for ${id}"
    #get_node_attr ${g_testdm} ${id} "port" PORT;           BCS_CHK_RC0 "error: cannot get port for ${id}"
    get_node_attr ${g_testdm} ${id} "rest_port" REST_PORT; BCS_CHK_RC0 "error: cannot get rest_port for ${id}"
    #get_node_attr ${g_testdm} ${id} "msu" MSU;             BCS_CHK_RC0 "error: cannot get msu for ${id}"
    g_urlbase="http://${IP}:${REST_PORT}"
    ## avoid too many tmp files
    #eval [[ -z "\${gac_tmpfile_${BASHPID}}" ]] && my_gen_temp gac_tmpfile_${BASHPID} ${FUNCNAME[0]}.${BASHPID}.${id}
    eval [[ -z "\${gac_tmpfile_${BASHPID}:-}" ]] && my_gen_temp gac_tmpfile_${BASHPID} ${BASHPID}.${id}
    eval tmpfile=\${gac_tmpfile_${BASHPID}}
'
###################################
function do_rest {
    BCS_FUNCTION_BEGIN
    typeset api=${1:-}
    typeset data="${2:-}"
    typeset outf="${3:-}"
    #72 hours is too long, use 20 mintues
    #typeset CURLOPT=" --max-time $((60*60*24*3)) --connect-timeout 5"
    typeset CURLOPT=" --max-time $((60*30)) --connect-timeout 5"
    /bin/rm -f ${outf}
    if [[ ! -f ${data} ]]; then
    eval echo "data is not true"
    CMD=$(cat - <<\EOF
curl -sX POST ${CURLOPT} "http://${g_urlbase#http://}/${g_rest_ver}/${api}" -H "accept: application/json" -H "Content-Type: application/json" -d ''"${data}"'' -o ${outf}
EOF
)
    else
    eval echo "data is true"
    CMD=$(cat - <<\EOF
curl -sX POST ${CURLOPT} "http://${g_urlbase#http://}/${g_rest_ver}/${api}" -H "accept: application/json" -H "Content-Type: application/json" -d ''"@${data}"'' -o ${outf}
EOF
)
    fi
    eval echo "do CMD=${CMD}"
    eval ${CMD}
    ret=$?
    eval echo "CMD do end ret=${ret}, cmd=${CMD}"
    if [[ ${ret} -ne 0 ]]; then
        #MSG "$CMD"
        CMD=${CMD//\"/\\\"}
        CMD=${CMD//\'/\\\'}
        LOG "command execution failed(${ret}): $(eval echo "${CMD}")"
        LOGJSON ${outf} "rest output"
        return ${ret}
    fi
    #cat ${outf}
    [[ -f ${outf} ]]
    BCS_CHK_RC0 "no json file is generated by curl command"
    typeset code=$(cat ${outf} | jq '.statusCode')
    if [[ "$code" != "200" ]]; then
      typeset log=$(cat ${outf})
      LOG "cmd end but status code not find ${log}"
        LOGJSON ${outf} "rest output"
    fi
    return 0
}

function get_node_attr_etcd {
    BCS_FUNCTION_BEGIN
    typeset verbose0=
    [[ ${SHELLOPTS} =~ verbose ]] && verbose0=1 || verbose0=0
    set +vx
    typeset env=${1?"no env name"}
    typeset node=${2?"no env name"}
    typeset attrname=${3?"no attr name"}
    typeset vname=${4?"no var name"}
    typeset idx=0
    typeset value=$(cat ${g_file} | jq -r '.env.'"${env}"'.etcd.cluster['"${node}"'].'"${attrname}"'')
    DBG "${vname}=${value}"
    eval ${vname}=${value}
    [[ "${value}" == "null" ]] && ret=1
    [[ "${verbose0}" -eq 1 ]] && set -vx
    return ${ret}
}
function exec_code_block_etcd {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))

    local iplist="${1:-}"
    local id
    my_gen_temp tmp_code_block
    typeset count=$(cat ${g_file} | jq '.env.'"${g_env}"'.etcd.cluster | length')
    DBG "count=${count}"
    [[ -z "${iplist}" ]] && iplist=$(seq 0 $((count-1)))
    if [[ "z${iplist}" == "ztrue" ]]; then
        iplist=$(seq 0 $((count-1)))
    fi
    cat - > ${tmp_code_block}
    #for((id=0; id<count; id++)) {
    for id in ${iplist}; do {
        DBG "id=$id"
        typeset MYID=${id}
        get_node_attr_etcd ${dm_name} ${id} "ip"        IP
        get_node_attr_etcd ${dm_name} ${id} "user"      RUSER
        get_node_attr_etcd ${dm_name} ${id} "port"      PORT
        get_node_attr_etcd ${dm_name} ${id} "peer_port" PEER_PORT
        get_node_attr_etcd ${dm_name} ${id} "deploydir" RDIR
        [[ ${SS_SILENT} -ne 1 ]] && MSG "####### $id $IP R${PEER_PORT} $PORT $RUSER $RDIR ########"
        DBG "CMD=$(cat ${tmp_code_block})"
        ### execute code block
        source ${tmp_code_block}
        [[ ${SS_SILENT} -ne 1 ]] && MSG "$?"
        ### execute code block
    }
    done
    rm -f ${tmp_code_block}
}
function exec_code_block {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))

    local iplist="${1:-}"
    local id
    my_gen_temp tmp_code_block
    [[ -z "${iplist}" ]] && get_node_list ${dm_name} iplist
    cat - > ${tmp_code_block}
    typeset idx=0
    for id in ${iplist[*]}; do
        DBG "id=$id"
        typeset ROLE="master"
        #get_node_ip   ${dm_name} ${id}             IP
        get_node_attr ${dm_name} ${id} "ip"        IP
        get_node_attr ${dm_name} ${id} "user"      RUSER
        get_node_attr ${dm_name} ${id} "myid"      MYID
        get_node_attr ${dm_name} ${id} "port"      PORT
        get_node_attr ${dm_name} ${id} "msu"       MSU
        get_node_attr ${dm_name} ${id} "deploydir" RDIR
        get_node_attr ${dm_name} ${id} "rest_port" REST_PORT
        get_domain_type ${dm_name}                 DM_TYPE
        [[ "${MYID}" != "0" ]] && ROLE="slave"

        [[ ${SS_SILENT} -ne 1 ]] && MSG "####### $id $IP R${REST_PORT} $PORT $RUSER $RDIR ########"
        DBG "CMD=$(cat ${tmp_code_block})"
        ### execute code block
        source ${tmp_code_block}
        [[ ${SS_SILENT} -ne 1 ]] && MSG "$?"
        ### execute code block
        ((idx++))
    #TODO: if use following line, the exported variable in the tmp_code_block can NOT be accessed in get_height function, need to investigate
    #done 2>&1 | grep -v profiling
    done
    #| grep -v pamir
    rm -f ${tmp_code_block}
}
function exec_code_block_async {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    typeset iplist="${1:-}"
    [[ -z "${iplist}" ]] && get_node_list ${dm_name} iplist
    LOG "iplist: ${iplist[*]}"
    my_gen_temp tmp_code_block_async
    cat - > ${tmp_code_block_async}
    typeset idx=0
    typeset ext=".${BASHPID}.init.ok"
    typeset pid=
    typeset pidlist=""
    typeset id=
    for id in ${iplist[*]}; do
    {
        DBG "id=$id"
        typeset st_file="${id}${ext}"; rm -f ${st_file} 2>/dev/null
        ROLE="master"
        #get_node_ip   ${dm_name} ${id}              IP
        get_node_attr ${dm_name} ${id} "ip"         IP
        get_node_attr ${dm_name} ${id} "user"       RUSER
        get_node_attr ${dm_name} ${id} "myid"       MYID
        get_node_attr ${dm_name} ${id} "port"       PORT
        get_node_attr ${dm_name} ${id} "msu"        MSU
        get_node_attr ${dm_name} ${id} "deploydir"  RDIR
        get_node_attr ${dm_name} ${id} "rest_port"  REST_PORT
        get_domain_type ${dm_name}                  DM_TYPE
        [[ "${MYID}" != "0" ]] && ROLE="slave"

        #echo "####### $id $IP $RUSER $RDIR ########"
        #MSG "####### $id $IP R${REST_PORT} $PORT $RUSER $RDIR ########"
        DBG "CMD=$(cat ${tmp_code_block_async})"
        ### execute code block
        source ${tmp_code_block_async}
        BCS_CHK_ACT_RC0 "exec_code_block_async failed for ${id} code=${tmp_code_block_async}
            &&& echo \"---code1 begin---\" &&
                cat ${tmp_code_block_async} &&
                echo \"---code1 end---\" &&
                [[ \"${MYDBG^^}\" != \"DEBUG\" ]] && rm -f ${tmp_code_block_async}
            ||| echo 1 > ${st_file}
            !!! LOG "async_done_$id""
        #MSG "$?"
        ### execute code block
        ((idx++))
    } &
    #} &> ${id}.${ext}.log &
    #echo $! >> pid.${ext}
    pid=$!
    pidlist="${pid} ${pidlist}"
    echo ${pid} >> ${PIDFILE}
    #TODO: if use following line, the exported variable in the tmp_code_block_async can NOT be accessed in get_height function, need to investigate
    #done 2>&1 | grep -v profiling
    #done 2>&1 | grep -v pamir
    done
    LOG "begin to wait ${pidlist}"
    wait ${pidlist}
    LOG "end wait ${pidlist}"
    rm -f ${tmp_code_block_async}
    ## need to remove these finished process from PIDFILE, otherwise ctrl-c may kill other new process which reuse the old pid
    for pid in ${pidlist}; do
        remove_line_from_file ${PIDFILE} ${pid}
    done
    typeset all_st_file=""
    for id in ${iplist[*]}; do
        typeset st_file="${id}${ext}"
        all_st_file="${all_st_file} ${st_file}"
    done
    for id in ${iplist[*]}; do
        typeset st_file="${id}${ext}"
        [[ -f ${st_file} ]]
        BCS_CHK_ACT_RC0 "${id} dosomething failed, file not found: ${st_file} &&& rm -f ${all_st_file}"
        #rm -f ${st_file}
    done
    rm -f ${all_st_file}
    LOG "exec_code_block_async run to end"
    return 0
}
function remove_line_from_file {
    BCS_FUNCTION_BEGIN
    typeset file=${1:-}
    typeset line=${2:-}
    BCS_RUN_AND_CHK "[[ -n \"${file}\" && -f \"${file}\" ]] @@@ file:${file} doesnot exit"
    DBG "remove line[${line}] from file ${file}"
    typeset tmpfile=${file}.tmp
    cat ${file}    | sed '/^'"${line}"'$/d' > ${tmpfile}
    BCS_RUN_AND_CHK "mv ${tmpfile} ${file} @@@ faile to run: mv ${tmpfile} ${file}"
}
function deploy_etcd {
    BCS_FUNCTION_BEGIN
    {
        etcd_kill_all $@
        sleep 1
        #cluster_check_status "${g_st_shutdown}"
    }
    #BCS_CHK_RC0 "faild to shutdown current cluster"
    #get_domain_type ${g_env} dm_type
    deploy_etcd_internal $@
}
function deploy_cluster {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    typeset gen_meta_only=0
    unset OPTIND
    while getopts e: ch; do
      case ${ch} in
        "e") dm_name=${OPTARG};;
      esac
    done
    shift $((OPTIND-1))
    if [[ ${gen_meta_only} -ne 1 ]]; then
        #cluster_uninit $@
        #cluster_shutdown $@
        node_kill_all $@
        sleep 1
        cluster_check_status "${g_st_shutdown}"
        BCS_CHK_RC0 "faild to shutdown current cluster"
    fi
    #get_domain_type ${g_env} dm_type
    deploy_svc $@
}
function deploy_test_cluster {
    BCS_FUNCTION_BEGIN
    {
        #cluster_uninit $@
        #cluster_shutdown $@
        node_kill_all -e ${g_testdm} $@
        sleep 1
        cluster_check_status -e ${g_testdm} "${g_st_shutdown}"
    }
    BCS_CHK_RC0 "faild to shutdown current cluster"
    #get_domain_type ${g_env} dm_type
    deploy_svc_test $@
}
function deploy_svc_test {
    BCS_FUNCTION_BEGIN
    typeset testdm=""
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") testdm=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    typeset bindir="$(cat ${g_file} | jq -cr '.bindir')"
    typeset exe=${bindir}/bin/chain_node
    typeset jsontool=${bindir}/bin/jsontool
    BCS_RUN_AND_CHK "[[ -s \"${exe}\" ]] @@@ ${exe} doesnot exit or its an empty file"
    BCS_RUN_AND_CHK "[[ -s \"${jsontool}\" ]] @@@ ${jsontool} doesnot exit or its an empty file"
    typeset public_net_mode=false
    if [[ "z$@" == "ztrue" ]]; then
        public_net_mode=true
    fi

    typeset etcd_enable=1
    typeset etcd_enable_flag=${MYC_ETCD_ENABLE_FLAG:-1}
    [[ ${etcd_enable_flag} == 2 ]] && etcd_enable=2
    LOG "etcd_enable=${etcd_enable}"

    typeset dm_type=
    get_domain_type ${g_testdm} dm_type
    [[ ${dm_type} == "mono" ]] && LOG "mono mode" && return 0
    [[ ${dm_type} == "chain_cluster" ]]
    BCS_CHK_RC0 "current cluster is not storage_cluster: dm_type=${dm_type}"

    typeset count=$(cat ${g_file} | jq '.env.'"${g_env}"'.nodes[].ip' | wc -l)
    LOG "count=${count} g_env=${g_env}"

    typeset node_id_list
    get_node_list ${g_env} node_id_list

    g_conf_file="${bindir}/conf/svc.conf"
    g_conf_work="${g_meta_file}"
    #g_conf_template="$WORKDIR/svc.conf.tmp"
    my_gen_temp g_conf_template svc.conf.tmp

    CMD="cp ${g_conf_file} ${g_conf_work}"
    LOG "${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    CMD="jq -n .storage={myid:1} > ${g_conf_template}"
    LOG "${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ### clean cluster
    LOG "clean cluster"
    cat ${g_conf_work} | jq '
    .config_service.chain_config.chain_default.cluster_node.nodes={}
    | .config_service.chain_config.chain_default.public_conf.statedb.cluster_node.nodes=[]
    ' | jq . > ${g_conf_work}.tmp
    BCS_CHK_RC0 "revise ${g_conf_work} failed"
    CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
    LOG "${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ### set cluster size
    LOG "set cluster size"
    # cat ${g_conf_work} | jq '
    # .storage_cluster.cluster_size='"${count}"'
    # ' | jq . > ${g_conf_work}.tmp
    # BCS_CHK_RC0 "revise ${g_conf_work} failed"
    # CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
    # LOG "${CMD}"
    # eval ${CMD}
    # BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ### set merkle tree type
    typeset merkle_type=${MYC_MERKLE_TREE_TYPE:-""}
    LOG "set merkle tree type: ${merkle_type}"
    if [[ -n "${merkle_type}" ]]; then
      cat ${g_conf_work} | jq '
      .config_service.chain_config.chain_default.public_conf.statedb.db_type="'"${merkle_type}"'"
      ' | jq . > ${g_conf_work}.tmp
      BCS_CHK_RC0 "revise ${g_conf_work} failed for merkle tree"
      CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
      eval ${CMD}
      BCS_CHK_RC0 "CMD execution failed: ${CMD}"
    else
      LOG "environment variable MYC_MERKLE_TREE_TYPE is not set, use the type in source conf"
    fi

    typeset enable_client_msu_db=${MYC_ENABLE_CLIENT_MSU:-1}
    LOG "set enable_client_msu_db: ${enable_client_msu_db}"
    cat ${g_conf_work} | jq '
      .config_service.chain_config.chain_default.feature_config.enable_client_msu_db='"${enable_client_msu_db}"'
      ' | jq . > ${g_conf_work}.tmp
      BCS_CHK_RC0 "revise ${g_conf_work} failed for enable_client_msu_db"
      CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
      eval ${CMD}
      BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    metric_json=$(cat ${g_conf_work} | jq -r '.config_service.chain_config.chain_default.metric.cetina')
    instance_name=$(cat ${g_conf_work} | jq -r '.config_service.chain_config.chain_default.metric.cetina.pamir_cetina_instance_name')

    ### add all node to cluster
    LOG "all all node to cluster configuration file: g_env=${g_env}"
    exec_code_block <<\EOF
        cat ${g_conf_work} | jq '
        .config_service.chain_config.chain_default.cluster_node.nodes."'"$MYID"'"={ "ip": "'"$IP"'", "port": '"$PORT"', "deploydir": "'"$RDIR"'" }
        | .config_service.chain_config.chain_default.public_conf.statedb.cluster_node.nodes+=[ { "node_id": "'"$MYID"'", "msu": "'"$MSU"'"  }]
        | .config_service.chain_config.chain_default.cluster_node.nodes."'"$MYID"'".metric.cetina='"${metric_json}"'
        ' | jq . > ${g_conf_work}.tmp
        BCS_CHK_RC0 "revise ${g_conf_work} failed"
        CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
        eval ${CMD}
        BCS_CHK_RC0 "CMD execution failed: ${CMD}"
EOF
    exec_code_block <<\EOF
        cat ${g_conf_work} | jq '
        .config_service.chain_config.chain_default.cluster_node.nodes."'"$MYID"'".metric.cetina.pamir_cetina_instance_name="'${g_env}_storage_${MYID}_${IP}'"
        ' | jq . > ${g_conf_work}.tmp
        BCS_CHK_RC0 "revise ${g_conf_work} failed"
        CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
        eval ${CMD}
        BCS_CHK_RC0 "CMD execution failed: ${CMD}"
EOF

    LOG "set statedb and kvdb path"
    exec_code_block ${node_id_list[0]} <<\EOF
        cat ${g_conf_work} | jq '
            .storage.myid='"\"${MYID}\""'
            | .config_service.chain_config.chain_default.public_conf.kvdb.cluster_node.nodes[0].node_id='"\"${MYID}\""'
            | if .config_service.chain_config.chain_default.kvdb.default == 'null' then
                .
              else
                .config_service.chain_config.chain_default.kvdb.default.cluster_node.nodes[0].node_id='"\"${MYID}\""'
              end
            | if .config_service.chain_config.chain_default.master_id == 'null' then
                .config_service.chain_config.chain_default.master_id='"\"${MYID}\""'
              else
                .
              end
            | if .config_service.chain_config.chain_default.kvdb.block_db != 'null' then
                .config_service.chain_config.chain_default.kvdb.block_db.cluster_node.nodes[0].node_id='"\"${MYID}\""'
              else
                .
              end
            ' | jq . > ${g_conf_work}.tmp

        BCS_CHK_RC0 "revise ${g_conf_work} failed"
        CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
        eval ${CMD}
        BCS_CHK_RC0 "CMD execution failed: ${CMD}"
EOF

#     LOG "set myid"
#     exec_code_block <<\EOF
#         cat ${g_conf_template} | jq '
#             .storage.myid='"${MYID}"'
#             ' | jq . > ${g_conf_template}.tmp
#         BCS_CHK_RC0 "revise ${g_conf_template} failed"
#         CMD="mv ${g_conf_template}.tmp ${g_conf_template}"
#         eval ${CMD}
#         BCS_CHK_RC0 "CMD execution failed: ${CMD}"
# EOF

    ## add etcd endpoints
    LOG "set etcd endpoints"
    cat ${g_conf_template} | jq '
        .storage.etcd.enable='"${etcd_enable}"' |
        .storage.etcd.local_port=25000 | 
        .storage.etcd.local_port_range=5000
        ' | jq . > ${g_conf_template}.tmp
    BCS_CHK_RC0 "revise ${g_conf_template} failed"
    CMD="mv ${g_conf_template}.tmp ${g_conf_template}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ## add etcd endpoints
    LOG "set meta data etcd endpoints"
    cat ${g_conf_work} | jq '
        .storage.etcd.enable='"${etcd_enable}"'
        | .storage.etcd.endpoints=[]
        ' | jq . > ${g_conf_work}.tmp
    BCS_CHK_RC0 "revise ${g_conf_work} failed"
    CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ## add etcd port range

    LOG "all all etcd node to cluster configuration file"
    exec_code_block_etcd <<\EOF
        etcd_ip=${IP}
        if [[ "z${public_net_mode}" == "ztrue" ]]; then
          etcd_ip="127.0.0.1"
        fi

        cat ${g_conf_template} | jq '
        .storage.etcd.endpoints+=[ "http://'"$etcd_ip"':'"$PORT"'" ]
        ' | jq . > ${g_conf_template}.tmp
        BCS_CHK_RC0 "revise ${g_conf_template} failed"
        CMD="mv ${g_conf_template}.tmp ${g_conf_template}"
        eval ${CMD}
        BCS_CHK_RC0 "CMD execution failed: ${CMD}"

        cat ${g_conf_work} | jq '
        .storage.etcd.endpoints+=[ "http://'"$etcd_ip"':'"$PORT"'" ]
        ' | jq . > ${g_conf_work}.tmp
        BCS_CHK_RC0 "revise ${g_conf_work} failed"
        CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
        eval ${CMD}
        BCS_CHK_RC0 "CMD execution failed: ${CMD}"
EOF
    ### send to all nodes and change conf accordingly
    LOG "send to all nodes and change conf accordingly"
    exec_code_block -e ${g_testdm} <<\EOF
    CMD="ssh ${RUSER}@$IP \"/bin/rm -rf ${RDIR}/*; mkdir -p ${RDIR}/conf\""
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    CMD="scp -r ${bindir}/bin ${RUSER}@$IP:${RDIR}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    CMD="scp ${g_conf_template} ${RUSER}@$IP:${RDIR}/conf/svc.conf.tmp"
    LOG "CMD=${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ssh ${RUSER}@$IP "cd ${RDIR}/;
        cat conf/svc.conf.tmp | jq '
            .storage.myid='\\\"${MYID}\\\"'
            ' > conf/svc.conf; rm -rf conf/svc.conf.tmp"
EOF

    /bin/rm -f "${g_conf_template}"
}
function set_etcd_conf_kv {
  ## set key-value in etcd conf file
  BCS_FUNCTION_BEGIN
  typeset f=${1:-}
  typeset k=${2:-}
  typeset v=${3:-}
  [[ -n "${f}" ]] && [[ -n "${k}" ]] && [[ -n "${v}" ]]
  BCS_CHK_ACT_RC0 "parameter error, must be non-empry: f=$f k=$k v=$v"
  sed -i 's#\( *\)'"${k}"':.*#\1'"${k}"': '"${v}"'#g' -i "${f}"
  BCS_CHK_ACT_RC0 "change configuration file error: f=$f k=$k v=$v"
}
function deploy_etcd_internal {
    export public_net_mode="$@"
    BCS_FUNCTION_BEGIN
    export num=${1:-}
    typeset bindir="$(cat ${g_file} | jq -cr '.bindir')"
    typeset exe=${bindir}/bin/etcd
    BCS_RUN_AND_CHK "[[ -s \"${exe}\" ]] @@@ ${exe} doesnot exit or its an empty file"
    typeset count=$(cat ${g_file} | jq '.env.'"${g_env}"'.etcd.cluster | length')
    DBG "count=${count}"
    [[ ${count} -ge 1 ]]
    BCS_CHK_ACT_RC0 "ETCD cluster setting is missing or incorrect ${g_env} &&& MSG 'deploy etcd cluster failed'"

# ./etcd --name infra0 --initial-advertise-peer-urls http://127.0.0.1:2380 \
#   --listen-peer-urls http://127.0.0.1:2380 \
#   --listen-client-urls http://127.0.0.1:2379 \
#   --advertise-client-urls http://127.0.0.1:2379 \
#   --initial-cluster-token etcd-cluster-1 \
#   --initial-cluster infra0=http://127.0.0.1:2380,infra1=http://127.0.0.1:2382,infra2=http://127.0.0.1:2384 \
#   --initial-cluster-state new
#
    ## create a tmp file to genrate etcd_start.sh
    my_gen_temp tmp_start_sh etcd_start.sh

    ## generate initial_cluster parameters: contain all IP
    typeset initial_cluster=
    for((i=0; i<count; i++)) {
      IP=$(cat ${g_file} | jq -rc '.env.'"${g_env}"'.etcd.cluster['"$i"'].ip')
      etcd_ip=${IP}
      if [[ "z${public_net_mode}" == "ztrue" ]]; then
        etcd_ip="127.0.0.1"
      fi
      PEER_PORT=$(cat ${g_file} | jq -rc '.env.'"${g_env}"'.etcd.cluster['"$i"'].peer_port')
      initial_cluster="${initial_cluster},etcd${i}=http://${etcd_ip}:${PEER_PORT}"
    }
    initial_cluster=${initial_cluster##,}

    ## etcd cluster token: make sure it's uniq to protect etcd node in multi cluster env
    typeset initial_cluster_token="etcd_token_${g_env}_$(date +'%Y%m%d_%H%M%S_%N')"
    g_conf_supervisor_watcher="${WORKDIR}/storageservice.ini.sample"


    ### send to all nodes and generate etcd_start.sh accordingly
    LOG "send to all nodes and change conf accordingly"
    exec_code_block_etcd <<\EOF
    CMD="ssh ${RUSER}@${IP} \"/bin/rm -rf ${RDIR}/data ${RDIR}/conf ${RDIR}/log; mkdir -p ${RDIR}/bin/ ${RDIR}/data/etcd/ ${RDIR}/conf ${RDIR}/log/ \""
    LOG "CMD=${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"
    if [[ ${g_support_supervisor} -eq 1 ]]; then
        my_gen_temp tmp_file_etcd
        program_uuid=${RDIR}/bin
        program_uuid=${program_uuid//'/'/'_'}
        program_command="${RDIR}/bin/etcd --config-file ${RDIR}/conf/etcd.conf"
        program_directory="${RDIR}/bin"
        ROLE_NAME="etcd_${IP}_${MYID}.ini"
        program_priority="15"

        cat ${g_conf_supervisor_watcher} > ${tmp_file_etcd}
        sed -i "s#PROGRAM_UUID#${program_uuid}#g;
                s#PROGRAM_COMMAND#${program_command}#g;
                s#PROGRAM_DIRECTORY#${program_directory}#g;
                s#ROLE_NAME#${ROLE_NAME}#g
                s#PROGRAM_PRIORITY#${program_priority}#g" ${tmp_file_etcd}
        mv ${tmp_file_etcd} ${ROLE_NAME}
        sync_file ${RUSER} ${IP} ${ROLE_NAME} /etc/supervisord.d/${ROLE_NAME}
        BCS_CHK_RC0 "sync_file ${ROLE_NAME} /etc/supervisord.d/${ROLE_NAME} failed"
    fi

    ## save etcd start command line to sh file
    CLIENT_URL=" http://${IP}:${PORT}"
    PEER_URL=" http://${IP}:${PEER_PORT}"
    if [[ "z${public_net_mode}" == "ztrue" ]]; then
        CLIENT_URL=" http://${etcd_ip}:${PORT}"
        PEER_URL=" http://${etcd_ip}:${PEER_PORT}"
    fi
  #   CMD="./etcd --name etcd${MYID} \
  # --enable-v2 \
  # --data-dir ${RDIR}/data/etcd \
  # --initial-advertise-peer-urls ${PEER_URL} \
  # --listen-peer-urls ${PEER_URL} \
  # --listen-client-urls ${CLIENT_URL} \
  # --advertise-client-urls ${CLIENT_URL} \
  # --initial-cluster-token ${initial_cluster_token} \
  # --initial-cluster ${initial_cluster} \
  # --config-file ../conf/etcd.conf \
  # --initial-cluster-state new & echo \$! > .etcd.pid "
    CMD="./etcd --config-file ../conf/etcd.conf & echo \$! > .etcd.pid "
    LOG "CMD=${CMD}"
    echo "$CMD" > ${tmp_start_sh}
    chmod +x ${tmp_start_sh}

    ## create a tmp file to genrate etcd_start.sh
    my_gen_temp tmp_etcd_conf etcd.conf
    typeset etcd_conf_template="${bindir}/conf/etcd.conf"
    CMD="cp ${etcd_conf_template} ${tmp_etcd_conf}"
    LOG "${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ## edit etcd conf file
    set_etcd_conf_kv ${tmp_etcd_conf} name                  "'etcd${MYID}'"
    set_etcd_conf_kv ${tmp_etcd_conf} enable-v2             "true"
    set_etcd_conf_kv ${tmp_etcd_conf} data-dir              "${RDIR}/data/etcd"
    set_etcd_conf_kv ${tmp_etcd_conf} listen-peer-urls      "${PEER_URL}"
    set_etcd_conf_kv ${tmp_etcd_conf} listen-client-urls    "${CLIENT_URL}"
    set_etcd_conf_kv ${tmp_etcd_conf} advertise-client-urls "${CLIENT_URL}"
    set_etcd_conf_kv ${tmp_etcd_conf} initial-cluster-token "${initial_cluster_token}"
    set_etcd_conf_kv ${tmp_etcd_conf} initial-cluster       "${initial_cluster}"
    set_etcd_conf_kv ${tmp_etcd_conf} initial-cluster-state "new"
    set_etcd_conf_kv ${tmp_etcd_conf} initial-advertise-peer-urls "${PEER_URL}"

    sync_file ${RUSER} ${IP} ${bindir}/bin/etcd ${RDIR}/bin/etcd
    BCS_CHK_RC0 "sync_file ${bindir}/bin/etcd ${RDIR}/bin/etcd failed"
    sync_file ${RUSER} ${IP} ${bindir}/bin/etcdctl ${RDIR}/bin/etcdctl
    BCS_CHK_RC0 "sync_file ${bindir}/bin/etcdctl ${RDIR}/bin/etcdctl failed"
    CMD="scp -r ${tmp_etcd_conf} ${RUSER}@${IP}:${RDIR}/conf/etcd.conf
        && scp -r ${tmp_start_sh} ${RUSER}@${IP}:${RDIR}/bin/etcd_start.sh"
    LOG "CMD=${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"
EOF
}
function deploy_svc {
    BCS_FUNCTION_BEGIN
    export num=${1:-}
    typeset bindir="$(cat ${g_file} | jq -cr '.bindir')"
    typeset exe=${bindir}/bin/storagesvc
    typeset node_exe=${bindir}/bin/chain_node
    typeset jsontool=${bindir}/bin/jsontool
    BCS_RUN_AND_CHK "[[ -s \"${exe}\" ]] @@@ ${exe} doesnot exit or its an empty file"
    #BCS_RUN_AND_CHK "[[ -f \"${jsontool}\" ]] @@@ ${jsontool} doesnot exit"
    typeset count=$(cat ${g_file} | jq '.env.'"${g_env}"'.nodes[].ip' | wc -l)

    typeset etcd_enable=1
    typeset dm_type=
    get_domain_type ${g_env} dm_type
    typeset etcd_enable_flag=${MYC_ETCD_ENABLE_FLAG:-1}
    [[ ${etcd_enable_flag} == 2 ]] && etcd_enable=2
    [[ ${dm_type} == "mono" ]] && etcd_enable=0
    typeset public_net_mode=false
    if [[ "z$@" == "ztrue" ]]; then
        public_net_mode=true
    fi

    LOG "etcd_enable=${etcd_enable}"

    DBG "count=${count}"
    g_conf_file="${bindir}/conf/svc.conf"
    g_conf_work="${g_meta_file}"
    LOG "g_conf_work=${g_conf_work}"
    #g_conf_template="$WORKDIR/svc.conf.tmp"
    my_gen_temp g_conf_template svc.conf.tmp


    g_conf_supervisor="${WORKDIR}/supervisord.conf.sample"
    # min. avail startup file descriptors
    g_supervisor_nr_open=65536

    g_conf_supervisor_watcher="${WORKDIR}/storageservice.ini.sample"

    typeset node_id_list
    get_node_list ${g_env} node_id_list

    CMD="cp ${g_conf_file} ${g_conf_work}"
    LOG "${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    CMD="jq -n .storage={myid:1} > ${g_conf_template}"
    LOG "${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ### clean cluster
    LOG "clean cluster"
    cat ${g_conf_work} | jq '
    .config_service.chain_config.chain_default.cluster_node.nodes={}
    | .config_service.chain_config.chain_default.public_conf.statedb.cluster_node.nodes=[]
    ' | jq . > ${g_conf_work}.tmp
    BCS_CHK_RC0 "revise ${g_conf_work} failed"
    CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ### set cluster size
    LOG "set cluster size"
    # cat ${g_conf_work} | jq '
    # .storage_cluster.cluster_size='"${count}"'
    # ' | jq . > ${g_conf_work}.tmp
    # BCS_CHK_RC0 "revise ${g_conf_work} failed"
    # CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
    # eval ${CMD}
    # BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ### set merkle tree type
    typeset merkle_type=${MYC_MERKLE_TREE_TYPE:-""}
    typeset enable_client_msu_db=${MYC_ENABLE_CLIENT_MSU:-1}
    LOG "set merkle tree type: ${merkle_type}"
    if [[ -n "${merkle_type}" ]]; then
      cat ${g_conf_work} | jq '
      .config_service.chain_config.chain_default.public_conf.statedb.db_type="'"${merkle_type}"'" |
      .config_service.chain_config.chain_default.feature_config.enable_client_msu_db='"${enable_client_msu_db}"' |
      .config_service.chain_config.chain_default.kvdb.default.db_path="'"../data"'" |
      .config_service.chain_config.chain_default.kvdb.default.db_type="'"rocksdb"'" |
      .config_service.chain_config.chain_default.kvdb.default.prefix="'""'" |
      .config_service.chain_config.chain_default.kvdb.default.cluster_node.nodes[0].node_id="'"0"'" |
      .config_service.chain_config.chain_default.kvdb.block_db.db_path="'"../data"'" |
      .config_service.chain_config.chain_default.kvdb.block_db.db_type="'"LETUS"'" |
      .config_service.chain_config.chain_default.kvdb.block_db.prefix="'""'" |
      .config_service.chain_config.chain_default.kvdb.block_db.cluster_node.nodes[0].node_id="'"0"'"
      ' | jq . > ${g_conf_work}.tmp
      BCS_CHK_RC0 "revise ${g_conf_work} failed for merkle tree"
      CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
      eval ${CMD}
      BCS_CHK_RC0 "CMD execution failed: ${CMD}"
    else
      LOG "environment variable MYC_MERKLE_TREE_TYPE is not set, use the type in source conf"
    fi

    # if [[ "${merkle_type}" == "FDMT" || "${merkle_type}" == ""  ]]; then
    #   cat ${g_conf_work} | jq '
    #   .storage_cluster.storage_kernel_state_db_gray_mode="double_write_read"
    #   ' | jq . > ${g_conf_work}.tmp
    #   BCS_CHK_RC0 "revise ${g_conf_work} failed for gray mode"
    #   CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
    #   eval ${CMD}
    #   BCS_CHK_RC0 "CMD execution failed: ${CMD}"
    # fi

    metric_json=$(cat ${g_conf_work} | jq -r '.config_service.chain_config.chain_default.metric.cetina')
    instance_name=$(cat ${g_conf_work} | jq -r '.config_service.chain_config.chain_default.metric.cetina.pamir_cetina_instance_name')

    ### add all node to cluster
    LOG "all all node to cluster configuration file"
    exec_code_block <<\EOF
        cat ${g_conf_work} | jq '
        .config_service.chain_config.chain_default.cluster_node.nodes."'"$MYID"'"={ "ip": "'"$IP"'", "port": '"$PORT"', "deploydir": "'"$RDIR"'" }
        | .config_service.chain_config.chain_default.public_conf.statedb.cluster_node.nodes+=[ { "node_id": "'"$MYID"'", "msu": "'"$MSU"'"  }]
        | .config_service.chain_config.chain_default.cluster_node.nodes."'"$MYID"'".metric.cetina='"${metric_json}"'
        ' | jq . > ${g_conf_work}.tmp
        BCS_CHK_RC0 "revise ${g_conf_work} failed"
        CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
        eval ${CMD}
        BCS_CHK_RC0 "CMD execution failed: ${CMD}"
EOF
    exec_code_block <<\EOF
        cat ${g_conf_work} | jq '
         .config_service.chain_config.chain_default.cluster_node.nodes."'"$MYID"'".metric.cetina.pamir_cetina_instance_name="'${g_env}_storage_${MYID}_${IP}'"
         ' | jq . > ${g_conf_work}.tmp
        BCS_CHK_RC0 "revise ${g_conf_work} failed"
        CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
        eval ${CMD}
        BCS_CHK_RC0 "CMD execution failed: ${CMD}"
EOF

    LOG "set statedb and kvdb path"
    exec_code_block ${node_id_list[0]} <<\EOF
        cat ${g_conf_work} | jq '
            .storage.myid='"\"${MYID}\""'
            | .config_service.chain_config.chain_default.public_conf.kvdb.cluster_node.nodes[0].node_id='"\"${MYID}\""'
            | if .config_service.chain_config.chain_default.kvdb.default == 'null' then
                .
              else
                .config_service.chain_config.chain_default.kvdb.default.cluster_node.nodes[0].node_id='"\"${MYID}\""'
              end
            | if .config_service.chain_config.chain_default.master_id == 'null' then
                .config_service.chain_config.chain_default.master_id='"\"${MYID}\""'
              else
                .
              end
            ' | jq . > ${g_conf_work}.tmp
        BCS_CHK_RC0 "revise ${g_conf_work} failed"
        CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
        eval ${CMD}
        BCS_CHK_RC0 "CMD execution failed: ${CMD}"
EOF

    if [[ ${gen_meta_only} -ne 1 ]]; then
    ## add etcd endpoints
    LOG "set etcd endpoints"
    cat ${g_conf_template} | jq '
        .storage.etcd.enable='"${etcd_enable}"'
        | .storage.etcd.endpoints=[]
        | .storage.data_path="'"${RDIR}/meta"'"
        ' | jq . > ${g_conf_template}.tmp
    BCS_CHK_RC0 "revise ${g_conf_template} failed"
    CMD="mv ${g_conf_template}.tmp ${g_conf_template}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ## add etcd endpoints
    LOG "set meta data etcd endpoints"
    cat ${g_conf_work} | jq '
        .storage.etcd.enable='"${etcd_enable}"'
        | .storage.etcd.endpoints=[]
        | .storage.data_path="'"${RDIR}/meta"'"
        ' | jq . > ${g_conf_work}.tmp
    BCS_CHK_RC0 "revise ${g_conf_work} failed"
    CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    LOG "all all etcd node to cluster configuration file"
    exec_code_block_etcd <<\EOF
        etcd_ip=${IP}
        if [[ "z${public_net_mode}" == "ztrue" ]]; then
          etcd_ip="127.0.0.1"
        fi

        cat ${g_conf_template} | jq '
        .storage.etcd.endpoints+=[ "http://'"$etcd_ip"':'"$PORT"'" ]
        ' | jq . > ${g_conf_template}.tmp
        BCS_CHK_RC0 "revise ${g_conf_template} failed"
        CMD="mv ${g_conf_template}.tmp ${g_conf_template}"
        eval ${CMD}
        BCS_CHK_RC0 "CMD execution failed: ${CMD}"

        cat ${g_conf_work} | jq '
        .storage.etcd.endpoints+=[ "http://'"$etcd_ip"':'"$PORT"'" ]
        ' | jq . > ${g_conf_work}.tmp
        BCS_CHK_RC0 "revise ${g_conf_work} failed"
        CMD="mv ${g_conf_work}.tmp ${g_conf_work}"
        eval ${CMD}
        BCS_CHK_RC0 "CMD execution failed: ${CMD}"
EOF
    ### send to all nodes and change conf accordingly
    LOG "send to all nodes and change conf accordingly"
    exec_code_block <<\EOF
    CMD="ssh ${RUSER}@$IP \"/bin/rm -rf ${RDIR}/conf ${RDIR}/log ${RDIR}/data ${RDIR}/meta; mkdir -p ${RDIR}/conf ${RDIR}/log ${RDIR}/data ${RDIR}/meta ${RDIR}/bin\""
    LOG "CMD=${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"
    if [[ ${g_support_supervisor} -eq 1 ]]; then
        CMD="ssh ${RUSER}@$IP \"/bin/rm -rf /etc/supervisor.conf; unlink /tmp/supervisord.sock\""
        eval ${CMD}
        my_gen_temp tmp_file
        local ENV_CWD_CT="/var/log"
        if [ "$RUSER" != "root" ]; then
            ENV_CWD_CT="/tmp"
        fi
        cat ${g_conf_supervisor} > ${tmp_file}
        sed -i "s#MIN_FDS#${g_supervisor_nr_open}#g;
                s#ENV_CWD#${ENV_CWD_CT}#g;
                s#ENV_USER#${RUSER}#g " ${tmp_file}
        BCS_CHK_RC0 "supervisor sed failed"
        mv ${tmp_file} supervisord.conf
        sync_file ${RUSER} ${IP} supervisord.conf /etc/supervisord.conf
        BCS_CHK_RC0 "sync_file supervisord.conf /etc/supervisord.conf failed"

        ssh ${RUSER}@$IP bash <<EOF_START_CMD_01
        [[ -x /usr/bin/supervisord ]] || { sudo yum install -y supervisor; }
        [[ \$(ps -ef|egrep 'supervisord' | wc -l) -gt 1 ]] && { sudo systemctl enable supervisord && sudo systemctl restart supervisord; } || { /usr/bin/supervisord -c /etc/supervisord.conf; }
        [[ -d /etc/supervisord.d/ ]] || { sudo mkdir -p /etc/supervisord.d/; }
EOF_START_CMD_01

        my_gen_temp tmp_file_watcher
        program_uuid=${RDIR}/bin
        program_uuid=${program_uuid//'/'/'_'}
        program_command="${RDIR}/bin/storagesvc -c ${RDIR}/conf/svc.conf"
        program_directory="${RDIR}/bin"
        ROLE_NAME="storagesvc_${IP}_${MYID}.ini"
        program_priority="10"

        cat ${g_conf_supervisor_watcher} > ${tmp_file_watcher}
        sed -i "s#PROGRAM_UUID#${program_uuid}#g;
                s#PROGRAM_COMMAND#${program_command}#g;
                s#PROGRAM_DIRECTORY#${program_directory}#g;
                s#ROLE_NAME#${ROLE_NAME}#g
                s#PROGRAM_PRIORITY#${program_priority}#g" ${tmp_file_watcher}
        mv ${tmp_file_watcher} ${ROLE_NAME}
        sync_file ${RUSER} ${IP} ${ROLE_NAME} /etc/supervisord.d/${ROLE_NAME}
        BCS_CHK_RC0 "sync_file ${ROLE_NAME} /etc/supervisord.d/${ROLE_NAME} failed"
    fi
    sync_file ${RUSER} ${IP} ${bindir}/bin/storagesvc ${RDIR}/bin/storagesvc
    BCS_CHK_RC0 "sync_file ${bindir}/bin/storagesvc ${RDIR}/bin/storagesvc failed"
    sync_file ${RUSER} ${IP} ${bindir}/bin/storage_tool ${RDIR}/bin/storage_tool
    BCS_CHK_RC0 "sync_file ${bindir}/bin/storage_tool ${RDIR}/bin/storage_tool failed"
    sync_file ${RUSER} ${IP} ${bindir}/bin/meta_tool ${RDIR}/bin/meta_tool
    BCS_CHK_RC0 "sync_file ${bindir}/bin/meta_tool ${RDIR}/bin/meta_tool failed"
    # sync_file ${RUSER} ${IP} ${bindir}/bin/conf_tool.sh ${RDIR}/bin/conf_tool.sh
    # BCS_CHK_RC0 "sync_file ${bindir}/bin/conf_tool.sh ${RDIR}/bin/conf_tool.sh failed"
    # sync_file ${RUSER} ${IP} ${bindir}/bin/common.sh ${RDIR}/bin/common.sh
    # BCS_CHK_RC0 "sync_file ${bindir}/bin/common.sh ${RDIR}/bin/common.sh failed"
    if [[ -e ${bindir}/bin/chain_node ]]; then
        sync_file ${RUSER} ${IP} ${bindir}/bin/chain_node ${RDIR}/bin/chain_node
        BCS_CHK_RC0 "sync_file ${bindir}/bin/chain_node ${RDIR}/bin/chain_node failed"
    fi

    CMD="scp ${g_conf_template} ${RUSER}@$IP:${RDIR}/conf/svc.conf.tmp"
    LOG "CMD=${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ssh ${RUSER}@$IP "cd ${RDIR}/;
        cat conf/svc.conf.tmp | jq '
            .storage.myid='\\\"${MYID}\\\"'
            ' > conf/svc.conf; rm -rf conf/svc.conf.tmp"
EOF
    else
      MSG "meta json file: ${g_conf_work}"
    fi
    /bin/rm -f "${g_conf_template}"
}

function etcd_ps {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    exec_code_block_etcd -e ${dm_name} ${idlist} <<\EOF
    ssh ${RUSER}@$IP "[[ ! -d ${RDIR}/bin ]] && exit; cd ${RDIR}/bin;
      [[ -s pid.etcd ]] && ps -o ruser=01234567890123 -o pid,ppid,stime,cmd --no-headers \$(cat pid.etcd)"
EOF
}

function node_ps {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    exec_code_block -e ${dm_name} ${idlist} <<\EOF
    ssh ${RUSER}@$IP "cd ${RDIR}/bin; [[ -s pid ]] && ps -o ruser=01234567890123 -o pid,ppid,stime,cmd --no-headers \$(cat pid)"
EOF
}
function node_psall {
    BCS_FUNCTION_BEGIN
    local idlist="${1:-}"
    exec_code_block ${idlist} <<\EOF
    ssh ${RUSER}@$IP "ps -o ruser=01234567890123 -e -o pid,ppid,stime,cmd | egrep \"^\$(id -un).*chain_node [0-9]+\" | grep -v grep"
EOF
}

function local_setmeta {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    typeset meta_type=""
    typeset loglevel=""
    typeset confdir=""
    typeset datadir=""
    typeset meta_file=${g_meta_file}
    typeset meta_path=""
    typeset meta_file=""
    if [[ $# -ge 1 ]]; then
        meta_file=$1
    fi
    typeset agent_ip="127.0.0.1"
    if [[ $# -ge 2 ]]; then
        agent_ip=$2
    fi
    typeset user="root"
    if [[ $# -ge 3 ]]; then
        user=$3
    fi
    unset OPTIND
    while getopts t:e:c:d:i: ch; do
        case ${ch} in
        "t") meta_type=${OPTARG};;
        "e") dm_name=${OPTARG};;
        "c") confdir=${OPTARG};;
        "d") meta_path=${OPTARG};;
        "i") agent_ip=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))

    ip=${agent_ip}
    echo "ip: ${ip}, user: ${user}, meta_file: ${meta_file}"
    ssh ${user}@${ip} "mkdir -p /tmp/mygrid; rm -rf /tmp/mygrid/*"
    sync_file ${user} ${ip} ${meta_file} /tmp/mygrid/meta_data.mono.json
    sync_file ${user} ${ip} $MNGDIR/lite_conf_tool.sh /tmp/mygrid/lite_conf_tool.sh
    sync_file ${user} ${ip} $MNGDIR/common.sh /tmp/mygrid/common.sh
    sync_file ${user} ${ip} $MNGDIR/../bin/meta_tool /tmp/mygrid/meta_tool
    CMD="ssh ${user}@${ip} \"cd /tmp/mygrid; export PATH=/tmp/mygrid:$PATH; sh lite_conf_tool.sh -c /tmp/mygrid/meta_data.mono.json -d 5\""
    LOG "${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"
    LOG "no additional meta_type is specified"
}

function cluster_setmeta {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    typeset meta_type=""
    typeset loglevel=""
    typeset confdir=""
    typeset datadir=""
    typeset public_net_mode=false
    if [[ $# -ge 1 ]]; then
        if [[ "z$1" == "ztrue" ]]; then
            public_net_mode=true
        fi
    fi
    typeset agent_ip="127.0.0.1"
    if [[ $# -ge 2 ]]; then
        agent_ip=$2
    fi
    unset OPTIND
    while getopts t:e:c:d: ch; do
        case ${ch} in
        "t") meta_type=${OPTARG};;
        "e") dm_name=${OPTARG};;
        "c") confdir=${OPTARG};;
        "d") datadir=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    #BCS_RUN_AND_CHK "[[ -n \"${loglevel}\" ]] @@@ log level is not specified"

    [[ -f "${g_meta_file}" ]]
    BCS_CHK_RC0 "meta data file not exist: ${g_meta_file}, please make sure cluster has been deploied successfully"

    case ${meta_type} in
      "2level")
          MSG "set meta for ${meta_type}"
          switch_to_2level_tree_mode
          ;;
      "2level_gray")
          MSG "set meta for ${meta_type}"
          switch_to_2level_tree_gray_mode
          ;;
      "2level_gray_cluster")
          MSG "set meta for ${meta_type}"
          switch_to_2level_tree_gray_cluster_mode
          ;;
      "2level_letus")
          MSG "set meta for ${meta_type}"
          switch_to_2level_tree_letus_mode
          ;;
      "2level_letus_cluster")
          MSG "set meta for ${meta_type}"
          switch_to_2level_tree_letus_cluster_mode
          ;;
      "mychain0.10")
          MSG "set meta for ${meta_type}"
          switch_from_old_mychain_conf_to_meta $confdir $datadir
          ;;
      "aldaba")
          MSG "set meta for ${meta_type}"
          ;;
      "") 
            CMD="sh $MNGDIR/conf_tool.sh -c ${g_meta_file} -m ${g_domain_id} import_all"
            if [[ "z${public_net_mode}" == "ztrue" ]]; then
                sed -ri 's;"http://[0-9.]+:;"http://127.0.0.1:;g' ${g_meta_file}
                sed -ri 's;"http://[0-9.]+:;"http://127.0.0.1:;g' ${g_meta_file}
                sed -ri 's;"http://[0-9.]+:;"http://127.0.0.1:;g' ${g_meta_file}
                ip=${agent_ip}
                sed -ri 's;"ip": "[0-9.]+";"ip": "0.0.0.0";g' ${g_meta_file}
                user=$(cat ${g_file} | jq -r '.env.'"${dm_name}"'.etcd.cluster[0].user')
                meta_file_name=`echo ${g_meta_file} | awk -F'/' '{print $NF}'`
                ssh ${user}@${ip} "mkdir -p /tmp/mygrid; rm -rf /tmp/mygrid/*"
                sync_file ${user} ${ip} $MNGDIR/conf_tool.sh /tmp/mygrid/conf_tool.sh
                sync_file ${user} ${ip} $MNGDIR/common.sh /tmp/mygrid/common.sh
                sync_file ${user} ${ip} $MNGDIR/../bin/meta_tool /tmp/mygrid/meta_tool
                sync_file ${user} ${ip} ${g_meta_file} /tmp/mygrid/${meta_file_name}
                CMD="ssh ${user}@${ip} \"cd /tmp/mygrid; export PATH=/tmp/mygrid:$PATH; sh conf_tool.sh -c /tmp/mygrid/${meta_file_name} import_all\""
            fi
            LOG "${CMD}"
            eval ${CMD}
            BCS_CHK_RC0 "CMD execution failed: ${CMD}"
            LOG "no additional meta_type is specified"
            ;;
      *)  ERR "unknown meta_type: ${meta_type}"; return 1;;
    esac
}

function cluster_setlog {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    typeset loglevel=""
    unset OPTIND
    while getopts l:e: ch; do
        case ${ch} in
        "l") loglevel=${OPTARG};;
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    BCS_RUN_AND_CHK "[[ -n \"${loglevel}\" ]] @@@ log level is not specified"

    typeset idlist="${1:-}"
    LOG "cluster_setlog loglevel=${loglevel} dm_name=${dm_name} idlist=${idlist}"
    exec_code_block_async -e ${dm_name} ${idlist} <<\EOF
    ret=$(ssh ${RUSER}@$IP "cd ${RDIR}/conf; \
        conffile=svc.conf;
        cat \${conffile} | jq '.log.storage_service.level=\"'"${loglevel}"'\"' > \${conffile}.tmp && \
        mv \${conffile}.tmp \${conffile} && echo ok")
    LOG "ret=${ret}"
    [[ "${ret}" == "ok" ]]
EOF
}

function cluster_mkdir {
    BCS_FUNCTION_BEGIN
    typeset dir=
    unset OPTIND
    while getopts d: ch; do
        case ${ch} in
        "d") dir=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    BCS_RUN_AND_CHK "[[ -n \"${dir}\" ]] @@@ dir is not specified"

    typeset idlist="${1:-}"
    LOG "cluster_mkdir dir=${dir} idlist=${idlist}"
    exec_code_block_async ${idlist} <<\EOF
    ret=$(ssh ${RUSER}@$IP "cd ${RDIR}; \
        mkdir -p ${dir} && echo ok")
    LOG "mkdir:${dir} on ${id} ret=${ret}"
    [[ "${ret}" == "ok" ]]
EOF
}
function cluster_check_ps {
    BCS_FUNCTION_BEGIN
    local idlist="${1:-}"
    exec_code_block_async ${idlist} <<\EOF
    ret=$(ssh ${RUSER}@$IP "cd ${RDIR}/bin; [[ -s pid ]] && kill -0 \$(cat pid) 2>/dev/null && echo ok")
    [[ "${ret}" == "ok" ]]
EOF
}
function cluster_check_status {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local expect_status="${1:-}"
    local idlist="${2:-}"
    LOG "check status on [${idlist:-ALL}] for ${dm_name}, expect ${expect_status}"
    exec_code_block_async -e ${dm_name} ${idlist} <<\EOF
      cluster_status -e ${dm_name} $id cluster_check_status_st
      [[ "${cluster_check_status_st}" == "${expect_status}" ]]
    # if [[ ${DM_TYPE} == "chain_cluster" ]]; then
    #   cluster_status $id cluster_check_status_st
    #   [[ "${cluster_check_status_st}" == "${expect_status}" ]]
    # else
    #   typeset output=$(ssh ${RUSER}@$IP "cd ${RDIR}/bin; [[ -f pid ]] && kill -0 \$(cat pid) 2>/dev/null && echo ok")
    #   [[ "${output}" == "ok" ]]
    # fi
EOF
}
function get_node_attr {
    BCS_FUNCTION_BEGIN
    typeset verbose0=
    [[ ${SHELLOPTS} =~ verbose ]] && verbose0=1 || verbose0=0
    set +vx
    typeset env=${1?"no env name"}
    typeset node=${2?"no env name"}
    typeset attrname=${3?"no attr name"}
    typeset vname=${4?"no var name"}
    typeset idx=0
    typeset value=$(cat ${g_file} | jq -r '.env.'"${env}"'.nodes.'"${node}"'.'"${attrname}"'')
    DBG "${vname}=${value}"
    eval ${vname}=${value}
    [[ "${value}" == "null" ]] && ret=1
    [[ "${verbose0}" -eq 1 ]] && set -vx
    return ${ret}
}

function get_merkle_type {
    BCS_FUNCTION_BEGIN
    typeset env=${1?"no env name"}
    typeset vname=${2?"no var name"}
    typeset type=$(cat ${g_meta_file} | jq -cr '
      getpath(["config_service","chain_config","chain_default","public_conf","statedb","db_type"])' )
    [[ -z "${type}" || "${type}" == "null" ]] && type="FDMT"
    DBG "${vname}=${type}"
    eval ${vname}=${type}
}
function get_domain_type {
    BCS_FUNCTION_BEGIN
    typeset env=${1?"no env name"}
    typeset vname=${2?"no var name"}
    typeset idx=0
    typeset type="$(cat ${g_file} | jq -r '.env.'"${env}"'.type')"
    DBG "${vname}=${type}"
    eval ${vname}=${type}
}
function get_node_list {
    BCS_FUNCTION_BEGIN
    typeset env=${1?"no env name"}
    typeset vname=${2?"no var name"}
    typeset idx=0
    for i in $(cat ${g_file} | jq -r '.env.'"${env}"'.nodes | to_entries | .[].key'); do
        DBG "${vname}[$idx]=$i"
        eval ${vname}[$idx]=$i
        ((idx++))
    done
    true
}
function etcd_get_node_count {
  BCS_FUNCTION_BEGIN
  typeset env=${1?"no env name"}
  typeset vname=${2?"no var name"}
  typeset count=$(cat ${g_file} | jq '.env.'"${g_env}"'.etcd.cluster | length')
  eval ${vname}=${count}
}
function etcd_get_node_list {
    BCS_FUNCTION_BEGIN
    typeset env=${1?"no env name"}
    typeset vname=${2?"no var name"}
    typeset idx=0
    typeset etcd_count_
    etcd_get_node_count ${env} etcd_count_
    for i in $(seq ${etcd_count_}); do
        DBG "${vname}[$idx]=$i"
        eval ${vname}[$idx]=$i
        ((idx++))
    done
}
function etcd_start_all {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    LOG "node_start_all idlist=${idlist} dm_name=${dm_name}"
    # use >> to make sure all process started can be killed by stop command
    # of course, the later process may startup fail, because of port occupied, but anyany...
    ## abort_on_errror will create coredump even if asan is enabled
    exec_code_block_etcd -e ${dm_name} "${idlist}" <<\EOF
    program_uuid=${RDIR}/bin
    program_uuid=${program_uuid//'/'/'_'}
    ROLE_NAME="etcd_${IP}_${MYID}.ini"
    ssh ${RUSER}@$IP bash <<EOF_START_CMD_01
    if [[ ${g_support_supervisor} -eq 1 ]]; then
        echo "start etcd supervisor ${IP}"
        cd ${RDIR}/bin && \
        [[ \$(ps -ef|egrep 'supervisord' | wc -l) -gt 1 ]] && ([[ -x /usr/bin/supervisorctl ]] && { supervisorctl stop ${program_uuid}:${ROLE_NAME} >/dev/null 2>&1; });
        [[ \$(ps -ef|egrep 'supervisord' | wc -l) -gt 1 ]] && ([[ -x /usr/bin/supervisorctl ]] && { supervisorctl update ${program_uuid}; });
        [[ \$(ps -ef|egrep 'supervisord' | wc -l) -gt 1 ]] && ([[ -x /usr/bin/supervisorctl ]] && { supervisorctl start ${program_uuid}:${ROLE_NAME} >/dev/null 2>&1; });
        echo \"\$(date) wait etcd start\" && \
        for((i=1; i<=60; i++)); do sleep 1; [[ \$(ps -ef|egrep 'supervisord' | wc -l) -gt 1 ]] && [[ \$(supervisorctl status |grep ${program_uuid}:${ROLE_NAME} |awk '{print  \$2}' | grep RUNNING | wc -l) -gt 0 ]] && break; echo \"\$(date) wait file .etcd\"; done
    else
        echo "start etcd ${IP}" && \
        cd ${RDIR}/bin && \
        rm -f stdout.etcd .etcd.pid >/dev/null 2>&1 && \
        nohup ./etcd_start.sh > stdout.etcd 2>&1 && sleep 1 && PID=\$(cat .etcd.pid) && sleep 1 && kill -0 \$PID && echo \$PID > pid.etcd;
    fi
EOF_START_CMD_01
EOF
}
function node_start_all {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    LOG "node_start_all idlist=${idlist} dm_name=${dm_name}"
    # use >> to make sure all process started can be killed by stop command
    # of course, the later process may startup fail, because of port occupied, but anyany...
    ## abort_on_errror will create coredump even if asan is enabled
    exec_code_block_async -e ${dm_name} "${idlist}" <<\EOF
    ################################################################
    ## must force use bash to run command on remote machine with ssh
    ## becasue don't know what's the default shell on remote machine
    program_uuid=${RDIR}/bin
    program_uuid=${program_uuid//'/'/'_'}
    ROLE_NAME="storagesvc_${IP}_${MYID}.ini"
    ssh ${RUSER}@$IP bash <<EOF_START_CMD_01
        cd ${RDIR}/bin;
        export ASAN_OPTIONS=detect_leaks=true:leak_check_at_exit=true:disable_coredump=0:unmap_shadow_on_exit=1:abort_on_error=1:log_path=${RDIR}/bin/asan.log
        [[ -d ${RDIR}/data ]] && { cd ${RDIR}/data; find . -name LOCK | xargs -I {} /bin/rm -rf {}; };
        [[ -d ${RDIR}/data ]] && { cd ${RDIR}/data; find . -name owner_lock | while read f; do /bin/rm -rf \$f; touch \$f; done; };
        cd ${RDIR}/bin; /bin/rm -rf .mychain_pid pid;
        if [[ ""${DM_TYPE}"" == "chain_cluster" || ""${DM_TYPE}"" == "mono" ]]; then
          nohup ./chain_node ${REST_PORT} > stdout 2>&1 & PID=\$! && sleep 1 && kill -0 \$PID && \
            echo \$PID > pid || echo "something failed to start chain_node PID=\$PID MYID=${MYID}";
        else
            if [[ ${g_support_supervisor} -eq 1 ]]; then
                    [[ \$(ps -ef|egrep 'supervisord' | wc -l) -gt 1 ]] && ([[ -x /usr/bin/supervisorctl ]] && { supervisorctl stop ${program_uuid}:${ROLE_NAME} >/dev/null 2>&1; });
                    [[ \$(ps -ef|egrep 'supervisord' | wc -l) -gt 1 ]] && ([[ -x /usr/bin/supervisorctl ]] && { supervisorctl update ${program_uuid}; });
                    [[ \$(ps -ef|egrep 'supervisord' | wc -l) -gt 1 ]] && ([[ -x /usr/bin/supervisorctl ]] && { supervisorctl start ${program_uuid}:${ROLE_NAME} >/dev/null 2>&1; });
                    echo \"\$(date) wait storagesvc start\" && \
                    for((i=1; i<=60; i++)); do sleep 1; [[ -s .mychain_pid ]] && break; echo \"\$(date) wait file .mychain_pid\"; done && \
                    PID=\$(cat .mychain_pid) && sleep 1 && echo "PID=\${PID}" && \
                    kill -0 \$PID && echo \$PID > pid || echo "something failed to start storagesvc PID=\$PID MYID=${MYID}";
            else
                    nohup ./storagesvc -c ../conf/svc.conf -d && \
                        echo \"\$(date) wait storagesvc start\" && \
                        for((i=1; i<=60; i++)); do sleep 1; [[ -s .mychain_pid ]] && break; echo \"\$(date) wait file .mychain_pid\"; done && \
                        PID=\$(cat .mychain_pid) && sleep 1 && echo "PID=\${PID}" && \
                        kill -0 \$PID && echo \$PID > pid || echo "something failed to start storagesvc PID=\$PID MYID=${MYID}";
            fi
        fi
EOF_START_CMD_01
EOF
}
function node_start_all_test_memleak {
    BCS_FUNCTION_BEGIN
    local idlist="${1:-}"
    # TEST_MEMLEAK is used to test if rest-framework has memory leak, in this mode,
    # all REST request will retrun immediatelly and do nothing
    # use >> to make sure all process started can be killed by stop command
    # of course, the later process may startup fail, because of port occupied, but anyany...
    exec_code_block "${idlist}" <<\EOF
    ssh ${RUSER}@$IP "cd ${RDIR}/bin; export RUNMODE=TEST_MEMLEAK; nohup ./chain_node ${REST_PORT}  > stdout 2>&1 & PID=\$! && sleep 1 && kill -0 \$PID && echo \$PID > pid"
EOF
}
function cluster_erase {
    cluster_erase_single -e ${g_env}
    if [[ "${g_dmtype}" != "mono" ]]; then
      cluster_erase_single -e ${g_testdm}
      etcd_erase_single -e ${g_env}
    fi
}
function cluster_erase_single {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    exec_code_block -e ${dm_name} "${idlist}" <<\EOF
    ssh ${RUSER}@$IP "/bin/rm -rf ${RDIR}"
EOF
}
function etcd_erase_single {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    exec_code_block_etcd -e ${dm_name} "${idlist}" <<\EOF
    ssh ${RUSER}@$IP "/bin/rm -rf ${RDIR}/data/etcd ${RDIR}/bin/etcd* ${RDIR}/bin/.etcd* ${RDIR}/bin/*.etcd ${RDIR}/log/etcd*"
    #donot delete entire folder, becasue etcd maybe exist in svc's folder
    #ssh ${RUSER}@$IP "/bin/rm -rf ${RDIR}"
EOF
}
function mono_meta_clean_all {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    exec_code_block -e ${dm_name} "${idlist}" <<\EOF
    ssh ${RUSER}@$IP "[[ ! -d ${RDIR}/bin ]] && exit; cd ${RDIR}; rm -rf meta/*"
EOF
}
function node_clean_all {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    exec_code_block -e ${dm_name} "${idlist}" <<\EOF
    ssh ${RUSER}@$IP "[[ ! -d ${RDIR}/bin ]] && exit; cd ${RDIR}; rm -rf data/* log/*.log bin/epoch.conf bin/pid bin/.mychain_pid bin/stdout* bin/stderr*"
EOF
}
function etcd_clean_all {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    ps aux | grep etcd
    exec_code_block_etcd -e ${dm_name} "${idlist}" <<\EOF
    ssh ${RUSER}@$IP "cd ${RDIR}; rm -rf data/etcd bin/stdout.etcd meta/"
EOF
}
function etcd_kill_all {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    LOG "kill process on idlist[${idlist}] dm_name=${dm_name}"
    exec_code_block_etcd -e ${dm_name} "${idlist}" <<\EOF
    LOG "kill process on [${id} ${IP}] dm_name=${dm_name} RDIR=${RDIR}"
    ################################################################
    ## must force use bash to run command on remote machine with ssh
    ## becasue don't know what's the default shell on remote machine
    program_uuid=${RDIR}/bin
    program_uuid=${program_uuid//'/'/'_'}
    ROLE_NAME="etcd_${IP}_${MYID}.ini"
    ssh ${RUSER}@$IP bash <<EOF_KILL_CMD_01
    if [[ ${g_support_supervisor} -eq 1 ]]; then
        [[ \$(ps -ef|egrep 'supervisord' | wc -l) -gt 1 ]] && ([[ -x /usr/bin/supervisorctl ]] && { supervisorctl stop ${program_uuid}:${ROLE_NAME} >/dev/null 2>&1; });
        echo \"\$(date) wait etcd stop\"
        for((i=1; i<=60; i++)); 
        do
            sleep 1;            
            [[ \$(supervisorctl status |grep ${program_uuid}:${ROLE_NAME} | wc -l) -eq 0 ]] && break;
            [[ \$(supervisorctl status |grep ${program_uuid}:${ROLE_NAME} |awk '{print  \$2}' | grep STOPPED | wc -l) -gt 0 ]] && break;
            [[ \$(ps -ef|egrep 'supervisord' | wc -l) -gt 1 ]] && [[ \$(supervisorctl status |grep ${program_uuid}:${ROLE_NAME} |awk '{print  \$2}' | grep RUNNING | wc -l) -gt 0 ]] && { supervisorctl stop ${program_uuid}:${ROLE_NAME} >/dev/null 2>&1; };
            echo \"\$(date) wait etcd stop\";
        done
    else
        [[ ! -d ${RDIR}/bin ]] && exit; cd ${RDIR}/bin;
        [[ -s pid.etcd ]] && kill -9 \$(cat pid.etcd) 2>/dev/null;
        [[ -s pid.etcd ]] && { kill -0 \$(cat pid.etcd) 2>/dev/null || rm -f pid.etcd 2>/dev/null; }
    fi
EOF_KILL_CMD_01

    ## force kill again, kill process according to cwd
    #set -vx
    ## must use "pwd -p" to get the read path, because proc filesystem use the real path
    ssh ${RUSER}@$IP bash <<EOF_KILL_CMD_02
        [[ ! -d ${RDIR}/bin ]] && exit; cd ${RDIR}/bin && RDIR2=\$(pwd -P) &&
        plist=\$(ps -ef|egrep 'etcd --config-file' |grep -v grep | awk '{print \$2}'| while read pid; do
            [[ \$(ls -ld /proc/\$pid/cwd | sed 's/(deleted)//' | awk '{print \$NF}') == \${RDIR2} ]] && echo \$pid; done);
        [[ -n \${plist} ]] && echo "kill ps for etcd:\${plist}" && kill -9 \${plist};
        plist=\$(ps -ef|egrep 'etcd --config-file' |grep -v grep | awk '{print \$2}'| while read pid; do
            [[ \$(ls -ld /proc/\$pid/cwd | awk '{print \$NF}') =~ ^\(deleted\)$ ]] && echo \$pid; done);
        #echo plist=\${plist};
        [[ -n \${plist} ]] && echo "kill ps for deleted folder: \${plist}" && kill -9 \${plist};
EOF_KILL_CMD_02
EOF
}
function node_kill_all {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts me: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    LOG "kill process on idlist[${idlist}] dm_name=${dm_name}"
    exec_code_block -e ${dm_name} "${idlist}" <<\EOF
    LOG "kill process on [${id} ${IP}] dm_name=${dm_name} RDIR=${RDIR}"
    program_uuid=${RDIR}/bin
    program_uuid=${program_uuid//'/'/'_'}
    ROLE_NAME="storagesvc_${IP}_${MYID}.ini"
    ssh ${RUSER}@$IP bash <<EOF_NODE_KILL_ALL_01
    if [[ ${g_support_supervisor} -eq 1 ]]; then
        [[ \$(ps -ef|egrep 'supervisord' | wc -l) -gt 1 ]] && ([[ -x /usr/bin/supervisorctl ]] && { supervisorctl stop ${program_uuid}:${ROLE_NAME} >/dev/null 2>&1; });
        echo \"\$(date) wait storagesvc stop\"
        for((i=1; i<=60; i++));
        do 
            sleep 1;
            [[ \$(supervisorctl status |grep ${program_uuid}:${ROLE_NAME} | wc -l) -eq 0 ]] && break;
            [[ \$(supervisorctl status |grep ${program_uuid}:${ROLE_NAME} |awk '{print  \$2}' | grep STOPPED | wc -l) -gt 0 ]] && break;
            [[ \$(ps -ef|egrep 'supervisord' | wc -l) -gt 1 ]] && [[ \$(supervisorctl status |grep ${program_uuid}:${ROLE_NAME} |awk '{print  \$2}' | grep RUNNING | wc -l) -gt 0 ]] && { supervisorctl stop ${program_uuid}:${ROLE_NAME} >/dev/null 2>&1; };
            echo \"\$(date) wait storagesvc stop\";
        done
    else
        [[ ! -d ${RDIR}/bin ]] && exit; cd ${RDIR}/bin;
        [[ -s pid ]] && kill -9 \$(cat pid) 2>/dev/null;
        [[ -s pid ]] && { kill -0 \$(cat pid) 2>/dev/null || rm -f pid 2>/dev/null; };
    fi
EOF_NODE_KILL_ALL_01

    ## force kill again, kill process according to cwd
    #set -vx
    ## must use "pwd -p" to get the read path, because proc filesystem use the real path
    ## cleanup LOCK file, otherwise next start may fail
    ssh ${RUSER}@$IP bash <<EOF_NODE_KILL_ALL_02
        [[ ! -d ${RDIR}/bin ]] && exit; cd ${RDIR}/bin; RDIR2=\$(pwd -P);
        plist=\$(ps -ef|egrep '(storagesvc |chain_node )' | grep -v grep |
          awk '{print \$2}'| while read pid; do
            [[ \$(ls -ld /proc/\$pid/cwd | sed 's/(deleted)//' | awk '{print \$NF}') == \${RDIR2} ]] && echo \$pid;
          done);
        [[ -n \${plist} ]] && echo "kill ps for \${plist}" && kill -9 \${plist};
        plist=\$(ps -ef|egrep '(chain_node|storagesvc)' |grep -v grep |
          awk '{print \$2}'| while read pid; do
            [[ \$(ls -ld /proc/\$pid/cwd | awk '{print \$NF}') =~ ^\(deleted\)$ ]] && echo \$pid;
          done);
        [[ -n \${plist} ]] && echo "kill ps for deleted folder: \${plist}" && kill -9 \${plist};
        [[ -d ${RDIR}/data ]] && { cd ${RDIR}/data; find . -name LOCK | xargs -I {} /bin/rm -rf {}; };
        [[ -d ${RDIR}/data ]] && { cd ${RDIR}/data; find . -name owner_lock | while read f; do /bin/rm -rf \$f; touch \$f; done; };
EOF_NODE_KILL_ALL_02
EOF
}
## restart one node or all nodes
function cluster_restart_all_dm {
    cluster_restart -e ${g_env};  BCS_CHK_RC0 "failed to run: cluster_restart -e ${g_env}"
    if [[ "${g_dmtype}" != "mono" ]]; then
        cluster_restart -e ${g_testdm}
        BCS_CHK_RC0 "failed to run: cluster_restart -e ${g_testdm}"
    fi
}

function cluster_restart {
   BCS_FUNCTION_BEGIN
   typeset dm_name=${g_env}
   unset OPTIND
   while getopts e: ch; do
       case ${ch} in
       "e") dm_name=${OPTARG};;
       esac
   done
   shift $((OPTIND-1))
   local id="${1:-}"
   export SS_SILENT=1
   LOG "cluster_restart ${dm_name} ${id}"
   cluster_shutdown -e ${dm_name} ${id}
   ######
   typeset retry=0
   typeset retrymax=20
   while true; do
       ((retry++))
       LOG "check cluster status is shutdown: ${dm_name} retry(${retry}/${retrymax})"
       [[ ${retry} -ge ${retrymax} ]] && ERR "cluster status is not ${g_st_shutdown} after retry ${retrymax} time" && return 1
       cluster_check_status -e ${dm_name} "${g_st_shutdown}" ${id}
       [[ $? -ne 0 ]] && sleep 1 && continue
       break
   done

   ## startup
   cluster_startup -e ${dm_name} ${id}
   typeset retry=0
   typeset retrymax=20
   while true; do
       ((retry++))
       LOG "check cluster status is ${g_st_running}: ${dm_name} retry(${retry}/${retrymax})"
       [[ ${retry} -ge ${retrymax} ]] && ERR "cluster status is not ${g_st_running} after retry ${retrymax} time" && return 2
       cluster_check_status -e ${dm_name} "${g_st_running}" ${id}
       [[ $? -ne 0 ]] && sleep 1 && continue
       break
   done
   return 0
}

function mono_kill_all {
   LOG "mono_kill_all dm_name=${g_env}"
   typeset reset_retry_max=10
   typeset reset_retry=10
   for((reset_retry=1; reset_retry<=reset_retry_max; reset_retry++)); do
       LOG "node_kill_all on ${g_env} try[${reset_retry}/${reset_retry_max}]"
       node_kill_all -e ${g_env}
       sleep 1  ## wait to be stable
       cluster_check_status -e ${g_env} "${g_st_shutdown}"
       [[ $? -eq 0 ]] && break
   done
   [[ ${reset_retry} -le ${reset_retry_max} ]]
   BCS_CHK_RC0 "node_kill_all(${g_env}) failed: cluster status is not ${g_st_shutdown}"
}

function meta_reset_single {
    if [[ "${g_dmtype}" != "mono" ]]; then
      etcd_reset_single
    else
      mono_kill_all
      mono_meta_clean_all
    fi
}

function cluster_reset {
    typeset meta_file=${1:-${g_meta_file}}
    
    meta_reset_single

    CMD="sh $MNGDIR/conf_tool.sh -c ${meta_file} -m ${g_domain_id} import_all"
    LOG "${CMD}"
    eval ${CMD}
    BCS_CHK_RC0 "CMD execution failed: ${CMD}"

    ## allow case to customize a function to update meta data
    typeset func="${g_case}_update_meta"
    if type ${func} >/dev/null 2>&1; then
      ${func}
      BCS_CHK_RC0 "meta_update plugin is specified, but execution failed: ${func}"
    fi

    cluster_reset_single -e ${g_env}

    if [[ "${g_dmtype}" != "mono" ]]; then
      cluster_reset_single -e ${g_testdm}
    fi
}

function cluster_reset_single {
   BCS_FUNCTION_BEGIN
   typeset dm_name=${g_env}
   unset OPTIND
   while getopts e: ch; do
       case ${ch} in
       "e") dm_name=${OPTARG};;
       esac
   done
   shift $((OPTIND-1))
   export SS_SILENT=1
   ## ignore these error msg
   #{
   ## must comment following 2 lines, otherwise shutdown will fail
   #do_statedb_close node0
   #cluster_uninit
   #cluster_shutdown
   #}
   ## force kill, avoid hang in close
   LOG "cluster_reset_single dm_name=${dm_name}"
   typeset reset_retry_max=10
   typeset reset_retry=10
   for((reset_retry=1; reset_retry<=reset_retry_max; reset_retry++)); do
       LOG "node_kill_all on ${dm_name} try[${reset_retry}/${reset_retry_max}]"
       node_kill_all -e ${dm_name}
       sleep 1  ## wait to be stable
       cluster_check_status -e ${dm_name} "${g_st_shutdown}"
       [[ $? -eq 0 ]] && break
   done
   [[ ${reset_retry} -le ${reset_retry_max} ]]
   BCS_CHK_RC0 "node_kill_all(${dm_name}) failed: cluster status is not ${g_st_shutdown}"
   #sleep 1
   #node_kill_all
   node_clean_all -e ${dm_name}
   cluster_startup -e ${dm_name}
   for((reset_retry=1; reset_retry<=reset_retry_max; reset_retry++)); do
       sleep 1
       LOG "cluster_check_status "${g_st_running}" try[${reset_retry}/${reset_retry_max}]"
       cluster_check_status -e ${dm_name} "${g_st_running}"
       [[ $? -eq 0 ]] && break
   done
   [[ ${reset_retry} -le ${reset_retry_max} ]]
   BCS_CHK_RC0 "cluster status is not ${g_st_running}"
   #sleep 1
   #cluster_check_ps  #check process, not enough
}
function etcd_reset_single {
   BCS_FUNCTION_BEGIN
   typeset dm_name=${g_env}
   unset OPTIND
   while getopts e: ch; do
       case ${ch} in
       "e") dm_name=${OPTARG};;
       esac
   done
   shift $((OPTIND-1))
   #export SS_SILENT=1
   LOG "kill etcd process for dm: ${dm_name}"
   etcd_kill_all -e ${dm_name}

   LOG "cleanup etcd for dm: ${dm_name}"
   etcd_clean_all -e ${dm_name}

   LOG "startup etcd for dm: ${dm_name}"
   etcd_start_all -e ${dm_name}
   BCS_CHK_RC0 "startup etcd failed"
}
function check_http_status {
    BCS_FUNCTION_BEGIN
    typeset case=${1:-}
    typeset file=${2:-}
    [[ -f "${file}" ]]
    BCS_CHK_RC0 "ERROR: json file not exist:${file}"
    typeset log=$(cat ${file})
    LOG "check_http_status ${log}"
    typeset code=$(cat ${file} | jq '.statusCode')
    DBG "${case} http_code=${code}"
    if [[ "$code" == "200" ]]; then
        return 0
    else
        return 1
    fi
}

function cluster_startup {
    BCS_FUNCTION_BEGIN
    node_start_all $@
    # wait process to be stable
    sleep 1
}
function cluster_status {
    BCS_FUNCTION_BEGIN
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    typeset vstatus="${2:-}"
    LOG "check status for idlist[$idlist] for domain [${dm_name}]"
    exec_code_block -e ${dm_name} ${idlist} <<\EOF
    DBG "[${dm_name}] type is ${DM_TYPE}"
    if [[ ${DM_TYPE} == "chain_cluster" || ${DM_TYPE} == "mono" ]]; then
      typeset json=$(cat - <<EOF2
        {"dumy":"dumy"}
EOF2
)
      g_urlbase="http://${IP}:${REST_PORT}"
      my_gen_temp tmp_chk_st
      do_rest "${g_api_status}" "${json}" "${tmp_chk_st}"
      ret=$?
      LOG "ret of do_rest is ${ret} url=${g_urlbase} api=${g_api_status}"
      case ${ret} in
      ## If chain_node is closed, curl may return a status of 7 or 28
      7|28)  st="${g_st_shutdown}";;
      0)  check_http_status "status" "${tmp_chk_st}"
          ret2=$?
          if [[ ${ret2} -ne 0 ]]; then
              st="${g_st_error}-ret-${ret2}"
          else
              st=$(cat ${tmp_chk_st} | jq -r '.status')
          fi;;
      *)  st="${g_st_unknown}-ret-${ret}";;
      esac
      LOG "[${dm_name}] $id status is $st"
      [[ -n "${vstatus}" ]] && eval ${vstatus}=${st}
      rm -f ${tmp_chk_st}
    else
      typeset output=$(ssh ${RUSER}@$IP "[[ ! -d ${RDIR}/bin ]] && exit; cd ${RDIR}/bin; [[ -s pid ]] && kill -0 \$(cat pid) 2>/dev/null && echo ok")
      if [[ "${output}" == "ok" ]]; then
        st=${g_st_running}
      else
        st=${g_st_shutdown}
      fi
      LOG "[${dm_name}] $id status is $st [with ssh and ps]"
      [[ -n "${vstatus}" ]] && eval ${vstatus}=${st}
    fi
EOF
}
function cluster_shutdown {
    BCS_FUNCTION_BEGIN
    typeset grace_shutdown=${MYC_GRACE_SHUTDOWN:-0}
    typeset dm_name=${g_env}
    unset OPTIND
    while getopts e: ch; do
        case ${ch} in
        "e") dm_name=${OPTARG};;
        esac
    done
    shift $((OPTIND-1))
    local idlist="${1:-}"
    LOG "shutdown ${idlist:-ALL} [${dm_name}]"
    exec_code_block_async -e ${dm_name} ${idlist} <<\EOF
    typeset json=$(cat - <<EOF2
    {"dumy":"dumy"}
EOF2
)
    LOG "[${dm_name}] type is ${DM_TYPE}"
    if [[ ${grace_shutdown} -eq 1 && (${DM_TYPE} == "chain_cluster" || ${DM_TYPE} == "mono") ]]; then
      g_urlbase="http://${IP}:${REST_PORT}"
      my_gen_temp tmpfile
      retry=0; retrymax=60000;
      while true; do
        ((retry++))
        [[ $retry -ge $retrymax ]] && LOG "timeout when shutdown $id" && break
        cluster_status $id st
        LOG "$id status is ${st} [${retry}/${retrymax}]"
        ## stoped, return directly
        [[ "${st}" == "${g_st_shutdown}" ]] && return
        ## stopping or error occured, wait forever
        [[ "${st}" == "${g_st_stopping}" || "${st}" =~ (${g_st_unknown}|${g_st_error}) ]] && sleep 1 && continue
        LOG "$id do shutdown [${retry}/${retrymax}]"
        do_rest "${g_api_shutdown}" "${json}" "${tmpfile}"
        check_http_status "shutdown" "${tmpfile}"
        if [[ $? -ne 0 ]]; then
          LOG "shutdown() failed ${MYID}"
          LOGJSON ${tmpfile} "rest output"
          ret=1
        fi
        rm -f ${tmpfile}
        sleep 1
      done
    else
      LOG "kill process on [${id} ${IP}] dm_name=${dm_name}"
      ssh ${RUSER}@$IP "cd ${RDIR}/bin;
        [[ -s pid ]] && kill -9 \$(cat pid) 2>/dev/null;
        [[ -s pid ]] && { kill -0 \$(cat pid) 2>/dev/null || rm -f pid 2>/dev/null; };
        [[ -d ${RDIR}/data ]] && { cd ${RDIR}/data; find . -name LOCK | xargs -I {} /bin/rm -rf {}; };
        [[ -d ${RDIR}/data ]] && { cd ${RDIR}/data; find . -name owner_lock | while read f; do /bin/rm -rf \$f; touch \$f; done; };
        "
    fi
    ### make sure the process to exit
    #sleep 2
    return ${ret}
EOF
}
function node_ssh_init {
    BCS_FUNCTION_BEGIN
    export keyfile=${1:-"~/.ssh/id_rsa.pub"}
    exec_code_block <<\EOF
    ssh-copy-id -i "${keyfile}" ${RUSER}@$IP
EOF
}
function get_node_ip {
    BCS_FUNCTION_BEGIN
    typeset env=${1?"no env name"}
    typeset id=${2?"no node name"}
    typeset vname=${3?"no var name"}
    typeset IPVAL=
    get_node_attr ${env} $id "ippub" IPVAL || get_node_attr ${g_env} $id "ip" IPVAL
    [[ "${IPVAL}" == "null" ]] && get_node_attr ${env} $id "ip" IPVAL
    eval ${vname}=${IPVAL}
}

########################################################
function get_ret_from_json {
    BCS_FUNCTION_BEGIN
    typeset json="${1?"no json is specified"}"
    typeset vname="${2?"no varname is specified"}"
    typeset val=$(cat ${json} | jq -r '.ret')
    BCS_CHK_ACT_RC0 "can not read ret from json:${json} &&& cat ${json}"
    [[ -z "${val}" ]] && LOG "can not read ret from json: ${json}" && return 1
    eval ${vname}="${val}"
    return 0
}

function to_hex {
    BCS_FUNCTION_BEGIN
    echo "${1:-}" | xxd -p | tr -d '\n'
}
function cluster_get_node_list {
    BCS_FUNCTION_BEGIN
    typeset vname=${1?"no var name"}
    typeset idx=0
    for i in $(cat ${g_file} | jq -r '.env.'"${g_env}"'.nodes | to_entries | .[].key'); do
        DBG "${vname}[$idx]=$i"
        eval ${vname}[$idx]=$i
        ((idx++))
    done
    return 0
}
function myc_set_asan {
    BCS_FUNCTION_BEGIN
    #[[ "${1:-}" == "enable" ]]  && export ASAN_OPTIONS=halt_on_error=0:use_sigaltstack=0:alloc_dealloc_mismatch=0:detect_leaks=1:malloc_context_size=95
    ## abort_on_errror will create coredump even if asan is enabled
    [[ "${1:-}" == "enable" ]]  && export ASAN_OPTIONS=detect_leaks=false:leak_check_at_exit=false:disable_coredump=0:unmap_shadow_on_exit=1:abort_on_error=1
    [[ "${1:-}" == "disable" ]] && unset  ASAN_OPTIONS
}

function kill_process_tree_in_file {
  ##zzy
  #return
  typeset pidfile=$1
  [[ -n ${pidfile} && -f ${pidfile} ]]
  BCS_CHK_RC0 "pidfile does not exist or is null: ${pidfile}"
  LOG "kill all process tree in file ${pidfile} [$(cat ${pidfile})]"
  typeset pid=
  for pid in $(cat ${pidfile}); do
    ## kill process and it's child process
    ${MNGDIR}/mykilltree.sh ${pid} all
  done
}

function switch_to_2level_tree_mode {
  LOG "begin switch_to_2level_tree_fdmt_mode begin"
  typeset chain_name="chain_default"
  typeset conf_file="${g_meta_file}"
  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"
  typeset meta_keypath="/storage/meta_service/chain_meta/${chain_name}/statedb_list/current_state"

  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .msu_group_size=1 | .slice_type=0 | .db_type="FDMT" | .cluster_node.nodes[0].msu="0-0"
    | .cluster_node.nodes[0] as $p | del(.cluster_node.nodes) | .cluster_node.nodes[0]=$p'
  )
  LOG "2level_tree newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  # kvdb
  typeset conf_keypath_kvdb="/v2/${chain_name}/${g_domain_id}/storage/config_service/kvdb"
  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath_kvdb}" | tail -1 | jq '
      .block.db_path="'"../data"'" | .block.db_type="'"rocksdb"'" | .block.prefix="'""'" | .block.cluster_node.nodes[0].node_id="'"0"'"'
  )
  LOG "2level_tree newconf: ${conf_keypath_kvdb}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath_kvdb}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath_kvdb} -value=${newconf}"

  typeset conf_keypath_deployment="/v2/${chain_name}/${g_domain_id}/storage/config_service/deployment"
  typeset newconf_deployment=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath_deployment}" | tail -1 | jq '
    .platform="twolevel"'
  )
  LOG "2level_tree newconf: ${conf_keypath_deployment}  -->  ${newconf_deployment}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath_deployment}" -value="${newconf_deployment}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_keypath_deployment} -set -key=${conf_keypath_deployment} -value=${newconf_deployment}"

  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/erpc_option"
  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .erpc_io_size_auto_adjust=1'
  )
  LOG "newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  LOG "begin switch_to_2level_tree_fdmt_mode end"
}

function switch_to_2level_tree_gray_mode {
  LOG "begin switch_to_2level_tree_gray_mode begin"
  typeset chain_name="chain_default"
  typeset conf_file="${g_meta_file}"
  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"
  typeset meta_keypath="/storage/meta_service/chain_meta/${chain_name}/statedb_list/current_state"

  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .cluster_node.nodes[0].msu="0-255" | .db_type="FDMT" | .gray_mode="double_write_read"
    | .cluster_node.nodes[0] as $p | del(.cluster_node.nodes) | .cluster_node.nodes[0]=$p'
  )
  LOG "2level_tree newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  typeset conf_keypath_deployment="/v2/${chain_name}/${g_domain_id}/storage/config_service/deployment"
  typeset newconf_deployment=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath_deployment}" | tail -1 | jq '
    .platform="twolevel"'
  )
  LOG "2level_tree newconf: ${conf_keypath_deployment}  -->  ${newconf_deployment}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath_deployment}" -value="${newconf_deployment}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath_deployment} -value=${newconf_deployment}"

  typeset conf_keypath_kvdb="/v2/${chain_name}/${g_domain_id}/storage/config_service/kvdb"
  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath_kvdb}" | tail -1 | jq '
    .default.db_path="'"../data"'" | .default.db_type="'"rocksdb"'" | .default.prefix="'""'" | .default.cluster_node.nodes[0].node_id="'"0"'" |
    .block.db_path="'"../data"'" | .block.db_type="'"LETUS"'" | .block.prefix="'""'" | .block.cluster_node.nodes[0].node_id="'"0"'"'
  )
  LOG "2level_tree newconf: ${conf_keypath_kvdb}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath_kvdb}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath_kvdb} -value=${newconf}"

  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/erpc_option"
  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .erpc_io_size_auto_adjust=1'
  )
  LOG "newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  LOG "begin switch_to_2level_tree_gray_mode end"
}

function switch_to_2level_tree_letus_mode {
  LOG "begin switch_to_2level_tree_letus_mode begin"
  typeset chain_name="chain_default"
  typeset conf_file="${g_meta_file}"
  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"
  typeset meta_keypath="/storage/meta_service/chain_meta/${chain_name}/statedb_list/current_state"

  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .cluster_node.nodes[0].msu="0-255" | .db_type="LETUS"
    | .cluster_node.nodes[0] as $p | del(.cluster_node.nodes) | .cluster_node.nodes[0]=$p'
  )
  LOG "2level_tree newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  typeset conf_keypath_deployment="/v2/${chain_name}/${g_domain_id}/storage/config_service/deployment"
  typeset newconf_deployment=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath_deployment}" | tail -1 | jq '
    .platform="twolevel"'
  )
  LOG "2level_tree newconf: ${conf_keypath_deployment}  -->  ${newconf_deployment}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath_deployment}" -value="${newconf_deployment}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath_deployment} -value=${newconf_deployment}"

  typeset conf_keypath_kvdb="/v2/${chain_name}/${g_domain_id}/storage/config_service/kvdb"
  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath_kvdb}" | tail -1 | jq '
    .default.db_path="'"../data"'" | .default.db_type="'"rocksdb"'" | .default.prefix="'""'" | .default.cluster_node.nodes[0].node_id="'"0"'" |
    .block.db_path="'"../data"'" | .block.db_type="'"LETUS"'" | .block.prefix="'""'" | .block.cluster_node.nodes[0].node_id="'"0"'"'
  )
  LOG "2level_tree newconf: ${conf_keypath_kvdb}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath_kvdb}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath_kvdb} -value=${newconf}"

  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/erpc_option"
  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .erpc_io_size_auto_adjust=1'
  )
  LOG "newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  LOG "begin switch_to_2level_tree_letus_mode end"
}

function switch_to_2level_tree_letus_cluster_mode {
  LOG "begin switch_to_2level_tree_letus_cluster_mode begin"
  typeset chain_name="chain_default"
  typeset conf_file="${g_meta_file}"
  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"
  typeset meta_keypath="/storage/meta_service/chain_meta/${chain_name}/statedb_list/current_state"

  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .db_type="LETUS" |
    .cluster_node.nodes[0].msu="0-63" | .cluster_node.nodes[0].node_id="0" |
    .cluster_node.nodes[1].msu="64-127" | .cluster_node.nodes[1].node_id="1" |
    .cluster_node.nodes[2].msu="128-191" | .cluster_node.nodes[2].node_id="2" |
    .cluster_node.nodes[3].msu="192-255" | .cluster_node.nodes[3].node_id="3"'
  )
  LOG "2level_tree newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  typeset conf_keypath_deployment="/v2/${chain_name}/${g_domain_id}/storage/config_service/deployment"
  typeset newconf_deployment=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath_deployment}" | tail -1 | jq '
    .platform="twolevel"'
  )
  LOG "2level_tree newconf: ${conf_keypath_deployment}  -->  ${newconf_deployment}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath_deployment}" -value="${newconf_deployment}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath_deployment} -value=${newconf_deployment}"

  typeset conf_keypath_kvdb="/v2/${chain_name}/${g_domain_id}/storage/config_service/kvdb"
  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath_kvdb}" | tail -1 | jq '
    .default.db_path="'"../data"'" | .default.db_type="'"rocksdb"'" | .default.prefix="'""'" | .default.cluster_node.nodes[0].node_id="'"0"'" |
    .block.db_path="'"../data"'" | .block.db_type="'"LETUS"'" | .block.prefix="'""'" | .block.cluster_node.nodes[0].node_id="'"0"'"'
  )
  LOG "2level_tree newconf: ${conf_keypath_kvdb}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath_kvdb}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath_kvdb} -value=${newconf}"

  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/erpc_option"
  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .erpc_io_size_auto_adjust=1'
  )
  LOG "newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  LOG "begin switch_to_2level_tree_letus_cluster_mode end"
}

function set_fdmt_db_meta {
    typeset dbid=$1
    typeset statedb_prefix=$2
    typeset statedb_path=$3
    typeset statedb_name=$4
    typeset conf_file="${g_meta_file}"
    LOG "set_fdmt_db_meta dbid:$dbid statedb_prefix:$statedb_prefix statedb_path:$statedb_path statedb_name:$statedb_name"
    typeset chain_name="chain_default"
    typeset genssis=$(cat - <<EOF
{"cluster_node" : {"nodes" : [{"node_id" : "0", "msu": "0-0"}]},"db_id" : ${dbid},"db_name" : "${statedb_name}","db_path" : ${statedb_path},"db_type" : "FDMT","prefix" : "${statedb_prefix}","slice_type" : 0, "hash_mode" : 1, "crypto_type" : "sha256"}
EOF
    )
    LOG "set_fdmt_db_meta genssisvalue:$genssis"
    meta_tool -conf ${conf_file} -set -key="/v2/${chain_name}/${g_domain_id}/storage/meta_service/statedb_list/${dbid}" -value="${genssis}"
}

function fdmt_db_subnets_loop_dir {
    typeset absolute_path=$1
    typeset config_path=$2
    #set public state db meta
    typeset state_public_num=5
    typeset state_prefix=public
    set_fdmt_db_meta $state_public_num $state_prefix $config_path "state"
    #set subnets state db meta
	if [[ -d $absolute_path/subnets ]]; then
    for chainid in `ls $absolute_path/subnets/`
    do
        if [[ $chainid =~ ^[0-9]*$ ]] && [[ -d $absolute_path/subnets/$chainid ]];
        then
            # typeset num=0
            # typeset CMD="((num=16#$file))"
            # eval $CMD
            # num is dbid
            typeset block_db_id=$chainid$g_storage_block_db_id
            typeset extra_db_id=$chainid$g_storage_extra_db_id
            typeset related_db_id=$chainid$g_storage_related_db_id
            typeset addressable_db_id=$chainid$g_storage_addressable_db_id
            typeset state_db_id=$chainid$g_storage_state_db_id
            typeset block_db_num=0
            typeset extra_db_num=0
            typeset related_db_num=0
            typeset addressable_db_num=0
            typeset state_db_num=0
            typeset CMD="((block_db_num=16#$block_db_id))"
            eval $CMD
            CMD="((extra_db_num=16#$extra_db_id))"
            eval $CMD
            CMD="((related_db_num=16#$related_db_id))"
            eval $CMD
            CMD="((addressable_db_num=16#$addressable_db_id))"
            eval $CMD
            CMD="((state_db_num=16#$state_db_id))"
            eval $CMD
            # set_fdmt_db_meta $block_db_num subnets/$chainid $config_path "block"
            # set_fdmt_db_meta $extra_db_num subnets/$chainid $config_path "extra"
            # set_fdmt_db_meta $related_db_num subnets/$chainid $config_path "related"
            # set_fdmt_db_meta $addressable_db_num subnets/$chainid $config_path "addressable"
            set_fdmt_db_meta $state_db_num subnets/$chainid $config_path "state"
        fi
    done
	fi
}

function switch_from_old_mychain_conf_to_meta {
    LOG "switch_from_old_mychain_conf_to_meta begin"
    typeset confdir=$1
    typeset datadir=$2
    [[ -e "$confdir" ]]
    BCS_CHK_RC0 "faild to find config dir: $confdir"
    # global config
    typeset db_path="$(cat ${confdir} | jq -c ".storage_plugin.db_path")"
    typeset db_cache_max_size="$(cat ${confdir} | jq -c ".storage_plugin.db_cache_max_size")"
    typeset chain_cache_block_cache_size="$(cat ${confdir} | jq -c ".storage_plugin.chain_cache_block_cache_size")"
    typeset chain_cache_tx_cache_size="$(cat ${confdir} | jq -c ".storage_plugin.chain_cache_tx_cache_size")"
    typeset db_max_open_files="$(cat ${confdir} | jq -c ".storage_plugin.db_max_open_files")"
    typeset db_write_buffer_size="$(cat ${confdir} | jq -c ".storage_plugin.db_write_buffer_size")"
    typeset db_max_write_buffer_number="$(cat ${confdir} | jq -c ".storage_plugin.db_max_write_buffer_number")"
    typeset world_state_fdmt_commit_thread_count="$(cat ${confdir} | jq -c ".storage_plugin.world_state_fdmt_commit_thread_count")"
    typeset world_state_fdmt_cached_depth="$(cat ${confdir} | jq -c ".storage_plugin.world_state_fdmt_cached_depth")"
    typeset account_fdmt_cached_depth="$(cat ${confdir} | jq -c ".storage_plugin.account_fdmt_cached_depth")"
    typeset private_world_state_fdmt_cached_depth="$(cat ${confdir} | jq -c ".storage_plugin.private_world_state_fdmt_cached_depth")"
    typeset private_account_fdmt_cached_depth="$(cat ${confdir} | jq -c ".storage_plugin.private_account_fdmt_cached_depth")"
    typeset currentdb_use_bloom_filter="$(cat ${confdir} | jq -c ".storage_plugin.currentdb_use_bloom_filter")"
    typeset if_warm_up="$(cat ${confdir} | jq -c ".storage_plugin.if_warm_up")"
    typeset warm_up_thread_count="$(cat ${confdir} | jq -c ".storage_plugin.warm_up_thread_count")"
    typeset ws_commit_thread_num="$(cat ${confdir} | jq -c ".storage_plugin.ws_commit_thread_num")"
    typeset ws_async_clear_enable="$(cat ${confdir} | jq -c ".storage_plugin.ws_async_clear_enable")"
    # current db option
    typeset CURRENT_max_background_jobs="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.currentdb_option.max_background_jobs")"
    typeset CURRENT_compaction_readahead_size="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.currentdb_option.compaction_readahead_size")"
    typeset CURRENT_level0_slowdown_writes_trigger="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.currentdb_option.level0_slowdown_writes_trigger")"
    typeset CURRENT_level0_stop_writes_trigger="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.currentdb_option.level0_stop_writes_trigger")"
    typeset CURRENT_max_bytes_for_level_base="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.currentdb_option.max_bytes_for_level_base")"
    typeset CURRENT_min_write_buffer_number_to_merge="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.currentdb_option.min_write_buffer_number_to_merge")"
    typeset CURRENT_max_subcompactions="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.currentdb_option.max_subcompactions")"
    typeset CURRENT_enable_pipeline_write="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.currentdb_option.enable_pipeline_write")"
    typeset CURRENT_optimize_filters_for_hits="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.currentdb_option.optimize_filters_for_hits")"
    typeset CURRENT_option="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.currentdb_option")"
    # history db option
    typeset HISTORY_max_background_jobs="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.historydb_option.max_background_jobs")"
    typeset HISTORY_compaction_readahead_size="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.historydb_option.compaction_readahead_size")"
    typeset HISTORY_level0_slowdown_writes_trigger="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.historydb_option.level0_slowdown_writes_trigger")"
    typeset HISTORY_level0_stop_writes_trigger="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.historydb_option.level0_stop_writes_trigger")"
    typeset HISTORY_max_bytes_for_level_base="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.historydb_option.max_bytes_for_level_base")"
    typeset HISTORY_min_write_buffer_number_to_merge="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.historydb_option.min_write_buffer_number_to_merge")"
    typeset HISTORY_max_subcompactions="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.historydb_option.max_subcompactions")"
    typeset HISTORY_enable_pipeline_write="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.historydb_option.enable_pipeline_write")"
    typeset HISTORY_optimize_filters_for_hits="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.historydb_option.optimize_filters_for_hits")"
    typeset HISTORY_option="$(cat ${confdir} | jq -c ".storage_plugin.public_db_option.historydb_option")"
  	

    # switch config
    typeset chain_name="chain_default"
    typeset conf_file="${g_meta_file}"

    # fdmt config
    typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"
    typeset meta_keypath="/storage/meta_service/chain_meta/${chain_name}/statedb_list/current_state"

    typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
      .msu_group_size=1 | .slice_type=0 | .cluster_node.nodes[0].msu="0-0" | .db_type="FDMT"
      | .cluster_node.nodes[0] as $p | del(.cluster_node.nodes) | .cluster_node.nodes[0]=$p'
    )
    LOG "2level_tree newconf: ${conf_keypath}  -->  ${newconf}"
    meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
    BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

    # kvdb
    typeset conf_keypath_kvdb="/v2/${chain_name}/${g_domain_id}/storage/config_service/kvdb"
    typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath_kvdb}" | tail -1 | jq '
        .block.db_path="'"../data"'" | .block.db_type="'"rocksdb"'" | .block.prefix="'""'" | .block.cluster_node.nodes[0].node_id="'"0"'"'
    )
    LOG "2level_tree newconf: ${conf_keypath_kvdb}  -->  ${newconf}"
    meta_tool -conf ${conf_file} -set -key="${conf_keypath_kvdb}" -value="${newconf}"
    BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath_kvdb} -value=${newconf}"

	# twolevel
	typeset conf_keypath_deployment="/v2/${chain_name}/${g_domain_id}/storage/config_service/deployment"
	typeset newconf_deployment=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath_deployment}" | tail -1 | jq '
  	  .platform="twolevel"'
  	)
  	LOG "2level_tree newconf: ${conf_keypath_deployment}  -->  ${newconf_deployment}"
  	meta_tool -conf ${conf_file} -set -key="${conf_keypath_deployment}" -value="${newconf_deployment}"
  	BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath_deployment} -value=${newconf_deployment}"
    # kvdb
    typeset kvdb_new_conf=$(meta_tool -conf ${conf_file} -get -key="/v2/${chain_name}/${g_domain_id}/storage/config_service/kvdb" | tail -1 | jq '
        .max_open_files='"$db_max_open_files"' | .write_buffer_size='"$db_write_buffer_size"' | .max_write_buffer_number='"$db_max_write_buffer_number"''
    )
    [[ -n $kvdb_new_conf ]];
    BCS_CHK_RC0 "kvdb_new_conf faild to get key: /v2/${chain_name}/${g_domain_id}/storage/config_service/kvdb"
    meta_tool -conf ${conf_file} -set -key="/v2/${chain_name}/${g_domain_id}/storage/config_service/kvdb" -value="${kvdb_new_conf}"
    BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=/v2/${chain_name}/${g_domain_id}/storage/config_service/kvdb -value=${kvdb_new_conf}"
    
    # statedb 
    typeset state_new_conf=$(meta_tool -conf ${conf_file} -get -key="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb" | tail -1 | jq '
        .account_fdmt_cached_depth='"$account_fdmt_cached_depth"''
    )
    [[ -n $state_new_conf ]];
    BCS_CHK_RC0 "state_new_conf faild to get key: /v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"
    meta_tool -conf ${conf_file} -set -key="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb" -value="${state_new_conf}"
    BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb -value=${state_new_conf}"
 
    # state current option
    typeset current_option_new_conf=$(meta_tool -conf ${conf_file} -get -key="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb" | tail -1 | jq '
        .currentdb_option='"$CURRENT_option"''
    )
    [[ -n $current_option_new_conf ]];
    BCS_CHK_RC0 "current_option_new_conf faild to get key: /v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"
    meta_tool -conf ${conf_file} -set -key="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb" -value="${current_option_new_conf}"
    BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb -value=${current_option_new_conf}"
 
    # history current option
    typeset history_option_new_conf=$(meta_tool -conf ${conf_file} -get -key="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb" | tail -1 | jq '
        .historydb_option='"$HISTORY_option"''
    )
    [[ -n $history_option_new_conf ]];
    BCS_CHK_RC0 "history_option_new_conf faild to get key: /v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"
    meta_tool -conf ${conf_file} -set -key="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb" -value="${history_option_new_conf}"
    BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb -value=${history_option_new_conf}"

    fdmt_db_subnets_loop_dir $datadir $db_path

    LOG "switch_from_old_mychain_conf_to_meta end"
}


function switch_to_2level_tree_gray_cluster_mode {
  LOG "begin switch_to_2level_tree_gray_cluster_mode begin"
  typeset chain_name="chain_default"
  typeset conf_file="${g_meta_file}"
  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"
  typeset meta_keypath="/storage/meta_service/chain_meta/${chain_name}/statedb_list/current_state"

  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .db_type="LETUS" | .gray_mode="double_write_read" |
    .cluster_node.nodes[0].msu="0-63" | .cluster_node.nodes[0].node_id="0" |
    .cluster_node.nodes[1].msu="64-127" | .cluster_node.nodes[1].node_id="1" |
    .cluster_node.nodes[2].msu="128-191" | .cluster_node.nodes[2].node_id="2" |
    .cluster_node.nodes[3].msu="192-255" | .cluster_node.nodes[3].node_id="3"'
  )
  LOG "2level_tree newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  typeset conf_keypath_deployment="/v2/${chain_name}/${g_domain_id}/storage/config_service/deployment"
  typeset newconf_deployment=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath_deployment}" | tail -1 | jq '
    .platform="twolevel"'
  )
  LOG "2level_tree newconf: ${conf_keypath_deployment}  -->  ${newconf_deployment}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath_deployment}" -value="${newconf_deployment}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath_deployment} -value=${newconf_deployment}"

  typeset conf_keypath_kvdb="/v2/${chain_name}/${g_domain_id}/storage/config_service/kvdb"
  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath_kvdb}" | tail -1 | jq '
    .default.db_path="'"../data"'" | .default.db_type="'"rocksdb"'" | .default.prefix="'""'" | .default.cluster_node.nodes[0].node_id="'"0"'" |
    .block.db_path="'"../data"'" | .block.db_type="'"LETUS"'" | .block.prefix="'""'" | .block.cluster_node.nodes[0].node_id="'"0"'"'
  )
  LOG "2level_tree newconf: ${conf_keypath_kvdb}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath_kvdb}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath_kvdb} -value=${newconf}"

  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/erpc_option"
  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .erpc_io_size_auto_adjust=1'
  )
  LOG "newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  LOG "begin switch_to_2level_tree_gray_cluster_mode end"
}

function switch_to_fdmt_gray_mode {
  LOG "begin switch_to_fdmt_gray_mode begin"
  typeset chain_name="chain_default"
  typeset conf_file="${g_meta_file}"
  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"

  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .db_type="FDMT" | .gray_mode="double_write_read"'
  )
  LOG "newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  LOG "begin switch_to_fdmt_gray_mode end"
}

function switch_to_letus_mode {
  LOG "begin switch_to_letus_mode begin"
  typeset chain_name="chain_default"
  typeset conf_file="${g_meta_file}"
  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"

  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .db_type="LETUS" | .gray_mode="off"'
  )
  LOG "letus newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  LOG "begin switch_to_letus_mode end"
}

function switch_to_twolevel_letus_mode {
  LOG "begin switch_to_twolevel_letus_mode begin"
  typeset chain_name="chain_default"
  typeset conf_file="${g_meta_file}"
  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"

  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .db_type="LETUS" | .gray_mode="off"'
  )
  LOG "newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/deployment"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value='{"platform": "twolevel"}'
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/erpc_option"
  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .erpc_io_size_auto_adjust=1'
  )
  LOG "newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  LOG "begin switch_to_twolevel_letus_mode end"
}

function switch_to_twolevel_fdmt_mode {
  LOG "begin switch_to_twolevel_fdmt_mode begin"
  typeset chain_name="chain_default"
  typeset conf_file="${g_meta_file}"
  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb"

  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .db_type="FDMT" | .gray_mode="off"'
  )
  LOG "newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/deployment"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value='{"platform": "twolevel"}'
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/erpc_option"
  typeset newconf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1 | jq '
    .erpc_io_size_auto_adjust=1'
  )
  LOG "newconf: ${conf_keypath}  -->  ${newconf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${newconf}"
  BCS_CHK_RC0 "faild to run command: meta_tool -conf ${conf_file} -set -key=${conf_keypath} -value=${newconf}"

  LOG "begin switch_to_twolevel_fdmt_mode end"
}
sync_file() {
    local user=$1
    local ip=$2
    local source=${3%/}
    local target=${4%/}
    local target_parent=${target%/*}
    echo "SYNC: $source -> $target"
    if [[ $ip == "127.0.0.1" ]]; then
        if [[ $source == $target ]]; then
            echo "WARNING: target same with source, sync avoided"
        else
            scp $source $user@$ip:$target_parent
            BCS_CHK_RC0 "faild to rsync $source $user@$ip:$target_parent"
        fi
    else
        rsync -avzL -e "ssh" $source $user@$ip:$target_parent
        BCS_CHK_RC0 "faild to rsync $source $user@$ip:$target_parent"
    fi
}

function switch_nodes_config {
  typeset mode=${1?"no json is specified"}
  typeset chain_name="chain_default"
  typeset conf_file="${g_meta_file}"
  typeset conf_keypath="/v2/${chain_name}/${g_domain_id}/storage/config_service/public_conf/statedb/"

  typeset old_conf=$(meta_tool -conf ${conf_file} -get -key="${conf_keypath}" | tail -1)
  LOG "old_conf=${old_conf}"  
  # typeset mode=$((RANDOM%10))  # random selection
  LOG "mode=$mode"
  case $mode in
    0)
    new_conf=$(echo ${old_conf}| jq '
    .cluster_node.nodes[0].msu="0-127" | 
    .cluster_node.nodes[1].msu="128-255" | 
    delpaths([["cluster_node","nodes", 3]]) | 
    delpaths([["cluster_node","nodes", 2]])
'
    )
    ;;
    1)
    new_conf=$(echo ${old_conf}| jq '
    .cluster_node.nodes[0].msu="0-127" | 
    .cluster_node.nodes[2].msu="128-255" | 
    delpaths([["cluster_node","nodes", 3]]) | 
    delpaths([["cluster_node","nodes", 1]])
'
    )
    ;;
    2)
    new_conf=$(echo ${old_conf}| jq '
    .cluster_node.nodes[0].msu="0-127" | 
    .cluster_node.nodes[3].msu="128-255" | 
    delpaths([["cluster_node","nodes", 2]]) | 
    delpaths([["cluster_node","nodes", 1]])
'
    )
    ;;
    3)
    new_conf=$(echo ${old_conf}| jq '
    .cluster_node.nodes[1].msu="0-127" | 
    .cluster_node.nodes[2].msu="128-255" | 
    delpaths([["cluster_node","nodes", 3]]) | 
    delpaths([["cluster_node","nodes", 0]])
'
    )
    ;;
    4)
    new_conf=$(echo ${old_conf}| jq '
    .cluster_node.nodes[1].msu="0-127" | 
    .cluster_node.nodes[3].msu="128-255" | 
    delpaths([["cluster_node","nodes", 2]]) | 
    delpaths([["cluster_node","nodes", 0]])
'
    )
    ;;
    5)
    new_conf=$(echo ${old_conf}| jq '
    .cluster_node.nodes[2].msu="0-127" | 
    .cluster_node.nodes[3].msu="128-255" | 
    delpaths([["cluster_node","nodes", 1]]) | 
    delpaths([["cluster_node","nodes", 0]])
'
    )
    ;;
    6)
    new_conf=$(echo ${old_conf}| jq '
    .cluster_node.nodes[0].msu="0-63" | 
    .cluster_node.nodes[1].msu="64-127" | 
    .cluster_node.nodes[2].msu="128-255" | 
    delpaths([["cluster_node","nodes", 3]])
'
    )
    ;;
    7)
    new_conf=$(echo ${old_conf}| jq '
    .cluster_node.nodes[0].msu="0-63" | 
    .cluster_node.nodes[1].msu="64-127" | 
    .cluster_node.nodes[3].msu="128-255" | 
    delpaths([["cluster_node","nodes", 2]])
'
    )
    ;;
    8)
    new_conf=$(echo ${old_conf}| jq '
    .cluster_node.nodes[0].msu="0-63" | 
    .cluster_node.nodes[2].msu="64-127" | 
    .cluster_node.nodes[3].msu="128-255" | 
    delpaths([["cluster_node","nodes", 1]])
'
    )
    ;;
    9)
    new_conf=$(echo ${old_conf}| jq '
    .cluster_node.nodes[1].msu="0-63" | 
    .cluster_node.nodes[2].msu="64-127" | 
    .cluster_node.nodes[3].msu="128-255" | 
    delpaths([["cluster_node","nodes", 0]])
'
    )
    ;;
    *)  echo 'not support'
    ;;
  esac
  LOG "new_conf=${new_conf}"
  meta_tool -conf ${conf_file} -set -key="${conf_keypath}" -value="${new_conf}"
}

