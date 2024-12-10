*** Settings ***
Resource  ../objects/Common.robot

Documentation     This suite includes bookings updates tests

*** Variables ***
${newFirstName}   newUserApi
${newLastName}    newLastName

*** Test Cases ***

Verify The Updation Of A Booking
        [Documentation]      Verify The Updation Of A Booking
        [Tags]   Smoke
        ${token}=  Create Auth token
        Set Suite Variable    ${token}          ${token}
        ${id}=  Get Created Booking Id
        Set Suite Variable    ${id}          ${id}

        ${checkin}          Get Current Date
        ${checkout}         Get Future Date

        ${bookingDates}=  Create Dictionary
...                       checkin= ${checkin}
...                       checkout= ${checkout}

        ${requestPayload}=   Create Dictionary
...                           firstname=${newFirstName}
...                           lastname=${newLastName}
...                           totalprice= 789
...                           depositpaid=true
...                           bookingdates=${bookingDates}
...                           additionalneeds=Lunch

        ${requestHeaders}=   Create Dictionary  Content-Type=application/json  Cookie=token=${token}
        Create Session    updateBooking    ${TestEnvUrl}   disable_warnings=1
        ${response}=  Put On Session   updateBooking  ${bookingEndpoint}/${id}  json=${requestPayload}  headers=${requestHeaders}
        Log To Console  ${response.content}
        Should Be Equal As Strings    ${response.status_code}    200

        Verify value in JSON    ${response}  firstname   ${newFirstName}
        Verify value in JSON    ${response}  lastname   ${newLastName}
        Verify value in JSON    ${response}  bookingdates.checkin   ${checkin}
        Verify value in JSON    ${response}  bookingdates.checkout   ${checkout}
        Verify value in JSON    ${response}  additionalneeds   Lunch

        ${response_payload}=  Convert To String    ${response.content}
        Should Not Contain    ${response_payload}    ${firstName}
        Should Not Contain    ${response_payload}    ${lastName}

Verify Partial Updates To Bookings
        [Documentation]      Verify Partial Updates To Bookings
        [Tags]   Smoke

        ${checkin}          Get Current Date
        ${checkout}         Get Future Date


        ${request_payload}=   Create Dictionary
...                           firstname=${firstname}
...                           lastname=${lastname}


        ${requestHeaders}=   Create Dictionary  Content-Type=application/json  Cookie=token=${token}
        Create Session    partialUpdate    ${TestEnvUrl}   disable_warnings=1
        ${response}=  Patch On Session   partialUpdate  ${bookingEndpoint}/${id}  json=${request_payload}  headers=${requestHeaders}
        Log To Console  ${response.content}
        Should Be Equal As Strings    ${response.status_code}    200

        Verify value in JSON    ${response}  firstname   ${firstname}
        Verify value in JSON    ${response}  lastname   ${lastname}
        Verify value in JSON    ${response}  bookingdates.checkin   ${checkin}
        Verify value in JSON    ${response}  bookingdates.checkout   ${checkout}
        Verify value in JSON    ${response}  additionalneeds   Lunch

        ${response_payload}=  Convert To String    ${response.content}
        Should Not Contain    ${response_payload}    ${newFirstName}
        Should Not Contain    ${response_payload}    ${newLastName}