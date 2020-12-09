*** Settings ***
Documentation          UDM HealthCheck
...

Library                RequestsLibrary
Library                JSONLibrary
Suite Setup            
Suite Teardown         


*** Variables ***
${NRF}            http://10.97.111.65:80
${UDR}            http://10.97.111.149:81
${UDM}            http://10.97.111.149:82
${IMSI}           240800000100001


*** Test Cases ***


Ask NRF for serving AUSF for ${IMSI}
  [Documentation]   As AMF
  Create Session      nrf             ${NRF}
  ${resp}=            Get Request     nrf        /nnrf-disc/v1/nf-instances?service-names=nausf-auth&target-nf-type=AUSF&requester-nf-type=AMF&supi=imsi-${IMSI}
  Status Should Be    200             ${resp}    msg=Response was not 200
  ${nfType}=          Get Value From Json   ${resp.json()}   $..nfInstances[0].nfType
  Should Be Equal     ${nfType[0]}          AUSF
  ${nfStatus}=        Get Value From Json   ${resp.json()}   $..nfInstances[0].nfStatus
  Should Be Equal     ${nfStatus[0]}        REGISTERED


# Ask NRF for serving UDM (nudm-sdm) for ${IMSI}
#   [Documentation]   As AMF
#   Create Session                 ${NRF}
#   GET                                 /nnrf-disc/v1/nf-instances?service-names=nudm-sdm&target-nf-type=UDM&requester-nf-type=AMF&supi=imsi-${IMSI}
#   Response Status Code Should Equal   200
#   ${body}=                            Get Response Body
#   Log                                 ${body}
#   Json Value Should Equal	            ${body}   /nfInstances/0/nfType     "UDM"
#   Json Value Should Equal	            ${body}   /nfInstances/0/nfStatus   "REGISTERED"


# Ask UDM for NSSAI for ${IMSI}
#   [Documentation]
#   Create Session                 ${UDM}
#   GET                                 /nudm-sdm/v2/imsi-${IMSI}/nssai
#   Response Status Code Should Equal   200
#   Log Response Body
#   Response Body Should Contain        defaultSingleNssais

# Ask UDR for auth-sub for ${IMSI}
#   [Documentation]
#   Create Session                 ${UDR}
#   GET                                 /nudr-dr/v2/subscription-data/imsi-${IMSI}/authentication-data/authentication-subscription
#   Response Status Code Should Equal   200
#   Log Response Body
#   Response Body Should Contain        encPermanentKey


# Check NRF nfServiceStatus for NRF
#   [Tags]   critical
#   Check NRF nfServiceStatus        ${NRF}   NRF      REGISTERED

# Check NRF nfServiceStatus for AMF
#   [Tags]   critical
#   Check NRF nfServiceStatus        ${NRF}   AMF      REGISTERED

# Check NRF nfServiceStatus for SMF
#   [Tags]   critical
#   Check NRF nfServiceStatus        ${NRF}   SMF      REGISTERED

# Check NRF nfServiceStatus for PCF
#   [Tags]   noncritical
#   Check NRF nfServiceStatus        ${NRF}   PCF      REGISTERED

# Check NRF nfServiceStatus for AUSF
#   [Tags]   critical
#   Check NRF nfServiceStatus        ${NRF}   AUSF     REGISTERED

# Check NRF nfServiceStatus for UDR
#   [Tags]   critical
#   Check NRF nfServiceStatus        ${NRF}   UDR      REGISTERED

# Check NRF nfServiceStatus for UDM
#   [Tags]   critical
#   Check NRF nfServiceStatus        ${NRF}   UDM      REGISTERED

# Check NRF nfServiceStatus for NSSF
#   [Tags]   critical
#   Check NRF nfServiceStatus        ${NRF}   NSSF      REGISTERED

# Check NRF nfServiceStatus for NEF
#   [Tags]   noncritical
#   Check NRF nfServiceStatus        ${NRF}   NEF      REGISTERED


*** Keywords ****

# Check NRF nfServiceStatus
#   [Arguments]                         ${NRF}    ${NF}     ${REGSTATE}
#   Create Session                 ${NRF}
#   GET                                 /nnrf-nfm/v1/nf-instances?nf-type=${NF}
#   Response Status Code Should Equal  200
#   Log Response Body 
#   ${body}=                           Get Response Body
#   Json Value Should Not Equal	       ${body}           /_links/item      []
#   ${url}=	                           Get Json Value    ${body}   /_links/item/0/href
#   ${url}=   Evaluate                 ${url}.replace('"','')
#   ${junk}   ${keep}=	               Split String      ${url}    /   1
#   ${junk}   ${keep}=	               Split String      ${keep}   /   1
#   ${junk}   ${path}=	               Split String      ${keep}   /   1
#   ${url}=                            Set Variable      \/${path}
#   Log                                ${url}
#   GET                                ${url}
#   Response Status Code Should Equal  200
#   Log Response Body
#   ${body}=                            Get Response Body
#   Json Value Should Equal	            ${body}   /nfStatus                      "${REGSTATE}"
#   Json Value Should Equal	            ${body}   /nfServices/0/nfServiceStatus  "${REGSTATE}"


######################
# SAMPLES
######################

# Ask NRF for serving AUSF
# ejojmjn@ejojmjn-dev:~/dallas-testing[:]$ curl 'http://10.97.111.149:80/nnrf-disc/v1/nf-instances?service-names=nausf-auth&target-nf-type=AUSF&requester-nf-type=AMF&supi=imsi-240800000100001' | jq .
# {
#   "validityPeriod": 86400,
#   "nfInstances": [
#     {
#       "nfInstanceId": "0c765084-9cc5-49c6-9876-ae2f5fa2a63f",
#       "nfType": "AUSF",
#       "nfStatus": "REGISTERED",
#       "plmnList": [
#         {
#           "mnc": "80",
#           "mcc": "240"
#         }
#       ],
#       "priority": 0,
#       "capacity": 1000,
#       "locality": "SH",
#       "fqdn": "10.97.111.149",
#       "ausfInfo": {
#         "groupId": "groupid-000001",
#         "routingIndicators": [
#           "0"
#         ],
#         "supiRanges": [
#           {
#             "start": "100000000000001",
#             "end": "999999999999999"
#           }
#         ]
#       },
#       "nfServices": [
#         {
#           "serviceInstanceId": "nausf-auth-01",
#           "serviceName": "nausf-auth",
#           "versions": [
#             {
#               "apiFullVersion": "1.R15.1.1",
#               "apiVersionInUri": "v1"
#             }
#           ],
#           "scheme": "http",
#           "nfServiceStatus": "REGISTERED",
#           "capacity": 100,
#           "ipEndPoints": [
#             {
#               "ipv4Address": "10.97.111.149",
#               "port": 84
#             }
#           ],
#           "fqdn": "10.97.111.149"
#         }
#       ]
#     }
#   ]
# }
# ejojmjn@ejojmjn-dev:~/dallas-testing[:]$ 

# Ask NRF for serving UDM
# ejojmjn@ejojmjn-dev:~/dallas-testing[:]$ curl 'http://10.97.111.149:80/nnrf-disc/v1/nf-instances?service-names=nudm-sdm&target-nf-type=UDM&requester-nf-type=AMF&supi=imsi-240800000100001' | jq .
# {
#   "validityPeriod": 86400,
#   "nfInstances": [
#     {
#       "nfInstanceId": "2c765011-3cc5-49c6-9876-ae2f5fa2a63f",
#       "nfType": "UDM",
#       "nfStatus": "REGISTERED",
#       "plmnList": [
#         {
#           "mnc": "80",
#           "mcc": "240"
#         }
#       ],
#       "sNssais": [
#         {
#           "sst": 1,
#           "sd": "000001"
#         },
#         {
#           "sst": 1,
#           "sd": "000002"
#         }
#       ],
#       "ipv4Addresses": [
#         "10.97.111.149"
#       ],
#       "priority": 0,
#       "capacity": 1000,
#       "locality": "SH",
#       "udmInfo": {
#         "supiRanges": [
#           {
#             "start": "240800000000000",
#             "end": "240810000000000"
#           }
#         ],
#         "gpsiRanges": [
#           {
#             "start": "100000000000001",
#             "end": "999999999999999"
#           }
#         ],
#         "groupId": "groupid-000001",
#         "routingIndicators": [
#           "0"
#         ]
#       },
#       "nfServices": [
#         {
#           "serviceInstanceId": "nudm-sdm",
#           "serviceName": "nudm-sdm",
#           "versions": [
#             {
#               "expiry": "2030-07-06T02:54:32Z",
#               "apiFullVersion": "1.R15.1.1",
#               "apiVersionInUri": "v2"
#             }
#           ],
#           "scheme": "http",
#           "nfServiceStatus": "REGISTERED",
#           "ipEndPoints": [
#             {
#               "ipv4Address": "10.97.111.149",
#               "port": 82,
#               "transport": "TCP"
#             }
#           ],
#           "fqdn": "10.97.111.149"
#         }
#       ]
#     }
#   ]
# }
# ejojmjn@ejojmjn-dev:~/dallas-testing[:]$ 

# Ask UDM for NSSAI
# ejojmjn@ejojmjn-dev:~/dallas-testing[:]$ curl 'http://10.97.111.149:82/nudm-sdm/v2/imsi-240800000100001/nssai'  | jq .
# {
#   "defaultSingleNssais": [
#     {
#       "sst": 1,
#       "sd": "000001"
#     }
#   ],
#   "singleNssais": [
#     {
#       "sst": 1,
#       "sd": "000002"
#     }
#   ]
# }
# ejojmjn@ejojmjn-dev:~/dallas-testing[:]$ 

# Ask UDR for Auth-sub
# ejojmjn@ejojmjn-dev:~/dallas-testing[:]$ curl 'http://10.97.111.149:81/nudr-dr/v2/subscription-data/imsi-240800000100001/authentication-data/authentication-subscription' | jq .
# {
#   "authenticationMethod": "5G_AKA",
#   "encPermanentKey": "956dcf02d4956eb998866132253104e8",
#   "protectionParameterId": "2$2",
#   "sequenceNumber": {
#     "sqnScheme": "NON_TIME_BASED",
#     "sqn": "000000000040",
#     "lastIndexes": {
#       "ausf": 25
#     }
#   },
#   "authenticationManagementField": "725C",
#   "algorithmId": "2"
# }
# ejojmjn@ejojmjn-dev:~/dallas-testing[:]$ 

# ejojmjn@ejojmjn-dev:~/dallas-testing[:]$ curl -s http://10.97.111.149:80/nnrf-nfm/v1/nf-instances?nf-type=UDR | jq .
# {
#   "_links": {
#     "self": {
#       "href": "http://10.97.111.149:80/nnrf-nfm/v1/nf-instances"
#     },
#     "item": [
#       {
#         "href": "http://10.97.111.149:80/nnrf-nfm/v1/nf-instances/f8b5865c-49e8-463e-8f16-4dd6a15d3f41"
#       }
#     ]
#   }
# }
# ejojmjn@ejojmjn-dev:~/dallas-testing[:]$ curl http://10.97.111.149:80/nnrf-nfm/v1/nf-instances/f8b5865c-49e8-463e-8f16-4dd6a15d3f41 | jq .
# {
#   "nfInstanceId": "f8b5865c-49e8-463e-8f16-4dd6a15d3f41",
#   "nfType": "UDR",
#   "nfStatus": "REGISTERED",
#   "sNssais": [
#     {
#       "sst": 1,
#       "sd": "000001"
#     }
#   ],
#   "fqdn": "10.97.111.149",
#   "ipv4Addresses": [
#     "10.97.111.149"
#   ],
#   "nfServices": [
#     {
#       "serviceInstanceId": "nudr-dr",
#       "serviceName": "nudr-dr",
#       "versions": [
#         {
#           "apiFullVersion": "1.PreR15.0.0",
#           "apiVersionInUri": "v2"
#         }
#       ],
#       "scheme": "http",
#       "nfServiceStatus": "REGISTERED",
#       "fqdn": "10.97.111.149",
#       "allowedNfTypes": [
#         "UDM",
#         "AMF",
#         "SMF",
#         "AUSF",
#         "NEF",
#         "PCF",
#         "SMSF",
#         "NSSF",
#         "UDR",
#         "LMF",
#         "GMLC",
#         "5G_EIR",
#         "SEPP",
#         "UPF",
#         "N3IWF",
#         "AF",
#         "UDSF",
#         "BSF",
#         "CHF",
#         "NWDAF"
#       ],
#       "ipEndPoints": [
#         {
#           "ipv4Address": "10.97.111.149",
#           "port": 81,
#           "transport": "TCP"
#         }
#       ]
#     }
#   ]
# }
# ejojmjn@ejojmjn-dev:~/dallas-testing[:]$
