*** Settings ***
Resource  ../objects/Common.robot

Documentation     This suite includes bookings deletion tests

*** Test Cases ***

Verify Deletion of Booking
        [Documentation]      Deletes the booking
        [Tags]   Smoke
        ${token}=  Create Auth Token
        Set Suite Variable    ${token}          ${token}
        ${id}  Get Created Booking Id
        Set Suite Variable    ${id}          ${id}
    
        Log To Console  ${token}
        ${requestHeaders}=   Create Dictionary  Content-Type=application/json  Cookie=token=${token}
        Create Session    DeleteBooking    ${TestEnvUrl}   disable_warnings=1
        ${response}=  Delete On Session   DeleteBooking  ${bookingEndpoint}/${id}   headers=${requestHeaders}
        Log To Console  ${response.content}
        Should Be Equal As Strings    ${response.status_code}    201
        ${response_payload}=  Convert To String    ${response.content}
        Should Contain    ${response_payload}    Created
        Should Not Contain    ${response_payload}    ${firstname}
        Should Not Contain    ${response_payload}    ${lastname}