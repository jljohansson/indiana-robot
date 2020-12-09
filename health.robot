*** Settings ***
Documentation          iDRAC
...


Library                SSHLibrary
Library                String
Suite Setup            Connect To iDRAC And Get Stuff
Suite Teardown         Close All Connections
Force Tags             idrac  dell  healthcheck


*** Variables ***
${RACADM_USERNAME}        root
${RACADM_PASSWORD}        calvin


*** Test Cases ***

Check Power State
  [Documentation]      We want Powered-On Servers
  [Tags]             noncritical
  Log                ${getsysinfo-s}
  ${output}=         Replace String   ${getsysinfo-s}    ${space}   ${empty}
  Should Contain     ${output}        PowerStatus=ON         msg=Failure!    values=False

Check Thermals
  [Documentation]    Less than 40C is OK for us
  [Tags]             noncritical
  Log                ${getsysinfo-t}
# System Thermal Information:
# EstimatedSystemAirflow  =  30 CFM 
# EstimatedExhaustTemperature =  37 Degrees Centigrade
  ${val}=          Get Lines Containing String   ${getsysinfo-t}   EstimatedExhaustTemperature
  ${val}=          Fetch From Right    ${val.strip()}    =
  ${val}=          Fetch From Left     ${val.strip()}    ${SPACE}
  ${temperature}=  Convert To Number   ${val.strip()}
  Should Be True   ${temperature} < 40       msg=Running HOT (${temperature}C)


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

