*** Settings ***
Suite Setup       获取安装包名称    #获取安装包名称
Resource          Linuxkeywords.robot    # linux常用关键字
Resource          WEBkeywords.robot    # WEB端常用关键字
Resource          PublicVariable.robot    #公共变量
Resource          RESTFULkeywords.robot    # RestFul接口

*** Test Cases ***
WEB进行集群卸载
    登录    ${host144IP}
    设置
    集群管理菜单
    页面集群卸载
    Close Browser

后台运行安装脚本
    [Tags]    L
    linux主机登录    ${host144IP}
    判断原有安装目录是否存在
    判断正确的安装包是否存在
    对安装包进行解压
    判断解压是否成功
    进入配置脚本所在目录
    配置hostlist和hosts    ${hostlistIP}    ${hostlists}
    执行配置脚本
    进入解压后的安装包目录，执行安装脚本
    #判断安装脚本执行是否正常
    Open Browser    https://${host144IP}    firefox
    sleep    2
    Wait Until Page Contains Element    //div[@role="alert"]    10
    Close Browser

部署后导入证书
    第一次导入证书    ${host144IP}

第一次登录修改密码
    Open Browser    https://${host144IP}
    Selenium2Library.Set Selenium Speed    0.3
    Wait Until Page Contains Element    //*[@id="inputEmail"]    10
    Input Text    //input[@id="inputEmail"]    ${USERNAME}
    Input Password    //input[@id="inputPassword"]    ${USERNAME}
    Click Button    //button[@class="btn circle-btn"]
    sleep    2
    Wait Until Page Contains Element    //div[@id="myModalLabel"]    10
    Page Should Contain Element    //input[@id="a1"]
    Input Password    //input[@name="oldPwd"]    ${USERNAME}
    Input Password    //input[@name="newPassword"]    ${PASSWORD}
    Input Password    //input[@name="newPasswordAgain"]    ${PASSWORD}
    Wait Until Page Contains Element    //*[@id="modalForLogin"]//button[@type="submit"]    10
    Click Button    //*[@id="modalForLogin"]//button[@type="submit"]
    sleep    2
    Close Browser

WEB集群部署
    登录    ${host144IP}
    集群名称填写    ${host144}
    ${hn}    主机列表填写    ${hostlists}
    #选择管理节点
    ${master}    find index    ${host144}    ${hn}
    #hadoop配置
    部署hadoop组件配置
    Run Keyword If    ${num} ==1    部署单机hadoop主机配置
    Run Keyword If    ${num} >1    部署多机hadoop主机配置    ${master}
    #zookeeper配置
    部署zookeeper组件配置
    部署zookeeper主机配置
    #kafka配置
    部署kafka组件配置
    部署kafka主机配置
    #spark配置
    部署spark组件配置
    部署spark主机配置    ${master}
    #Elasticsearch配置
    部署Elasticsearch组件配置
    部署Elasticsearch主机配置
    #点击部署
    Click Button    //button[@id="deployCluster"]
    sleep    200
    Unselect Frame
    Wait Until Page Contains Element    //div[@class="navbar-header"]    100
    Close Browser
    [Teardown]

检查组件状态
    登录    ${host144IP}
    设置
    集群管理菜单
    集群组件菜单
    Unselect Frame
    Select Frame    mainFrame
    #web检查组件状态    #stop.png为失败
    :FOR    ${i}    in range    1    6
    \    ${j}    Evaluate    ${i}+1
    \    ${componentname}    Get Table Cell    componentList    ${j}    1
    \    ${img}    Get Element Attribute    //table[@id="componentList"]/tbody/tr[${i}]/td[1]/img@src
    \    ${img}    Fetch From Right    ${img}    /
    \    ${status}    ${back}    Run Keyword And Ignore Error    Should Be Equal As Strings    ${img}    run.png
    \    Run Keyword If    '${status}' == 'FAIL'    log    组件${componentname}状态加载${status}    WARN
    \    Log    组件${componentname}状态加载${status}
    Close Browser

正常状态更换证书
    登录    ${host144IP}
    设置
    证书管理菜单
    ${title}    Get Title
    Click Button    //*[@id="licenseName"]
    Win Wait    文件上传
    Win Activate    文件上传
    Control Set Text    \    \    Edit1    ${licensepath}
    sleep    2
    Control Click    \    \    Button1
    sleep    3
    Click Button    //button[@class="btn btn-primary btn-sm"]
    sleep    10
    #检查证书导入正确性

组件日志路径配置校验
    #1后台整理系统组件生成的所有日志
    ${currentlog}    Create List
    ${index1}    Open Connection    ${host122IP}    alias=${host1}
    Comment    Enable Ssh Logging    E:\\learnprocess\\bsa122.log
    Login    ${sshusername}    ${sshpassword}
    ${index2}    Open Connection    ${host124IP}    alias=${host2}
    Comment    Enable Ssh Logging    E:\\learnprocess\\bsa124.log
    Login    ${sshusername}    ${sshpassword}
    ${index3}    Open Connection    ${host126IP}    alias=${host3}
    Comment    Enable Ssh Logging    E:\\learnprocess\\bsa126.log
    Login    ${sshusername}    ${sshpassword}
    ${host1log}    CollectComponentLog    ${host122}
    ${host2log}    CollectComponentLog    ${host124}
    ${host3log}    CollectComponentLog    ${host126}
    #后台整理用户日志    /home/bsauser/logs    #注意只在管理节点上有
    ${bsauserlog}    List Files In Directory    /home/bsauser/logs
    Append To List    ${currentlog}    ${bsauserlog}    ${host1log}    ${host2log}    ${host3log}
    Log List    ${currentlog}
    [Teardown]

调试日志导出
    Open Browser    https://${host144IP}
    Set Selenium Speed    0.3
    Wait Until Page Contains Element    //*[@id="inputEmail"]    10
    Input Text    //input[@id="inputEmail"]    ${USERNAME}
    Input Password    //input[@id="inputPassword"]    ${PASSWORD}
    Click Button    //button[@class="btn circle-btn"]
    sleep    2
    Wait Until Element Is Visible    //*[@id="navbar"]    10
    Click Link    //*[@id="navbar"]/ul[2]/li[2]/a
    sleep    2
    Page Should Contain Link    //a[@href="/dbBackup/index"]
    Click Link    //a[@href="/dbBackup/index"]
    sleep    5
    Wait Until Element Contains    //*[@id="navbar"]/ul/li[2]/a    数据导出
    Click Link    //*[@id="navbar"]/ul/li[2]/a
    Wait Until Element Is Visible    //a[@ng-click="item='logs'"]    10
    Click Link    //a[@ng-click="item='logs'"]
    Wait Until Element Is Visible    //div/form/div/span
    Click Element    //div/form/div/span
    Wait Until Element Is Visible    //input[@name="daterangepicker_start"]
    Input Text    //input[@name="daterangepicker_start"]    2016-1-18
    Input Text    //input[@name="daterangepicker_end"]    2016-1-19
    Click Button    //button[@class="applyBtn btn btn-sm btn-success" ]
    #等待需要备份的文件收集完毕
    Click Button    //button[@ng-click="download()"]
    sleep    10
    #未完待确认

创建最大告警规则数
    登录
    日志告警菜单
    告警规则列表页面
    新建多条告警规则

创建安全日志
    登录
    数据采集配置
    数据采集配置菜单
    安全日志配置菜单
    新建安全日志

进入报表页面
    登录
    搜索与报表菜单
    选择索引    internal_nsfocus_ips*

teststring
    Comment    ${tee}    Split String    bsa144,bsa165,bsa166,bsa167,bsa168,bsa169,bsa170    ,
    Comment    Comment    Comment    @{tee}    Split String    10.67.1.144,10.5.0.165,10.5.0.166,10.5.0.167,10.5.0.168,10.5.0.169,10.5.0.170    ,
    Comment    Comment    ${num}    Evaluate    len(@{tee})
    Comment    Comment    : FOR    ${i}    IN RANGE    0    ${num}
    Comment    Comment    \    log    @{tee}[${i}]
    Comment    ${index}    find index    bsa167    ${tee}
    Comment    log    ${index}
    ${temp}    Set Variable    https://10.67.1.144/WebApi/bcm/static/image/stop.png
    ${t}    Fetch From Right    ${temp}    /
    log    ${t}

A接口client部署

A接口server部署
