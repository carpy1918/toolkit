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

ClaimInquiryUser='clmsys10_repricer'
ViantClientUser='beacap01_ro'
ProviderMartUser='prvsys04_loader'
BRESUser='BRESYS10_EXECUTIONSERVER'
FeesScheduleUser='fssys04_user'
ProviderUser='prvsys04_loader'  
JACSUser='jacsdev01_jacs'

platform_abbr=''
domain_abbr=''
domain_number''
weblogic_domain=''

cd('/')

edit()
startEdit()

# Create the "Viant Client Data Source' JDBC Data Source
dsname='Viant Client Data Source'

cd('/')
cmo.createJDBCSystemResource(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname)
cmo.setName(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
set('JNDINames',jarray.array([String('viantClientInquirydatasource')], String))


# Create the "ContractDataSourc' JDBC Data Source
dsname='Contract Data Source'

cd('/')
cmo.createJDBCSystemResource(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname)
cmo.setName(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
set('JNDINames',jarray.array([String('contractdatasource')], String))

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname)
cmo.setUrl('jdbc:oracle:thin:@ldap://ldap:389/qaclms01,cn=OracleContext,dc=viant,dc=db')
cmo.setDriverName('oracle.jdbc.xa.client.OracleXADataSource')
cmo.setPassword(ClaimInquiryUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCConnectionPoolParams/' + dsname)
cmo.setInitSql('SQL select SET_CONN_MODULE(\'claim-inquiry\',\'INIT-SQL\', \'' + domainName.upper() + '\') from dual')
cmo.setTestTableName('SQL select SET_CONN_MODULE(\'claim-inquiry\',\'TEST-SQL\', \'' + domainName.upper() + '\') from dual')
cmo.setTestConnectionsOnReserve(true)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname)
cmo.createProperty('user')

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname + '/Pr                  operties/user')
cmo.setValue(ClaimInquiryUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')

cd('/SystemResources/' + dsname)
set('Targets',jarray.array([ObjectName('com.bea:Name=ClaimServicesCluster,Type=Cluster')], ObjectName))

#Provider Mart Data Source
dsname='Provider Mart Data Source'

cd('/')
cmo.createJDBCSystemResource(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname)
cmo.setName(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
set('JNDINames',jarray.array([String('providermartdatasource')], String))

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname)
cmo.setUrl('jdbc:oracle:thin:@ldap://ldap:389/qaprov01,cn=OracleContext,dc=viant,dc=db')
cmo.setDriverName('oracle.jdbc.xa.client.OracleXADataSource')
cmo.setPassword(ProviderMartUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCConnectionPoolParams/' + dsname)
#cmo.setInitSql('')
cmo.setTestTableName('SQL select 1 from dual')
cmo.setTestConnectionsOnReserve(true)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname)
cmo.createProperty('user')

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname + '/Pr                  operties/user')
cmo.setValue(ProviderMartUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')

cd('/SystemResources/' + dsname)
set('Targets',jarray.array([ObjectName('com.bea:Name=sbrcluster1,Type=Cluster')], ObjectName))

#BRES data source
dsname='resdatasource'

cd('/')
cmo.createJDBCSystemResource(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname)
cmo.setName(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
set('JNDINames',jarray.array([String('jdbc/bresdatasource')], String))

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname)
cmo.setUrl('jdbc:oracle:thin:@ldap://ldap:389/qaclms01,cn=OracleContext,dc=viant,dc=db')
cmo.setDriverName('oracle.jdbc.xa.client.OracleXADataSource')
cmo.setPassword(BRESUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCConnectionPoolParams/' + dsname)
#cmo.setInitSql('')
cmo.setTestTableName('SQL select 1 from dual')
cmo.setTestConnectionsOnReserve(true)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname)
cmo.createProperty('user')

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname + '/Pr                  operties/user')
cmo.setValue(BRESUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')

cd('/SystemResources/' + dsname)
set('Targets',jarray.array([ObjectName('com.bea:Name=sbrcluster1,Type=Cluster')], ObjectName))

#Claim Load Data Source
dsname='Claim Load Data Source'

cd('/')
cmo.createJDBCSystemResource(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname)
cmo.setName(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
set('JNDINames',jarray.array([String('claimloaddatasource')], String))

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname)
cmo.setUrl('jdbc:oracle:thin:@ldap://ldap:389/qaclms01,cn=OracleContext,dc=viant,dc=db')
cmo.setDriverName('oracle.jdbc.xa.client.OracleXADataSource')
cmo.setPassword(ClaimInquiryUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCConnectionPoolParams/' + dsname)
#cmo.setInitSql('')
cmo.setTestTableName('SQL select 1 from dual')
cmo.setTestConnectionsOnReserve(true)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname)
cmo.createProperty('user')

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname + '/Pr                  operties/user')
cmo.setValue(ClaimInquiryUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')

cd('/SystemResources/' + dsname)
set('Targets',jarray.array([ObjectName('com.bea:Name=sbrcluster1,Type=Cluster')], ObjectName))

#Fee Schedule Data Source
dsname='feesscheduledatasource'

cd('/')
cmo.createJDBCSystemResource(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname)
cmo.setName(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
set('JNDINames',jarray.array([String('feescheduledatasource')], String))

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname)
cmo.setUrl('jdbc:oracle:thin:@ldap://ldap:389/qafees01,cn=OracleContext,dc=viant,dc=db')
cmo.setDriverName('oracle.jdbc.xa.client.OracleXADataSource')
cmo.setPassword(FeesScheduleUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCConnectionPoolParams/' + dsname)
#cmo.setInitSql('')
cmo.setTestTableName('SQL select 1 from dual')
cmo.setTestConnectionsOnReserve(true)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname)
cmo.createProperty('user')

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname + '/Pr                  operties/user')
cmo.setValue(FeesScheduleUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')

cd('/SystemResources/' + dsname)
set('Targets',jarray.array([ObjectName('com.bea:Name=sbrcluster1,Type=Cluster')], ObjectName))

#Provider Data Source
dsname='Provider Data Source'

cd('/')
cmo.createJDBCSystemResource(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname)
cmo.setName(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
set('JNDINames',jarray.array([String('providerdatasource')], String))

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname)
cmo.setUrl('jdbc:oracle:thin:@ldap://ldap:389/qaprov01,cn=OracleContext,dc=viant,dc=db')
cmo.setDriverName('oracle.jdbc.xa.client.OracleXADataSource')
cmo.setPassword(ProviderUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCConnectionPoolParams/' + dsname)
#cmo.setInitSql('')
cmo.setTestTableName('SQL SELECT * FROM DUAL WHERE 1=2')
cmo.setTestConnectionsOnReserve(true)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname)
cmo.createProperty('user')

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname + '/Pr                  operties/user')
cmo.setValue(ProviderUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')

cd('/SystemResources/' + dsname)
set('Targets',jarray.array([ObjectName('com.bea:Name=sbrcluster1,Type=Cluster')], ObjectName))

#JACS Data Source
dsname='JACS Data Source'

cd('/')
cmo.createJDBCSystemResource(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname)
cmo.setName(dsname)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
set('JNDINames',jarray.array([String('jacssystem')], String))

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname)
cmo.setUrl('jdbc:oracle:thin:@ldap://ldap:389/dvjacs01,cn=OracleContext,dc=viant,dc=db')
cmo.setDriverName('oracle.jdbc.xa.client.OracleXADataSource')
cmo.setPassword(JACSUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCConnectionPoolParams/' + dsname)
#cmo.setInitSql('')
cmo.setTestTableName('SQL SELECT * FROM DUAL WHERE 1=2')
cmo.setTestConnectionsOnReserve(true)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname)
cmo.createProperty('user')

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDriverParams/' + dsname + '/Properties/' + dsname + '/Pr                  operties/user')
cmo.setValue(JACSUser)

cd('/JDBCSystemResources/' + dsname + '/JDBCResource/' + dsname + '/JDBCDataSourceParams/' + dsname)
cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')

cd('/SystemResources/' + dsname)
set('Targets',jarray.array([ObjectName('com.bea:Name=sbrcluster1,Type=Cluster')], ObjectName))

