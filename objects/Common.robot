*** Settings ***
Resource   ../configs/EnvDetails.robot
Resource   ../configs/AppilicationVariables.robot

Library    Custom.py
Library    String
Library    Collections
Library    RequestsLibrary
Library    JSONLibrary


*** Keywords ***
Should Be Larger Than
    [Arguments]    ${value_1}    ${value_2}
    Run Keyword If    ${value_1} < ${value_2}    
    ...    Fail    The value ${value_1} is not larger than ${value_2}

Get Data From JSON
    [Arguments]     ${response}   ${jsonPath}
    ${json_response}  Set Variable  ${response.json()}
    ${value}  Get Value From Json  ${json_response}  ${jsonPath}
    RETURN  ${value[0]}

Verify Value In JSON
    [Arguments]     ${response}   ${jsonPath}  ${expectedValue}
    ${actualValue}   Get Data From JSON  ${response}  ${jsonPath}
    ${actualValueNew}    Convert To String    ${actualValue}
    Should Be Equal    ${actualValue}    ${expectedValue}

Get Multiple Booking Details by Id
    [Arguments]    ${id}
    Create Session  all_bookings  ${TestEnvUrl}  verify=true
    ${response}=  GET On Session  all_bookings  ${bookingEndpoint}/${id}
    Should Be Equal As Strings    ${response.status_code}    200

Create Auth Token
    Create Session    getToken    ${TestEnvUrl}   disable_warnings=1
    ${headers}=   Create Dictionary   Content-Type=application/json  User-Agent=RobotFrameworkApiDemo
    ${requestPayload}  Create Dictionary   username=${username}   password=${validPassword}
    ${response}=  Post On Session   getToken  ${authEndpoint}   json=${requestPayload}  headers=${headers}
    ${token}=           Get From Dictionary     ${response.json()}      token
    RETURN  ${token}

Get Created Booking Id
        ${checkin}          Get Current Date
        ${checkout}         Get Future Date

        ${bookingDates}=  Create Dictionary
...                       checkin= ${checkin}
...                       checkout= ${checkout}

        ${requestPayload}=   Create Dictionary
...                           firstname= ${firstName}
...                           lastname= ${lastName}
...                           totalprice= 789
...                           depositpaid=true
...                           bookingdates=${bookingDates}
...                           additionalneeds= Breakfast

        Create Session    AddBooking    ${TestEnvUrl}   disable_warnings=1
        ${response}=  Post On Session   AddBooking  ${bookingEndpoint}  json=${requestPayload}
        ${id}=   Get Data From JSON  ${response}  bookingid
        RETURN   ${id}