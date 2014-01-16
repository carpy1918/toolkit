#=======================================================================================
# This is an example of a simple WLST offline configuration script. The script creates
# a simple WebLogic domain using the Basic WebLogic Server Domain template. The script
# demonstrates how to open a domain template, create and edit configuration objects,
# and write the domain configuration information to the specified directory.
#
# This sample uses the demo Pointbase Server that is installed with your product.
# Before starting the Administration Server, you should start the demo Pointbase server
# by issuing one of the following commands:
#
# Windows: WL_HOME\common\eval\pointbase\tools\startPointBase.cmd
# UNIX: WL_HOME/common/eval/pointbase/tools/startPointBase.sh
#
# (WL_HOME refers to the top-level installation directory for WebLogic Server.)
#
# The sample consists of a single server, representing a typical development environment.
# This type of configuration is not recommended for production environments.
#
# Please note that some of the values used in this script are subject to change based on
# your WebLogic installation and the template you are using.
#
# Usage:
#      wlst.sh <WLST_script>
#
# Where:
#      <WLST_script> specifies the full path to the WLST script.
#=======================================================================================

connect('system','weblogic','t3://nap2lsdev1:37500')

domainName=get('Name')
MS='ms01'
Machine='nap2lsdev1'
Port=37701

MS2='ms02'
Port2=37702

MS3='ms03'
Port3=37703

MS4='ms04'
Port4=37704

ClaimInquiryUser='clmcap01_repricer'
ViantClientUser='beacap01_ro'


cd('/')

edit()
startEdit()

#
#create cluster and managed server
#

cd('/')
cmo.createServer(MS)
cmo.createServer(MS2)
cmo.createServer(MS3)
cmo.createServer(MS4)

cd('/Servers/' + MS)
cmo.setListenAddress(Machine)
cmo.setListenPort(Port)

cd('/Servers/' + MS2)
cmo.setListenAddress(Machine)
cmo.setListenPort(Port2)

cd('/Servers/' + MS3)
cmo.setListenAddress(Machine)
cmo.setListenPort(Port3)

cd('/Servers/' + MS4)
cmo.setListenAddress(Machine)
cmo.setListenPort(Port4)

cd('/')
#cmo.createCluster('sbrcluster1')

cd('/Clusters/sbrcluster1')
cmo.setClusterMessagingMode('unicast')
cmo.setClusterBroadcastChannel('')

cd('/')
cmo.createCluster('ClaimServicesCluster')

cd('/Clusters/ClaimServicesCluster')
cmo.setClusterMessagingMode('unicast')
cmo.setClusterBroadcastChannel('')

cd('/Servers/' + MS3)
cmo.setCluster(getMBean('/Clusters/ClaimServicesCluster'))

cd('/Servers/' + MS4)
cmo.setCluster(getMBean('/Clusters/ClaimServicesCluster'))

cd('/Servers/' + MS)
cmo.setCluster(getMBean('/Clusters/sbrcluster1'))

cd('/Servers/' + MS2)
cmo.setCluster(getMBean('/Clusters/sbrcluster1'))

cd('/')
bean=getMBean('Machines/' + Machine)
cd('Servers/' + MS)
cmo.setMachine(bean)

cd('/')
bean2=getMBean('Machines/' + Machine)
cd('Servers/' + MS2)
cmo.setMachine(bean2)

cd('/')
bean3=getMBean('Machines/' + Machine)
cd('Servers/' + MS3)
cmo.setMachine(bean3)

cd('/')
bean4=getMBean('Machines/' + Machine)
cd('Servers/' + MS4)
cmo.setMachine(bean4)


# Create the "Claim Inquiry Data Source' JDBC Data Source
dsname='Claim Inquiry Data Source'

cd('/')
cmo.createJDBCSystemResource(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname)
cmo.setName(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
set('JNDINames',jarray.array([String('claimInquirydatasource')], String))

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname)
cmo.setUrl('jdbc:oracle:thin:@ldap://ldap:389/dsclms01,cn=OracleContext,dc=viant,dc=db')
cmo.setDriverName('oracle.jdbc.xa.client.OracleXADataSource')
cmo.setPassword(ClaimInquiryUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCConnectionPoolParams/' + dsname)
cmo.setInitSql('SQL select SET_CONN_MODULE(\'claim-inquiry\',\'INIT-SQL\', \'' + domainName.upper() + '\') from dual')
cmo.setTestTableName('SQL select SET_CONN_MODULE(\'claim-inquiry\',\'TEST-SQL\', \'' + domainName.upper() + '\') from dual')
cmo.setTestConnectionsOnReserve(true)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname)
cmo.createProperty('user')

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname + '/Properties/user')
cmo.setValue(ClaimInquiryUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')

cd('/SystemResources/' + dsname)
set('Targets',jarray.array([ObjectName('com.bea:Name=ClaimServicesCluster,Type=Cluster')], ObjectName))

# Create the "Viant Client Data Source' JDBC Data Source
dsname='Viant Client Data Source'

cd('/')
cmo.createJDBCSystemResource(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname)
cmo.setName(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
set('JNDINames',jarray.array([String('viantClientInquirydatasource')], String))

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname)
cmo.setUrl('jdbc:oracle:thin:@ldap://ldap:389/qabeac01,cn=OracleContext,dc=viant,dc=db')
cmo.setDriverName('oracle.jdbc.xa.client.OracleXADataSource')
cmo.setPassword(ViantClientUser)
#or this
#set('PasswordEncrypted', ViantClientUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCConnectionPoolParams/' + dsname)
cmo.setInitSql('SQL select SET_CONN_MODULE(\'viantclient-inquiry\',\'INIT-SQL\', \'' + domainName.upper() + '\') from dual')
cmo.setTestTableName('SQL select SET_CONN_MODULE(\'viantclient-inquiry\',\'TEST-SQL\', \'' + domainName.upper() + '\') from dual')
cmo.setTestConnectionsOnReserve(true)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname)
cmo.createProperty('user')

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname + '/Properties/user')
cmo.setValue(ViantClientUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')

cd('/SystemResources/' + dsname)
set('Targets',jarray.array([ObjectName('com.bea:Name=ClaimServicesCluster,Type=Cluster')], ObjectName))

activate()
