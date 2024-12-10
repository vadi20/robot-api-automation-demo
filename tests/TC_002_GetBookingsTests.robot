*** Settings ***
Resource  ../objects/Common.robot

Documentation   This suite includes getting bookings tests


*** Test Cases ***

Get All Bookings
    [Documentation]   Get All Bookings
    [Tags]  Smoke

    Create Session  GetAllBookings  ${TestEnvUrl}  verify=true
    ${response}=  GET On Session  GetAllBookings  ${bookingEndpoint}

    ${counter}    Set Variable    ${0}
    @{tempBookingIds} =   Create List
    FOR    ${element}    IN    @{response.json()}
        Insert Into List    ${tempBookingIds}    ${counter}    ${element}[bookingid]
        ${counter}=  Set Variable    ${counter+1}
    END

    ${tempFirstBookingId}=    Get From List    ${tempBookingIds}    0
    ${tempLastBookingId}=    Get From List    ${tempBookingIds}    ${counter-1}

    Set Suite Variable    ${firstBookingId}     ${tempFirstBookingId}
    Set Suite Variable    ${lastBookingId}     ${tempLastBookingId}

    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Larger Than  ${counter}  ${1}


Get Booking Details by Id
    [Documentation]   Get Booking Details by Id
    [Tags]  Smoke

    Create Session  GetBookingsById  ${TestEnvUrl}  verify=true
    ${response}=  GET On Session  GetBookingsById  ${bookingEndpoint}/${firstBookingId}

    Should Be Equal As Strings    ${response.status_code}    200

    ${temp_firstName}=  Get Data From JSON  ${response}  firstname
    ${temp_lastName}=  Get Data From JSON  ${response}  lastname
    ${temp_checkinDate}=  Get Data From JSON  ${response}  bookingdates.checkin
    ${temp_checkoutDate}=  Get Data From JSON  ${response}  bookingdates.checkout
    Set Suite Variable    ${firstName}     ${temp_firstName}
    Set Suite Variable    ${lastName}     ${temp_lastName}
    Set Suite Variable    ${checkinDate}     ${temp_checkinDate}
    Set Suite Variable    ${checkoutDate}     ${temp_checkoutDate}

Get Multiple Booking details 
    [Template]  Get Multiple Booking Details by Id
    ${firstBookingId}
    ${lastBookingId}

Get All Bookings By First Name
    [Documentation]   Get All Bookings By First Name
    [Tags]  Regression

    ${queryParams}    Create Dictionary    firstname=${firstName}
    Create Session    GetAllBookingsByFirstname    ${TestEnvUrl}    disable_warnings=1
    ${response}=  Get On Session    GetAllBookingsByFirstname    ${bookingEndpoint}    params=${queryParams} 

    ${counter}    Set Variable    ${1}
    @{tempBookingIds} =   Create List
    FOR    ${element}    IN    @{response.json()}
        Insert Into List    ${tempBookingIds}    ${counter}    ${element}[bookingid]
        ${counter}=  Set Variable    ${counter+1}
    END

    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Larger Than  ${counter}  ${1}

Get All Bookings By Last Name
    [Documentation]   Get All Bookings By Last Name
    [Tags]  Regression

    ${queryParams}    Create Dictionary    lastname=${lastname}
    Create Session    GetAllBookingsByLastname    ${TestEnvUrl}    disable_warnings=1
    ${response}=  Get On Session    GetAllBookingsByLastname    ${bookingEndpoint}    params=${queryParams} 

    ${counter}    Set Variable    ${1}
    @{tempBookingIds} =   Create List
    FOR    ${element}    IN    @{response.json()}
        Insert Into List    ${tempBookingIds}    ${counter}    ${element}[bookingid]
        ${counter}=  Set Variable    ${counter+1}
    END

    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Larger Than  ${counter}  ${1}

Get All Bookings By First Name And Last Name
    [Documentation]   Get All Bookings By First Name And Last Name
    [Tags]  Regression

    ${queryParams}    Create Dictionary    firstname=${firstName}    lastname=${lastName}
    Create Session    GetAllBookingsByFirstLastname    ${TestEnvUrl}    disable_warnings=1
    ${response}=  Get On Session    GetAllBookingsByFirstLastname    ${bookingEndpoint}    params=${queryParams} 

    ${counter}    Set Variable    ${1}
    @{tempBookingIds} =   Create List
    FOR    ${element}    IN    @{response.json()}
        Insert Into List    ${tempBookingIds}    ${counter}    ${element}[bookingid]
        ${counter}=  Set Variable    ${counter+1}
    END

    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Larger Than  ${counter}  ${1}


Get All Bookings By Checkin
    [Documentation]   Get All Bookings By Checkin
    [Tags]  Regression

    ${queryParams}    Create Dictionary    checkin=${checkinDate}
    Create Session    GetAllBookingsByCheckin    ${TestEnvUrl}    disable_warnings=1
    ${response}=  Get On Session    GetAllBookingsByCheckin    ${bookingEndpoint}    params=${queryParams} 

    ${counter}    Set Variable    ${1}
    @{tempBookingIds} =   Create List
    FOR    ${element}    IN    @{response.json()}
        Insert Into List    ${tempBookingIds}    ${counter}    ${element}[bookingid]
        ${counter}=  Set Variable    ${counter+1}
    END

    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Larger Than  ${counter}  ${1}

Get All Bookings By Checkout
    [Documentation]   Get All Bookings By Checkout
    [Tags]  Regression

    ${queryParams}    Create Dictionary    checkout=${checkoutDate}
    Create Session    GetAllBookingsByCheckout    ${TestEnvUrl}    disable_warnings=1
    ${response}=  Get On Session    GetAllBookingsByCheckout    ${bookingEndpoint}    params=${queryParams} 

    ${counter}    Set Variable    ${1}
    @{tempBookingIds} =   Create List
    FOR    ${element}    IN    @{response.json()}
        Insert Into List    ${tempBookingIds}    ${counter}    ${element}[bookingid]
        ${counter}=  Set Variable    ${counter+1}
    END

    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Larger Than  ${counter}  ${1}


Get All Bookings By Checkin And Checkout
    [Documentation]   Get All Bookings By Checkin And Checkout
    [Tags]  Regression

    ${queryParams}    Create Dictionary    checkin=${checkinDate}    checkout=${checkoutDate}
    Create Session    GetAllBookingsByCheckinCheckout    ${TestEnvUrl}    disable_warnings=1
    ${response}=  Get On Session    GetAllBookingsByCheckinCheckout    ${bookingEndpoint}    params=${queryParams} 

    ${counter}    Set Variable    ${1}
    @{tempBookingIds} =   Create List
    FOR    ${element}    IN    @{response.json()}
        Insert Into List    ${tempBookingIds}    ${counter}    ${element}[bookingid]
        ${counter}=  Set Variable    ${counter+1}
    END

    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Larger Than  ${counter}  ${1}


Get Non Available Booking Details by Id
    [Documentation]   Get Non Available Booking Details by Id
    [Tags]  Regression

    Create Session  GetMultipleBookings  ${TestEnvUrl}  disable_warnings=1  
    ${response}=  Run Keyword And Expect Error  *   GET On Session  GetMultipleBookings  ${bookingEndpoint}/0

    Should Contain    ${response}    HTTPError: 404
