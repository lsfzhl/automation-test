*** Settings ***
Library           Selenium2Library
Library           OperatingSystem
Library           AutoItLibrary
Resource          PublicVariable.robot
Library           string
Library           String
Library           Collections

*** Keywords ***
第一次导入证书
    [Arguments]    ${hostIP}
    Open Browser    https://${hostIP}    firefox
    Wait Until Page Contains Element    //div[@role="alert"]    10
    Choose File    //*[@id="licenseName"]    ${licensepath}
    #点击导入证书
    Click Button    //button[@class="btn btn-primary btn-sm"]
    sleep    10
    #判断证书是否导入成功
    Close Browser

登录
    [Arguments]    ${hostIP}
    Open Browser    https://${hostIP}
    Selenium2Library.Set Selenium Speed    0.3
    Wait Until Page Contains Element    //*[@id="inputEmail"]    10
    Input Text    //input[@id="inputEmail"]    ${USERNAME}
    Input Password    //input[@id="inputPassword"]    ${PASSWORD}
    Click Button    //button[@class="btn circle-btn"]
    sleep    2
    Wait Until Element Is Visible    //*[@id="navbar"]    10

日志告警菜单
    Wait Until Page Contains Element    //a[@href="/logAlarm/index"]    10
    Click Link    //ol/li[4]/a
    sleep    3

搜索与报表菜单
    Wait Until Page Contains Element    //a[@href="/search/index"]    30
    Click Link    //ol/li[2]/a    #搜索与报表页面
    sleep    5
    Wait Until Page Contains Element    //a[@href="#/discover"]    30    #查看页面是否有“搜索”

数据采集配置
    Wait Until Page Contains Element    //a[@href="/sysmanage/index"]    10
    Click Link    //ol/li[2]/a
    sleep    3

应用管理菜单
    Wait Until Page Contains Element    //a[@href= href="/appManager/index"]    10
    Click Link    //ol/li[3]/a
    sleep    3

告警列表页面
    Unselect Frame
    Wait Until Page Contains Element    //a[@href="/logAlarm/alertList"]    10
    Click Link    //nav/ul/li[1]/a
    sleep    3

已忽略告警列表页面
    Unselect Frame
    Wait Until Page Contains Element    //a[@href="/logAlarm/ignoreList"]    10
    Click Link    //nav/ul/li[2]/a
    sleep    3

告警规则列表页面
    Unselect Frame
    Wait Until Page Contains Element    //a[@href="/logAlarm/ruleList"]    10
    Click Link    //nav/ul/li[3]/a
    sleep    3

新建单条告警规则
    [Arguments]    ${rulername}    @{cus_rule}
    Unselect Frame
    Select Frame    main_frame
    Wait Until Page Contains Element    //button[@ng-click="newRule()"]    10
    Click Button    //button[@ng-click="newRule()"]
    Unselect Frame
    Select Frame    main_frame
    Wait Until Page Contains Element    //p[@class="sub_title"]    10
    Input Text    //div[@id="rulename"]/input    ${rulername}
    ${N}    Set Variable    1
    ${M}    Set Variable    0
    ${len}    Get Length    ${cus_rule}
    : FOR    ${i}    IN RANGE    0    ${len}    ${NUM}
    \    ${logtypevalue}    Evaluate    ${cus_rule}[${M}]
    \    ${iptypevalue}    Evaluate    ${cus_rule}[${M}+1]
    \    ${ipcontent}    Evaluate    ${cus_rule}[${M}+2]
    \    ${logcontent1}    Evaluate    ${cus_rule}[${M}+3]
    \    ${timevalue}    Evaluate    ${cus_rule}[${M}+4]
    \    ${maxlevel}    Evaluate    ${cus_rule}[${M}+5]
    \    ${midlevel}    Evaluate    ${cus_rule}[${M}+6]
    \    ${minlevel}    Evaluate    ${cus_rule}[${M}+7]
    \    ${alarmtime}    Evaluate    ${cus_rule}[${M}+8]
    \    ${agingtime}    Evaluate    ${cus_rule}[${M}+9]
    \    #日志类型
    \    Select From List By Value    //div[@id="logType"]/select    ${logtypevalue}
    \    #告警资产
    \    Select From List By Value    //div[@id="asset"]/select    ${iptypevalue}
    \    Input Text    //div[@id="asset"]/textarea    ${ipcontent}
    \    #内容匹配-按整条日志
    \    Select Radio Button    myRadio    0
    \    Input Text    //div[7]/div/textarea    ${logcontent1}
    \    #阈值设置（7种不同类型）此处仅做计数值处理
    \    Select Radio Button    stypeRadio    1    #计数值
    \    Input Text    //div[@id="times"]/div[1]/input    ${timevalue}
    \    Select From List By Value    //div[@id="times"]/div[2]/select    0    #秒
    \    #告警级别
    \    Input Text    //div[@id="maxlevel"]/div[2]/input    ${maxlevel}
    \    Input Text    //div[@id="midlevel"]/div[2]/input    ${midlevel}
    \    Input Text    //div[@id="minlevel"]/div[2]/input    ${minlevel}
    \    #生效时间段
    \    Select Radio Button    timeRadio    0    #一直有效
    \    #告警最大时长
    \    Input Text    //div[@id="alarmtime"]/div[1]/input    ${alarmtime}
    \    #告警老化时间
    \    Input Text    //div[@id="ageingtime"]/div[1]/input    ${agingtime}
    \    ${N}    Evaluate    ${N}+1
    \    ${M}    Evaluate    ${M}+10
    #发送告警-邮件
    Unselect Checkbox    //input[@ng-model="emailisnotice"]    #不发邮件
    #发送告警-syslog
    Unselect Checkbox    //input[@ng-model="sysisnotice"]    #不发syslog
    #点击完成
    Click Button    //button[@ng-click="submitRule()"]
    ${rst}    ${back}    Run Keyword And Ignore Error    Confirm Action
    Run Keyword If    '${rst}'=='PASS'    log    创建规则失败
    Run Keyword If    '${rst}'=='FAIL'    log    创建规则成功
    sleep    3

按字段内容匹配
    #内容匹配-按字段
    Select Radio Button    myRadio    1
    Select From List By Value    //div[@id="content"]/div[1]/select    ${logcontentkeyvalue}
    Input Text    //div[@id="content"]/div[2]/input    ${logcontent1}    #此处可添加字段待完善

新建多条告警规则
    ${zs}    Evaluate    ${MAX_PT}*${NUM}
    ${COUNT}    Set Variable    1
    : FOR    ${i}    IN RANGE    0    ${zs}    ${NUM}
    \    ${name}    Set Variable    rule${COUNT}
    \    ${logtypevalue}    Evaluate    ${cus_rule}[${i}]
    \    ${iptypevalue}    Evaluate    ${cus_rule}[${i}+1]
    \    ${ipcontent}    Evaluate    ${cus_rule}[${i}+2]
    \    ${logcontent1}    Evaluate    ${cus_rule}[${i}+3]
    \    ${timevalue}    Evaluate    ${cus_rule}[${i}+4]
    \    ${maxlevel}    Evaluate    ${cus_rule}[${i}+5]
    \    ${midlevel}    Evaluate    ${cus_rule}[${i}+6]
    \    ${minlevel}    Evaluate    ${cus_rule}[${i}+7]
    \    ${alarmtime}    Evaluate    ${cus_rule}[${i}+8]
    \    ${agingtime}    Evaluate    ${cus_rule}[${i}+9]
    \    @{temp}    Create List    ${logtypevalue}    ${iptypevalue}    ${ipcontent}    ${logcontent1}
    \    ...    ${timevalue}    ${maxlevel}    ${midlevel}    ${minlevel}    ${alarmtime}
    \    ...    ${agingtime}
    \    新建单条告警规则    ${name}    @{temp}
    \    ${COUNT}    Evaluate    ${COUNT}+1

数据采集配置菜单
    Wait Until Page Contains Element    //a[@href="/dataconfig/index"]    10
    Click Link    //a[@href="/dataconfig/index"]
    sleep    3
    Unselect Frame
    Select Frame    main_frame

数据源配置菜单
    Wait Until Page Contains Element    //a[@hrefurl="/dataconfig/dataSourceIndex"]    10
    Click Link    //a[@hrefurl="/dataconfig/dataSourceIndex"]
    sleep    3

安全日志配置菜单
    Wait Until Page Contains Element    //a[@hrefurl="/dataconfig/safelogIndex"]    10
    Click Link    //ul/li[2]/a
    sleep    3

新建安全日志
    Select Frame    overViewContent
    Wait Until Page Contains Element    //input[@value="新建安全日志"]    10
    Click Button    //input[@value="新建安全日志"]
    sleep    3
    Unselect Frame
    Select Frame    index=3
    Wait Until Page Contains Element    //input[@name="logname"]
    Input Text    //input[@name="logname"]    testlog111
    Input Text    //input[@name="version"]    1.1
    Click Button    //input[@value="保存"]
    sleep    1

仪表盘菜单
    Wait Until Page Contains Element    //a[@href="/launch/index"]    10
    Click Link    //ol/li[1]/a    #仪表盘页面
    sleep    3

选择索引
    [Arguments]    ${index_name}    # 索引名称
    Wait Until Page Contains Element    //a[@href="#/discover"]    30    #查看页面是否有“搜索”
    Click Link    //a[@href="#/discover"]
    Wait Until Page Contains Element    //input[@aria-label="Search input"]    30
    Wait Until Page Contains Element    //navbar/div/div/button[2]    30
    Click Button    //navbar/div/div/button[2]
    Wait Until Element Does Not Contain    //a[@ng-click="stopSearch()"]    30
    #选择索引
    Click Button    //div/navbar/form/div/div[1]/div[1]/button
    Comment    Click Link    //navbar/form/div/div[1]/div[1]/ul/li[3]/a
    ${item}    Get Matching Xpath Count    //li[@class="sidebar-item-title ng-scope"]
    ${index}    Evaluate    ${item}+1
    log    当前一共有${item}个索引
    : FOR    ${i}    IN RANGE    1    ${index}
    \    ${index_item}    Get Text    //li[@class="sidebar-item-title ng-scope"][${i}]/a
    \    log    ${index_item}
    \    ${status}    ${value}    Run Keyword And Ignore Error    Should Be Equal As Strings    ${index_item}    ${index_name}
    \    Run Keyword If    '${status}' == 'PASS'    Click Link    //li[@class="sidebar-item-title ng-scope"][${i}]/a
    \    Run Keyword If    '${status}' == 'PASS'    Exit For Loop
    \    Run Keyword If    '${status}'== 'FAIL'    No Operation

输入搜索条件
    [Arguments]    ${search}    # 搜索条件
    #向输入框中输入搜索条件
    Input Text    //input[@aria-label="Search input"]    ${search}    #${search}参数化搜索条件
    #时间选择
    #点击搜索按钮
    Click Button    //button[@aria-label="Search"]
    Set Screenshot Directory    M:\\robot

选择时间
    Wait Until Page Contains Element    //div/navbar/form/div/div[1]/button[1]    30
    Click Button    //div/navbar/form/div/div[1]/button[1]
    Comment    sleep    5
    Comment    Assign Id To Element    xpath=//*[@id="nspopover-15"]/div[2]/kbn-timepicker/div/div/accordion//div[1]/ul/li[1]/a    今天
    Comment    Assign Id To Element    xpath=//*[@id="nspopover-15"]/div[2]/kbn-timepicker/div/div/accordion//div[1]/ul/li[2]/a    本周
    Comment    Assign Id To Element    xpath=//*[@id="nspopover-15"]/div[2]/kbn-timepicker/div/div/accordion//div[1]/ul/li[3]/a    本月
    Comment    Assign Id To Element    xpath=//*[@id="nspopover-15"]/div[2]/kbn-timepicker/div/div/accordion//div[1]/ul/li[4]/a    本年
    Comment    Assign Id To Element    xpath=//*[@id="nspopover-15"]/div[2]/kbn-timepicker/div/div/accordion//div[1]/ul/li[5]/a    一天以内
    Comment    Assign Id To Element    xpath=//*[@id="nspopover-15"]/div[2]/kbn-timepicker/div/div/accordion//div[1]/ul/li[6]/a    本周以内
    Click Link    xpath=//*[@id="nspopover-15"]/div[2]/kbn-timepicker/div/div/accordion//div[1]/ul/li[5]/a
    Click Button    //div/navbar/form/div/div[1]/button[1]
    sleep    10

证书管理菜单
    Wait Until Page Contains Element    //a[@href="/license/index"]    10
    Page Should Contain Link    //a[@href="/license/index"]
    Click Link    //a[@href="/license/index"]
    sleep    2

设置
    Click Link    //*[@id="navbar"]/ul[2]/li[2]/a
    sleep    2

系统控制菜单
    Wait Until Page Contains Element    //a[@href="/systemOperate/index"]    10
    Page Should Contain Link    //a[@href="/systemOperate/index"]
    Click Link    //a[@href="/systemOperate/index"]
    sleep    2

日志采集器管理菜单
    Wait Until Page Contains Element    //a[@href="/dataconfig/npaiManIndex"]    10
    Page Should Contain Link    //a[@href="/dataconfig/npaiManIndex"]
    Click Link    //a[@href="/dataconfig/npaiManIndex"]
    sleep    2

时间同步设罊菜单
    Wait Until Page Contains Element    //a[@href="/bcm/timesyncSet"]    10
    Page Should Contain Link    //a[@href="/bcm/timesyncSet"]
    Click Link    //a[@href="/bcm/timesyncSet"]
    sleep    2

接口设置菜单
    Wait Until Page Contains Element    //a[@href="/systemInterface/index"]    10
    Page Should Contain Link    //a[@href="/systemInterface/index"]
    Click Link    //a[@href="/systemInterface/index"]
    sleep    2

调试工具菜单
    Wait Until Page Contains Element    //a[@href="/debugtool/index"]    10
    Page Should Contain Link    //a[@href="/debugtool/index"]
    Click Link    //a[@href="/debugtool/index"]
    sleep    2

数据采集向导菜单
    Wait Until Page Contains Element    //a[@href="/dataconfigGuide/index"]    10
    Page Should Contain Link    //a[@href="/dataconfigGuide/index"]
    Click Link    //a[@href="/dataconfigGuide/index"]
    sleep    2

数据备份菜单
    Wait Until Page Contains Element    //a[@href="/dbBackup/index"]    10
    Page Should Contain Link    //a[@href="/dbBackup/index"]
    Click Link    //a[@href="/dbBackup/index"]
    sleep    2

访问控制菜单
    Wait Until Page Contains Element    //a[@href="/accountmanage/index"]    10
    Page Should Contain Link    //a[@href="/accountmanage/index"]
    Click Link    //a[@href="/accountmanage/index"]
    sleep    2

资产管理菜单
    Wait Until Page Contains Element    //a[@href="/asset/index"]    10
    Page Should Contain Link    //a[@href="/asset/index"]
    Click Link    //a[@href="/asset/index"]
    sleep    2

应用管理菜单
    Wait Until Page Contains Element    //a[@href="/appManager/index"]    10
    Page Should Contain Link    //a[@href="/appManager/index"]
    Click Link    //a[@href="/appManager/index"]
    sleep    2

集群管理菜单
    Wait Until Page Contains Element    //a[@href="/bcm"]    10
    Page Should Contain Link    //a[@href="/bcm"]
    Click Link    //a[@href="/bcm"]
    sleep    2

集群概览菜单
    Wait Until Page Contains Element    //a[@data-href="/bcm/overview"]    10
    Page Should Contain Link    //a[@data-href="/bcm/overview"]
    Click Link    //a[@data-href="/bcm/overview"]
    sleep    2

集群组件菜单
    Wait Until Page Contains Element    //a[@data-href="/bcm/components"]    10
    Page Should Contain Link    //a[@data-href="/bcm/components"]
    Click Link    //a[@data-href="/bcm/components"]
    sleep    2

集群主机菜单
    Wait Until Page Contains Element    //a[@data-href="/bcm/nodes"]    10
    Page Should Contain Link    //a[@data-href="/bcm/nodes"]
    Click Link    //a[@data-href="/bcm/nodes"]
    sleep    2

页面集群卸载
    Wait Until Page Contains Element    //a[@data-href="/bcm/clusterManage"]    10
    Page Should Contain Link    //a[@data-href="/bcm/clusterManage"]
    Click Link    //a[@data-href="/bcm/clusterManage"]
    sleep    2
    Unselect Frame
    Select Frame    mainFrame
    Page Should Contain Button    //*[@id="removeCluster"]
    Click Button    //*[@id="removeCluster"]
    Confirm Action
    sleep    60
    Unselect Frame
    Select Frame    mainFrame
    Wait Until Element Is Visible    //*[@id="tipsCreateCluster"]/span    10
    ${text}    Get Text    //*[@id="tipsCreateCluster"]/span
    Should Contain    ${text}    请先进行集群部署

集群系统升级菜单
    Wait Until Page Contains Element    //a[@data-href="/bcm/sysUpdate"]    10
    Page Should Contain Link    //a[@data-href="/bcm/sysUpdate"]
    Click Link    //a[@data-href="/bcm/sysUpdate"]
    sleep    2

组件定制配置
    #zookeeper配置
    #zookeeperdatapath配置
    Click Link    //a[@id="configZookeeper"]
    Wait Until Element Is Visible    //input[@id="dataDirZookeeper"]    10
    input text    //input[@id="dataDirZookeeper"]    ${zookeeperdatapath}
    Click Link    //td[@id="ConfigZookeeper"][1]/a[1]    #保存
    #zookeeper主机配置
    Click Link    //a[@id="nodeMapZookeeper" ]
    Wait Until Element Is Visible    //table[@id="zookeeperNodesTable"]    10
    ${144zk}    Set Variable If    ${144zookeeper}==1    1    0
    Run Keyword If    ${144zk}==1    Select Checkbox    //input[@id="zookeeperCheck0"]
    Run Keyword If    ${144zk}==0    No Operation
    Click Link    //td[@id="NodeZookeeper"]/td[@id="ConfigZookeeper"][1]/a[1]    #保存
    #kafka配置
    #kafkalogpath配置
    Click Link    //a[@id="configKafka"]
    Wait Until Element Is Visible    //input[@id="logDirKafka"]    10
    input text    //input[@id="logDirKafka"]    ${kafkalogpath}
    input text    //input[@id="logRetentionHours"]    ${kafkalogretentionhours}
    Click Link    //td[@id="ConfigKafka"][1]/a[1]    #保存
    #kafka主机配置
    Click Link    //a[@id="nodeMapKafka" ]
    Wait Until Element Is Visible    //table[@id="kafkaNodesTable"]    10
    ${144kk}    Set Variable If    ${144kafka}==1    1    0
    Run Keyword If    ${144kk}==1    Select Checkbox    //input[@id="kafkaCheck0"]
    Run Keyword If    ${144kk}==0    No Operation
    Click Link    //td[@id="NodeKafka"]/td[@id="ConfigKafka"][1]/a[1]
    #spark配置
    #spark组件配置
    Click Link    //a[@id="configSpark"]
    Wait Until Element Is Visible    //input[@id="sparkLocalDir"]    10
    input text    //input[@id="sparkLocalDir"]    ${sparklocalpath}
    input text    //input[@id="sparkWorkerDir"]    ${sparkworkerpath}
    input text    //input[@id="sparkNumExecutors"]    ${SPARKNUMEXCUTORS}
    input text    //input[@id="sparkExecutorMem"]    ${SPARKEXCUTORMEM}
    Click Link    //td[@id="ConfigSpark"][1]/a[1]    #保存
    #spark主机配置
    Click Link    //a[@id="nodeMapSpark" ]
    Wait Until Element Is Visible    //table[@id="sparkNodesTable"]    10
    ${144sk}    Set Variable If    ${144spark}==1    1    0
    Run Keyword If    ${144sk}==1    Click Element    //input[@id="sparkCheck0"]
    Run Keyword If    ${144sk}==0    No Operation
    Click Link    //td[@id="NodeSpark"]/td[@id="ConfigSpark"][1]/a[1]
    #Elasticsearch配置
    #Elasticsearchlogpath配置
    Click Link    //a[@id="configElasticsearch"]
    Wait Until Element Is Visible    //input[@id="dataDirEs"]    10
    input text    //input[@id="dataDirEs"]    ${Elasticsearchdatapath}
    input text    //input[@id="workDirEs"]    ${Elasticsearchworkpath}
    input text    //input[@id="logDirEs"]    ${Elasticsearchlogpath}
    Click Link    //td[@id="ConfigElasticsearch"][1]/a[1]    #保存
    #Elasticsearch主机配置
    Click Link    //a[@id="nodeMapElasticsearch" ]
    Wait Until Element Is Visible    //table[@id="esNodesTable"]    10
    ${144es}    Set Variable If    ${144elasticsearch}==1    1    0
    Run Keyword If    ${144es}==1    Select Checkbox    //input[@id="esCheck0"]
    Run Keyword If    ${144es}==0    No Operation
    Click Link    //td[@id="NodeElasticsearch"]/td[@id="ConfigElasticsearch"][1]/a[1]

集群名称填写
    [Arguments]    ${clustername}
    Unselect Frame
    Select Frame    mainFrame
    Wait Until Page Contains Element    //div[@id="tipsCreateCluster"]    10
    Input Text    //input[@id="clusterName"]    ${clustername}
    Input Text    //input[@id="userName"]    ${bsaworker}

主机列表填写
    [Arguments]    ${hostnamelist}    # 主机列表
    ${hn}    Create List
    input text    //input[@id="hostnameList"]    ${hostnamelist}
    @{hostlist}    Split String    ${hostnamelist}    ,
    ${num}    Evaluate    len(@{hostlist})
    Set Global Variable    ${num}
    ${nodelist}    Evaluate    ${num}+2
    Wait Until Page Contains Element    //button[@id="detectNodeBtn"]    10
    Click Button    //button[@id="detectNodeBtn"]
    sleep    10
    Wait Until Element Is Visible    //div[@id="detectedNodeArea"]    60
    #主机检查
    : FOR    ${i}    IN RANGE    2    ${nodelist}
    \    ${hostname}    Get Table Cell    detectedNodesList    ${i}    1
    \    ${status}    Get Table Cell    detectedNodesList    ${i}    7
    \    ${satisfied}    Get Table Cell    detectedNodesList    ${i}    8
    \    Should Contain    ${status}    Host is valid
    \    Should Contain    ${satisfied}    是
    \    Append To List    ${hn}    ${hostname}
    [Return]    ${hn}

部署hadoop组件配置
    #hadoop组件配置
    Click Link    //a[@id="configHadoop"]
    Wait Until Element Is Visible    //input[@id="nameNodePath"]    10
    input text    //input[@id="nameNodePath"]    ${hadoopnamenodepath}
    input text    //input[@id="dataNodePath"]    ${hadoopdatanodepath}
    input text    //input[@id="hadoopTempPath"]    ${hadooptemppath}
    Click Link    //td[@id="ConfigHadoop"][1]/a[1]    #保存

部署单机hadoop主机配置
    #单机hadoop主机配置
    Click Link    //a[@id="nodeMapHadoop"]
    Wait Until Element Is Visible    //table[@id="hadoopNodesTable"]    10
    #hadoop namenode选择
    ${144hnamenode}    Set Variable If    ${144hadoopnamenode}==1    1    0
    Run Keyword If    ${144hnamenode}==1    Click Element    //input[@id="nameNodeCheck0"]
    Run Keyword If    ${144hnamenode}==0    No Operation
    #hadoop sec.namenode选择
    ${144hsnamenode}    Set Variable If    ${144hadoopsecnamenode}==1    1    0
    Run Keyword If    ${144hsnamenode}==1    Click Element    //input[@id="secNameNodeCheck0"]
    Run Keyword If    ${144hsnamenode}==0    No Operation
    #hadoop datanode选择
    ${144hdatanode}    Set Variable If    ${144hadoopdatanode}==1    1    0
    Run Keyword If    ${144hdatanode}==1    Select Checkbox    //input[@id="dataNodeCheck0"]
    Run Keyword If    ${144hdatanode}==0    No Operation
    #hadoop Resource Manager选择
    ${144hsm}    Set Variable If    ${144hadoopresourcemanager}==1    1    0
    Run Keyword If    ${144hsm}==1    Click Element    //input[@id="resourceManagerCheck0"]
    Run Keyword If    ${144hsm}==0    No Operation
    #hadoop Node Manager选择
    ${144hnm}    Set Variable If    ${144hadoopnodemanager} ==1    1    0
    Run Keyword If    ${144hnm}==1    Select Checkbox    //input[@id="nodeManagerCheck0"]
    Run Keyword If    ${144hnm}==0    No Operation
    Click Link    //div[2]/div/table/tbody/tr[1]/td[3]/td/a[1]    #保存

部署多机hadoop主机配置
    [Arguments]    ${m}
    ${n}    Set Variable If    ${m}==0    1    0
    #多机hadoop主机配置
    Click Link    //a[@id="nodeMapHadoop"]
    Wait Until Element Is Visible    //table[@id="hadoopNodesTable"]    10
    #hadoop namenode,resoure manager,standby namenode选择
    Click Element    //input[@id="nameNodeCheck${m}"]
    Click Element    //input[@id="resourceManagerCheck${m}"]
    Click Element    //input[@id="standbyNameNodeCheck${n}"]
    : FOR    ${i}    IN RANGE    0    ${num}
    \    Select Checkbox    //input[@id="dataNodeCheck${i}"]
    \    Select Checkbox    //input[@id="nodeManagerCheck${i}"]
    \    Select Checkbox    //input[@id="jouralNodeCheck${i}"]
    Click Link    //td[@id="NodeHadoop"]/td[@id="ConfigHadoop"][1]/a[1]    #保存

部署spark组件配置
    #spark组件配置
    Click Link    //a[@id="configSpark"]
    Wait Until Element Is Visible    //input[@id="sparkLocalDir"]    10
    input text    //input[@id="sparkLocalDir"]    ${sparklocalpath}
    input text    //input[@id="sparkWorkerDir"]    ${sparkworkerpath}
    input text    //input[@id="sparkNumExecutors"]    ${SPARKNUMEXCUTORS}
    input text    //input[@id="sparkExecutorMem"]    ${SPARKEXCUTORMEM}
    Click Link    //td[@id="ConfigSpark"][1]/a[1]    #保存

部署spark主机配置
    [Arguments]    ${listnum}
    #spark主机配置
    Click Link    //a[@id="nodeMapSpark" ]
    Wait Until Element Is Visible    //table[@id="sparkNodesTable"]    10
    Click Element    //input[@id="sparkCheck${listnum}"]
    Click Link    //td[@id="NodeSpark"]/td[@id="ConfigSpark"][1]/a[1]

部署zookeeper组件配置
    Click Link    //a[@id="configZookeeper"]
    Wait Until Element Is Visible    //input[@id="dataDirZookeeper"]    10
    input text    //input[@id="dataDirZookeeper"]    ${zookeeperdatapath}
    Click Link    //td[@id="ConfigZookeeper"][1]/a[1]    #保存

部署zookeeper主机配置
    Click Link    //a[@id="nodeMapZookeeper" ]
    Wait Until Element Is Visible    //table[@id="zookeeperNodesTable"]    10
    : FOR    ${i}    IN RANGE    0    ${num}
    \    Select Checkbox    //input[@id="zookeeperCheck${i}"]
    Click Link    //td[@id="NodeZookeeper"]/td[@id="ConfigZookeeper"][1]/a[1]    #保存

部署kafka组件配置
    #kafka组件配置
    Click Link    //a[@id="configKafka"]
    Wait Until Element Is Visible    //input[@id="logDirKafka"]    10
    input text    //input[@id="logDirKafka"]    ${kafkalogpath}
    input text    //input[@id="logRetentionHours"]    ${kafkalogretentionhours}
    Click Link    //td[@id="ConfigKafka"][1]/a[1]    #保存

部署kafka主机配置
    Click Link    //a[@id="nodeMapKafka" ]
    Wait Until Element Is Visible    //table[@id="kafkaNodesTable"]    10
    : FOR    ${i}    IN RANGE    0    ${num}
    \    Select Checkbox    //input[@id="kafkaCheck${i}"]
    Click Link    //td[@id="NodeKafka"]/td[@id="ConfigKafka"][1]/a[1]

部署Elasticsearch组件配置
    #Elasticsearch组件配置
    Click Link    //a[@id="configElasticsearch"]
    Wait Until Element Is Visible    //input[@id="dataDirEs"]    10
    input text    //input[@id="dataDirEs"]    ${Elasticsearchdatapath}
    input text    //input[@id="workDirEs"]    ${Elasticsearchworkpath}
    input text    //input[@id="logDirEs"]    ${Elasticsearchlogpath}
    Click Link    //td[@id="ConfigElasticsearch"][1]/a[1]    #保存

部署Elasticsearch主机配置
    #Elasticsearch主机配置
    Click Link    //a[@id="nodeMapElasticsearch" ]
    Wait Until Element Is Visible    //table[@id="esNodesTable"]    10
    : FOR    ${i}    IN RANGE    0    ${num}
    \    Select Checkbox    //input[@id="esCheck${i}"]
    Click Link    //td[@id="NodeElasticsearch"]/td[@id="ConfigElasticsearch"][1]/a[1]
