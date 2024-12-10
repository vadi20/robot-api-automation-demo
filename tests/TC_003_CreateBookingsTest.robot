*** Settings ***
Resource  ../objects/Common.robot


Documentation   This suite includes bookings creations tests

*** Test Cases ***

Create a New Booking
        [Documentation]      Creates new booking
        [Tags]   Smoke

        ${checkin}          Get Current Date
        Set Suite Variable    ${checkin}     ${checkin}
        ${checkout}         Get Future Date
        Set Global Variable    ${checkout}     ${checkout}

        ${bookingDates}=  Create Dictionary
...                       checkin= ${checkin}
...                       checkout= ${checkout}

        ${requestPayload}=   Create Dictionary
...                           firstname= ${firstname}
...                           lastname= ${lastname}
...                           totalprice= 789
...                           depositpaid=true
...                           bookingdates=${bookingDates}
...                           additionalneeds= Breakfast

        Create Session    AddNewBooking    ${TestEnvUrl}   disable_warnings=1
        ${response}=  Post On Session   AddNewBooking  ${bookingEndpoint}  json=${requestPayload}
        Log   ${response.content}
        Should Be Equal As Strings    ${response.status_code}    200
        ${tempNewBookingId}=   Get Data From JSON  ${response}  bookingid

        Log To Console   Newly created booking id is: ${tempNewBookingId}
        Set Global Variable    ${newBookingId}   ${tempNewBookingId}
        Verify value in JSON    ${response}  booking.firstname   ${firstname}
        Verify value in JSON    ${response}  booking.lastname   ${lastname}
        Verify value in JSON    ${response}  booking.bookingdates.checkin   ${checkin}
        Verify value in JSON    ${response}  booking.bookingdates.checkout   ${checkout}

        

Get Multiple Booking details 
        [Template]  Get Multiple Booking Details by Id
        ${newBookingId}


Verify New Bookings Created By Id
        [Documentation]  Verify New Bookings Created By Id
        [Tags]  Smoke
           
        Create Session    getNewBookingById    ${TestEnvUrl}  verify=true  disable_warnings=true
        ${response}=  GET On Session   getNewBookingById   ${bookingEndpoint}/${newBookingId}
        Should Be Equal As Strings    ${response.status_code}    200

        Verify value in JSON    ${response}  firstname   ${firstname}
        Verify value in JSON    ${response}  lastname   ${lastname}
        Verify value in JSON    ${response}  bookingdates.checkin   ${checkin}
        Verify value in JSON    ${response}  bookingdates.checkout   ${checkout}

Verify New Bookings Created By Name
        [Documentation]     Verify New Bookings Created By Name
        [Tags]   Regression
        
        ${counter}  Set Variable    ${0}
        ${query_params}=  Create Dictionary  firstname=${firstname}
        Create Session    getNewBookingByName    ${TestEnvUrl}   disable_warnings=1
        ${response}=  Get On Session   getNewBookingByName  ${bookingEndpoint}  params=${query_params}
        Should Be Equal As Strings    ${response.status_code}    200
        @{bookingIds}=   Create List
        FOR    ${element}    IN    @{response.json()}
            Insert Into List    ${bookingIds}    ${counter}    ${element}[bookingid]
            ${counter}=   Set Variable    ${counter+1}
        END
        List Should Contain Value    ${bookingIds}    ${newBookingId}

Verify New Bookings Created By Checkin
        [Documentation]      Verify New Bookings Created By Checkin
        [Tags]   Regression
        
        ${query_params}=  Create Dictionary  checkin=${checkin}
        Create Session    getNewBookingByCheckin    ${TestEnvUrl}   disable_warnings=1
        ${response}=  Get On Session   getNewBookingByCheckin  ${bookingEndpoint}  params=${query_params}
        Should Be Equal As Strings    ${response.status_code}    200
