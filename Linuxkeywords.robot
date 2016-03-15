*** Settings ***
Library           SSHLibrary
Resource          PublicVariable.robot
Library           String
Library           Collections
Library           ArchiveLibrary
Library           DjangoLibrary

*** Keywords ***
linux主机登录
    [Arguments]    ${hostIP}
    ${index1}    Open Connection    ${hostIP}
    Enable Ssh Logging    E:\\bsa.log
    login    ${sshusername}    ${sshpassword}
    Set Client Configuration    prompt=#

进入root目录
    write    cd /root
    sleep    2

判断正确的安装包是否存在
    write    cd /root
    sleep    2
    SSHLibrary.File Should Exist    /root/${InstallPackage}

对安装包进行解压
    write    tar -zxvf ${InstallPackage} -C /home/
    ${tartemp}    Read    loglevel=INFO    delay=30s
    log    ${tartemp}

进入配置脚本所在目录
    write    cd /home/${installer}/
    sleep    1
    write    cd prepareTools/
    sleep    1

修改 hostlist文件
    [Arguments]    ${host1IP}    ${host1}
    write    echo ${host1IP} \ ${host1} \ >> hostlist
    write    cat hostlist
    ${hostlist}    Read    loglevel=INFO    delay=10s
    log    ${hostlist}
    Should Contain    ${hostlist}    ${host1IP}
    Should Contain    ${hostlist}    ${host1}

修改hosts文件
    [Arguments]    ${host1IP}    ${host1}
    write    echo ${host1IP} \ ${host1} \ >> hosts
    sleep    1
    write    cat hosts
    ${hosts}    Read    loglevel=INFO    delay=10s
    Should Contain    ${hosts}    ${host1IP}
    Should Contain    ${hosts}    ${host1}

执行配置脚本
    write    cd /home/${installer}/prepareTools
    sleep    1
    SSHLibrary.File Should Exist    /home/${installer}/prepareTools/prepareEnv.sh
    write    ./prepareEnv.sh
    ${preparetemp}    Read    loglevel=INFO    delay=5s
    Should Contain    ${preparetemp}    Enter root password for machines which need to be prepared
    Write Bare    ${sshpassword}\n
    ${temp1}    Read    loglevel=INFO    delay=5s
    Should Contain    ${temp1}    Enter the name of which user to be created(Press enter to use bsaworker as default):
    Write Bare    bsaworker\n
    ${temp2}    Read    loglevel=INFO    delay=5s
    Write Bare    ${sshpassword}\n
    ${temp3}    Read    loglevel=INFO    delay=5s
    Write Bare    ${sshpassword}\n
    sleep    1
    ${back}    ${status}    Run Keyword And Ignore Error    Write    Y
    log    ${back}
    log    ${status}
    ${temp4}    Read    loglevel=INFO    delay=50s
    Should Contain    ${temp4}    Script finished

进入解压后的安装包目录，执行安装脚本
    write    cd /home/${installer}
    sleep    1
    SSHLibrary.File Should Exist    /home/${installer}/setup.sh
    write    ./uninstall.sh
    ${temp}    Read    loglevel=INFO    delay=10s
    Should Contain    ${temp}    BSA uninstallation complete!
    sleep    2
    write    ./setup.sh
    ${temp1}    Read    loglevel=INFO    delay=15s
    ${status}    Run Keyword And Return Status    Should Contain    ${temp1}    Enter your choice for public ip:[1-2]
    Run Keyword If    '${status}'==' True'    Write    ${ipchoice}
    Run Keyword If    '${status}'=='False'    log    ${temp1}
    sleep    10
    Write    ${ipchoice}
    ${temp2}    Read    loglevel=INFO    delay=10s
    log    ${temp2}
    ${temp3}    Read    loglevel=INFO    delay=80s
    Should Contain    ${temp3}    BSA startup finished

判断原有安装目录是否存在
    ${back}    ${status}    Run Keyword And Ignore Error    SSHLibrary.Directory Should Exist    /home/${installer}
    Run Keyword If    '${back}' =='PASS'    运行卸载脚本
    Run Keyword If    '${back}' =='PASS'    删除安装目录

运行卸载脚本
    write    cd /home
    ${back}    ${status}    Run Keyword And Ignore Error    SSHLibrary.Directory Should Exist    /home/${installer}
    Run Keyword If    '${back}' =='PASS'    write    cd /home/${installer}/
    Run Keyword If    '${back}' =='PASS'    write    ./uninstall.sh
    ${temp}    Read    loglevel=INFO    delay=20s
    Should Contain    ${temp}    BSA uninstallation complete!
    write    cd /home
    sleep    5

删除安装目录
    Write Bare    cd /home\n
    sleep    1
    Write    rm -rf /home/${installer}/\n
    ${temp}    Read    loglevel=INFO    delay=10s
    SSHLibrary.Directory Should Not Exist    /home/${installer}
    sleep    5

判断解压是否成功
    #判断解压是否成功
    ${back}    ${status}    Run Keyword And Ignore Error    SSHLibrary.Directory Should Exist    /home/${installer}
    Run Keyword If    '${back}' =='PASS'    No Operation
    Run Keyword If    '${back}' =='FAIL'    对安装包进行解压
    SSHLibrary.Directory Should Exist    /home/${installer}

CollectComponentLog
    [Arguments]    ${hostname}    # 主机别名
    [Documentation]    获取对应主机各组件下的日志列表
    ...    参数：${hostname}
    ...    返回值：${Componentloglist}
    ...    使用举例：
    Switch Connection    ${hostname}
    ${Componentloglist}    Create List
    #默认安装路径    #自定义路径需要根据安装部署填写的路径来输入
    #Hadoop    /home/bsaworker/hes/hadoop/hadoop-2.6.0/logs
    #zookeeper    /home/bsaworker/zookeeper/zookeeper-3.4.6/logs
    #kafka    /home/bsaworker/kafka/logs
    #spark    /home/bsaworker/spark/logs
    #elasticsearch    /home/bsaworker/elasticsearch/logs    #此处为默认路径
    ${Hadooplog}    SSHLibrary.List Files In Directory    /home/bsaworker/hes/hadoop/hadoop-2.6.0/logs
    Comment    Log List    ${Hadooplog}
    Append To List    ${Componentloglist}    ${Hadooplog}
    ${zookeeperlog}    SSHLibrary.List Files In Directory    /home/bsaworker/zookeeper/zookeeper-3.4.6/logs
    Comment    Log List    ${zookeeperlog}
    Append To List    ${Componentloglist}    ${zookeeperlog}
    ${kafkalog}    SSHLibrary.List Files In Directory    /home/bsaworker/kafka/logs
    Comment    Log List    ${kafkalog}
    Append To List    ${Componentloglist}    ${kafkalog}
    ${sparklog}    SSHLibrary.List Files In Directory    /home/bsaworker/spark/logs
    Comment    Log List    ${sparklog}
    Append To List    ${Componentloglist}
    ${elasticsearchlog}    SSHLibrary.List Files In Directory    /home/bsaworker/elasticsearch/logs    #此处为自定义路径    #/home/sdg/elasticsearch/logs,/home/sdh/elasticsearch/logs
    Comment    Log List    ${elasticsearchlog}
    Append To List    ${Componentloglist}    ${elasticsearchlog}
    [Return]    ${Componentloglist}

获取安装包名称
    ${installername}    Set Variable    ${InstallPackage}
    ${install}    ${temp}    Split String From Right    ${installername}    .    1
    ${installer}    ${temp}    Split String From Right    ${install}    .    1
    log    ${installer}
    Set Global Variable    ${installer}

配置hostlist和hosts
    [Arguments]    ${hostIP}    ${hostname}
    @{ip}    Split String    ${hostIP}    ,
    @{name}    Split String    ${hostname}    ,
    ${n}    Evaluate    len(@{ip})
    : FOR    ${i}    IN RANGE    0    ${n}
    \    write    echo @{ip}[${i}] \ @{name}[${i}] \ >> hostlist
    \    write    echo @{ip}[${i}] \ @{name}[${i}] \ >> hosts

find index
    [Arguments]    ${element}    ${items}
    ${index}    Set Variable    ${EMPTY}
    ${n}    Evaluate    len(${items})
    : FOR    ${i}    IN RANGE    0    ${n}
    \    ${tem}    Get From List    ${items}    ${i}
    \    ${status}    ${back}    Run Keyword And Ignore Error    Should Be Equal As Strings    ${element}    ${tem}
    \    Run Keyword If    '${status}'=='PASS'    LOG    ${tem}
    \    ${index}    Set Variable    ${i}
    \    Run Keyword If    '${status}'=='PASS'    Exit For Loop
    [Return]    ${index}
