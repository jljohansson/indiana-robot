*** Settings ***
Documentation          HSS WellBeing
...

# Check openstack for Active VMs
# Ping tests to the SCs
# Ping tests to the VIPs
# Log in to SC
#   uptime on all nodes
#   ping tests from the VIPs to known destinations
#    
#   CLI
#     
# 
#
# vHSS-edge-vhss-fe-SC-1:~ # echo -e "show-table -r -m DIA-CFG-Conn -p connId,linkStatus,enabled,blockReason\nexit" | /opt/com/bin/cliss -s -b
# ManagedElement=vHSS-edge-vhss-fe,HSS-Function.applicationName=HSS_FUNCTION,DIA-CFG-Application.applicationName=DIA,DIA-CFG-StackContainer.stackContainerId=HSS_ESM,DIA-CFG-PeerNodeContainer.peerNodeContainerId=HSS_ESM,DIA-CFG-NeighbourNode.nodeId=rp-pcc-1-mme.elab.com\23HSS_ESM
# ============================================================================
# | connId                              | linkStatus | enabled | blockReason |
# ============================================================================
# | HSS_ESM\23rp-pcc...elab.com\23conn1 | Up         |    true | Not blocked |
# ============================================================================
# vHSS-edge-vhss-fe-SC-1:~ # 

# No non-Up links on HSS:
# 
#vHSS-edge-vhss-fe-SC-1:~ # echo -e "show-table -r -m DIA-CFG-Conn -c linkStatus <> Up\nexit" | /opt/com/bin/cliss -s -b
# vHSS-edge-vhss-fe-SC-1:~ # 

# vHSS-edge-vhss-fe-SC-1:~ # echo -e "width 200\nshow-table -r -m FmAlarm -p additionalText,specificProblem\nexit" | /opt/com/bin/cliss -s -b
# set width 200
# ManagedElement=vHSS-edge-vhss-fe,SystemFunctions=1,Fm=1
# ======================================================================================================================================================
# | additionalText                                                                                                | specificProblem                    |
# ======================================================================================================================================================
# | Association ID: 1 Path Inactive: ULP key: 16777217, Remote Address: 10.97.98.143, Local Address: 10.97.111.23 | SS7 CAF Sctp IP Path Is Down       |
# | Association ID: 1 Path Inactive: ULP key: 16777217, Remote Address: 10.97.98.144, Local Address: 10.97.111.23 | SS7 CAF Sctp IP Path Is Down       |
# | Detailed Information: Own Node disabled by OAM, IRP Cause: 14                                                 | vDicos, Diameter Own Node Disabled |
# | Detailed Information: Own Node disabled by OAM, IRP Cause: 14                                                 | vDicos, Diameter Own Node Disabled |
# ======================================================================================================================================================
# vHSS-edge-vhss-fe-SC-1:~ # 
#
# vHSS-edge-vhss-fe-SC-1:~ # echo -e "show-table -r -m FmAlarm -p activeSeverity,additionalText,specificProblem -c activeSeverity = CRITICAL\nexit" | /opt/com/bin/cliss -s -b
# vHSS-edge-vhss-fe-SC-1:~ # 
#vHSS-edge-vhss-fe >show -v ManagedElement=vHSS-edge-vhss-fe,Transport=1,Evip=1,EvipAlbs=1,EvipAlb=ln_sig_sc,state
#state="ACTIVE" <read-only>
# #vHSS-edge-vhss-fe >
# vHSS-edge-vhss-fe-SC-1:~ # echo -e "width 200\nManagedElement=vHSS-edge-vhss-fe,Transport=1,Evip=1,EvipAlbs=1,EvipAlb=ln_sig_sc,EvipVips=1\nshow-table -m EvipVip\nexit" | /opt/com/bin/cliss -s -b
# set width 200
# =================================================================================================
# | evipVipId                            | deflt | equivSrcAddr | autoActivate | state  | address |
# =================================================================================================
# | 10.133.159.160                       |       | 0            | 1            | ACTIVE |         |
# | 10.97.111.22                         |       | 0            | 1            | ACTIVE |         |
# | 10.97.111.23                         |       | 0            | 1            | ACTIVE |         |
# | 10.97.111.24                         |       | 0            | 1            | ACTIVE |         |
# | 2001:1b70:82c8:8000:ffff:ffff:f004:1 |       | 0            | 1            | ACTIVE |         |
# | 2001:1b70:82c8:8000:ffff:ffff:f005:1 |       | 0            | 1            | ACTIVE |         |
# | 2001:1b70:82c8:8000:ffff:ffff:f006:1 |       | 0            | 1            | ACTIVE |         |
# | 2001:1b70:82c8:8000:ffff:ffff:f007:1 |       | 0            | 1            | ACTIVE |         |
# =================================================================================================
# vHSS-edge-vhss-fe-SC-1:~ # 



Library                Process
Library                SSHLibrary
Library                String
#Suite Setup            Connect To iDRAC And Get Stuff
#Suite Teardown         Close All Connections
#Force Tags             idrac  dell  healthcheck


*** Variables ***
${SC-1_IP}   10.97.108.2
${SC-2_IP}   10.97.108.3
${VIP_OM}    10.97.111.16
${VIP_LDAP}  10.97.111.20
${VIP_DIA}   10.97.111.21   # not used
${VIP_SIG1}  10.97.111.22
${VIP_SIG2}  10.97.111.23
${VIP_SIG3}  10.97.111.24   # not used

*** Test Cases ***

Ping test to the SCs
    [Tags]  external
    ${result} =     Run Process   ping ${SC-1_IP} -c 1   shell=True
    Log     ${result.stdout}
    Should Be Equal As Integers	${result.rc}  0       msg=SC-1 (${SC-1_IP}) did not respond to ping
    ${result} =     Run Process   ping ${SC-2_IP} -c 1   shell=True
    Log     ${result.stdout}
    Should Be Equal As Integers	${result.rc}  0       msg=SC-2 (${SC-2_IP}) did not respond to ping


Ping test to the OM VIP
    [Tags]  external
    ${result} =     Run Process   ping ${VIP_OM} -c 1   shell=True
    Log     ${result.stdout}
    Should Be Equal As Integers	${result.rc}  0       msg=OM VIP (${VIP_OM}) did not respond to ping

Ping test to the LDAP VIP
    [Tags]  external
    ${result} =     Run Process   ping ${VIP_LDAP} -c 1   shell=True
    Log     ${result.stdout}
    Should Be Equal As Integers	${result.rc}  0       msg=LDAP VIP (${VIP_LDAP}) did not respond to ping

#Ping test to the DIA VIP
#    [Tags]  external
#    ${result} =     Run Process   ping ${VIP_DIA} -c 1   shell=True
#    Log     ${result.stdout}
#    Should Be Equal As Integers	${result.rc}  0       msg=DIA VIP (${VIP_DIA}) did not respond to ping

Ping test to the SIG VIPs
    [Tags]  external
    ${result} =     Run Process   ping ${VIP_SIG1} -c 1   shell=True
    Log     ${result.stdout}
    Should Be Equal As Integers	${result.rc}  0       msg=SIG VIP (${VIP_SIG1}) did not respond to ping
    ${result} =     Run Process   ping ${VIP_SIG2} -c 1   shell=True
    Log     ${result.stdout}
    Should Be Equal As Integers	${result.rc}  0       msg=SIG VIP (${VIP_SIG2}) did not respond to ping
#    ${result} =     Run Process   ping ${VIP_SIG3} -c 1   shell=True
#    Log     ${result.stdout}
#    Should Be Equal As Integers	${result.rc}  0       msg=SIG VIP (${VIP_SIG3}) did not respond to ping


*** Keywords ***
Connect To iDRAC And Get Stuff
  Open Connection    ${HOST}    port=22  timeout=30  alias=racadm
  Login              ${RACADM_USERNAME}  ${RACADM_PASSWORD}
  Write              racadm
  ${output}=         Read Until   racadm>>

  Write                 getsysinfo -d
  ${output}=            Read Until       racadm>>
  Set Suite Variable    ${getsysinfo-d}    ${output}

  Write                 getsysinfo -c
  ${output}=            Read Until       racadm>>
  Set Suite Variable    ${getsysinfo-c}    ${output}

  Write                 getsysinfo -s
  ${output}=            Read Until       racadm>>
  Set Suite Variable    ${getsysinfo-s}    ${output}

  Write                 getsysinfo -w
  ${output}=            Read Until       racadm>>
  Set Suite Variable    ${getsysinfo-w}    ${output}

  Write                 getsysinfo -t
  ${output}=            Read Until       racadm>>
  Set Suite Variable    ${getsysinfo-t}    ${output}

