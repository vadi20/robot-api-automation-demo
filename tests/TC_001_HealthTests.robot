*** Settings ***
Resource  ../objects/Common.robot

Documentation   This suite includes ping tests

*** Test Cases ***

Verify The API Health Using GET
    [Documentation]  Verify The API Health Using GET
    [Tags]  Smoke

    Create Session  PingByGet  ${TestEnvUrl}  verify=true

    ${response} =  GET On Session  PingByGet  ${pingEndPoint}
    Should Be Equal As Strings    ${response.status_code}    201
    
    ${responsePayload}=  convert to string   ${response.content}
    Should Contain    ${responsePayload}    Created

    ${server}=   Get From Dictionary    ${response.headers}    Server
    ${connection}=   Get From Dictionary    ${response.headers}    Connection
    ${contentType}=   Get From Dictionary    ${response.headers}    Content-Type

    Should Be Equal    ${server}    Cowboy
    Should Be Equal    ${connection}    keep-alive
    Should Be Equal    ${contentType}    text/plain; charset=utf-8


Verify The API Health Using Head
    [Documentation]  Verify The API Health Using Head
    [Tags]  Smoke

    Create Session  PingByHead  ${TestEnvUrl}  verify=true

    ${response} =  HEAD On Session  PingByHead  ${pingEndPoint}
    Should Be Equal As Strings    ${response.status_code}    201
    
