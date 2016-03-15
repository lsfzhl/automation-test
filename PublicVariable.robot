*** Variables ***
${host144}        bsa144    # 144hostname
${host122}        bsa122    # 122hostname
${host124}        bsa124    # 124hostname
${host126}        bsa126    # 10.67.1.126hostname
${host144IP}      10.67.1.144    # 集群主机144IP
${host122IP}      10.67.1.122    # 集群主机122IP
${host124IP}      10.67.1.124    # 集群主机124IP
${host126IP}      10.67.1.126    # 集群主机126IP
${sshusername}    root    # ssh登录用户名
${sshpassword}    nsf0cus.    # ssh登录密码
${USERNAME}       admin
${PASSWORD}       Nsf0cus!@#
${ipchoice}       1    # Enter your choice for public ip
${PORT}           9090
@{cus_rule}       1    0    10.1.1.3    10    10    9    8
...               7    10    10    2    1    10.1.1.2    10
...               5    4    3    2    10    15    3
...               0    10.1.1.6    10    10    9    8    7
...               10    10    4    0    10.1.1.7    10    10
...               9    8    7    10    10
${NUM}            10
${MAX_PT}         2
${InstallPackage}    BSA_installer_2.0.0.0.4391_zh_CN.tar.gz    # 安装包文件名
${licensepath}    E:\\tool\\证书\\bsa-2.0.0.0144.lic
${bsaworker}      bsaworker
${hadoopnamenodepath}    /home/bsaworker/hes/hadoopDirs/name    # hadoop namenode path
${hadoopdatanodepath}    /home/bsaworker/hes/hadoopDirs/data    # hadoop datanode path
${hadooptemppath}    /home/bsaworker/hes/hadoopDirs/hadooptmp    # hadoop temp path
${zookeeperdatapath}    /home/bsaworker/zookeeper/zk_data_dir/    # zookeeper data path
${kafkalogpath}    /home/bsaworker/kafka/logs    # kafka log path
${kafkalogretentionhours}    168    #kafka logretention hours
${sparklocalpath}    /home/bsaworker/spark/tmp    #sparklocalpath
${sparkworkerpath}    /home/bsaworker/spark/work    #sparkworkpath
${SPARKNUMEXCUTORS}    3    #SPARK NUM EXCUTORS
${SPARKEXCUTORMEM}    2    #SPARK EXCUTOR MEM
${Elasticsearchdatapath}    /home/bsaworker/elasticsearch/data    #Elasticsearch data path
${Elasticsearchworkpath}    /home/bsaworker/elasticsearch/work    #Elasticsearch work path
${Elasticsearchlogpath}    /home/bsaworker/elasticsearch/log    #Elasticsearch log path
${144hadoopnamenode}    1    # 选择在bsa144上安装hadoop namenode 节点
${144hadoopsecnamenode}    1    # 选择在bsa144上安装hadoop sec.namenode 节点
${144hadoopdatanode}    1    # 选择在bsa144上安装hadoop datanode 节点
${144hadoopresourcemanager}    1    # 选择在bsa144上安装hadoop resource manager 节点
${144hadoopnodemanager}    1    # 选择在bsa144上安装hadoop Node Manager节点
${144zookeeper}    1    # 选择在bsa144上安装zookeeper
${144kafka}       1    # 选择在bsa144上安装kafka节点
${144spark}       1    # 选择在bsa144上安装spark节点
${144elasticsearch}    1    # 选择在bsa144上安装Elasticsearch节点
${hostlists}      bsa144,bsa164    #bsa144,bsa165,bsa166,bsa167,bsa168,bsa169,bsa170# 主机名填写，使用,分割
${hostlistIP}     10.67.1.144,10.67.1.164    #10.67.1.144,10.5.0.165,10.5.0.166,10.5.0.167,10.5.0.168,10.5.0.169,10.5.0.170# 对应主机名的IP，使用,分割
