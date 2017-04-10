*** Settings ***
#Library   Selenium2Screenshots
Library   String
Library   DateTime
Library   Selenium2Library
Library   Collections
Library   accept_service.py

*** Variables ***
${NewTenderUrl}     SomeUrl1
${ViewTenderUrl}    SomeUrl2
${ViewTenderUrlUrl}    SomeUrl3
${locator.edit.tenderPeriod.endDate}    xpath=(.//div[@class='accDateTimePicker']/md-input-container/input)[4]
${locator.edit.description}    id=description
${locator.procuringEntity.name}    xpath=//*[@id="tab-content-20"]/div/md-content/div[2]/div[1]/div[2]

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]     @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  Open Browser  ${USERS.users['${ARGUMENTS[0]}'].homepage}  ${USERS.users['${ARGUMENTS[0]}'].browser}  alias=${ARGUMENTS[0]}
  Set Window Size       @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If   '${ARGUMENTS[0]}' != 'UUB_Viewer'   Login   ${ARGUMENTS[0]}

Login
  [Arguments]  @{ARGUMENTS}
  Click Button    xpath=(//button[@class="md-button md-primary md-cornered md-button-in-flex md-button md-ink-ripple"])[1]
  sleep    1
  Input text      id=username          ${USERS.users['${ARGUMENTS[0]}'].login}
  Input text      id=password          ${USERS.users['${ARGUMENTS[0]}'].password}
  Click Button    id=loginButton

Змінити користувача
  [Arguments]  @{ARGUMENTS}
  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
  Sleep   2
  Input text      id=username          ${USERS.users['${ARGUMENTS[0]}'].login}
  Input text      id=password          ${USERS.users['${ARGUMENTS[0]}'].password}
  Click Button    id=loginButton
  Sleep   2

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data
  log to console  *
  log to console  ${ARGUMENTS[1]}

    ${title}=                 Get From Dictionary         ${ARGUMENTS[1].data}                  title
    ${description}=           Get From Dictionary         ${ARGUMENTS[1].data}                  description
    ${procuringEntity_name}=  Get From Dictionary         ${ARGUMENTS[1].data.procuringEntity}  name
    ${items}=                 Get From Dictionary         ${ARGUMENTS[1].data}                  items
    ${budget}=                Get From Dictionary         ${ARGUMENTS[1].data.value}            amount
    ${step_rate}=             Get From Dictionary         ${ARGUMENTS[1].data.minimalStep}      amount
    ${currency}=                 Get From Dictionary      ${ARGUMENTS[1].data.value}            currency
    ${valueAddedTaxIncluded}=    Get From Dictionary      ${ARGUMENTS[1].data.value}            valueAddedTaxIncluded

    ${lots}=                              Get From Dictionary             ${ARGUMENTS[1].data}                   lots
    ${lot1_description}=                  Get From Dictionary             ${lots[0]}                             description
    ${lot1_title}=                        Get From Dictionary             ${lots[0]}                             title


    ${enquiryPeriod_startDate}=    Get From Dictionary    ${ARGUMENTS[1].data.enquiryPeriod}    startDate
    ${enquiryPeriod_endDate}=      Get From Dictionary    ${ARGUMENTS[1].data.enquiryPeriod}    endDate
    ${tenderPeriod_startDate}=     Get From Dictionary    ${ARGUMENTS[1].data.tenderPeriod}     startDate
    ${tenderPeriod_endDate}=       Get From Dictionary    ${ARGUMENTS[1].data.tenderPeriod}     endDate
    ${delivery_startDate}=         Get From Dictionary    ${items[0].deliveryDate}              startDate
    ${delivery_endDate}=           Get From Dictionary    ${items[0].deliveryDate}              endDate

    #  Дати та час
    ${enquiryPeriod_startDate_str}=    convert_datetime_to_new         ${enquiryPeriod_startDate}
	${enquiryPeriod_startDate_time}=   convert_datetime_to_new_time    ${enquiryPeriod_startDate}
    ${enquiryPeriod_endDate_str}=      convert_datetime_to_new         ${enquiryPeriod_endDate}
	${enquiryPeriod_endDate_time}=     convert_datetime_to_new_time    ${enquiryPeriod_endDate}
    ${tenderPeriod_startDate_str}=     convert_datetime_to_new         ${tenderPeriod_startDate}
	${tenderPeriod_startDate_time}=    convert_datetime_to_new_time    ${tenderPeriod_startDate}
    ${tenderPeriod_endDate_str}=       convert_datetime_to_new         ${tenderPeriod_endDate}
	${tenderPeriod_endDate_time}=      convert_datetime_to_new_time    ${tenderPeriod_endDate}
    ${delivery_StartDate_str}=         convert_datetime_to_new         ${delivery_startDate}
	${delivery_StartDate_time}=        convert_datetime_to_new_time    ${delivery_startDate}
    ${delivery_endDate_str}=           convert_datetime_to_new         ${delivery_endDate}
	${delivery_endDate_time}=          convert_datetime_to_new_time    ${delivery_endDate}

    ${item_scheme}=          Get From Dictionary         ${items[0].classification}               scheme
    ${item_id}=              Get From Dictionary         ${items[0].classification}               id
    ${lot_id}=               Get From Dictionary         ${items[0].classification}               id
    ${item_descr}=           Get From Dictionary         ${items[0].classification}               description
	${unit}=                 Get From Dictionary         ${items[0].unit}                         name

    run keyword and ignore error          Отримати коди додаткової класифікації          ${ARGUMENTS[1]}

    ${descr_lot}=            Get From Dictionary         ${items[0]}                              description
    ${quantity}=             Get From Dictionary         ${items[0]}                              quantity
    ${streetAddress}=        Get From Dictionary         ${items[0].deliveryAddress}              streetAddress
    ${locality}=             Get From Dictionary         ${items[0].deliveryAddress}              locality
    ${region}=               Get From Dictionary         ${items[0].deliveryAddress}              region
    ${postalCode}=           Get From Dictionary         ${items[0].deliveryAddress}              postalCode
    ${countryName}=          Get From Dictionary         ${items[0].deliveryAddress}              countryName

###    Input data
    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}

   #log to console  ${ARGUMENTS[1]}

#	Wait Until Page Contains Element    xpath=//a[@href="/etm-Qa_fe/dashboard"]     300
	Wait Until Page Contains Element    xpath=//a[@href="/dashboard"]     300
#	Click Link    xpath=//a[@href="/etm-Qa_fe/dashboard"]
	Click Link    xpath=//a[@href="/dashboard"]
    Wait Until Page Contains Element    xpath=(//a[@ng-click="$ctrl.go(sItem.state.name)"])[1]    300
    Click Link    xpath=(//a[@ng-click="$ctrl.go(sItem.state.name)"])[1]                                 #xpath=//a[text()="Мої Тендери"]

    Wait Until Page Contains Element    xpath=.//a[@ui-sref='root.dashboard.tenderDraft({id:0})']    300
    Click Link    xpath=.//a[@ui-sref='root.dashboard.tenderDraft({id:0})']                              #xpath=//a[text()="Створити"]

    Input text              id=title                ${title}
    Input text              id=description          ${description}

    Click Element           id=tender-value-vat
    ${budget}=              adapt_numbers                   ${ARGUMENTS[1].data.value.amount}
    ${budget_str}=          Convert To String       ${budget}
    ${step_rate_str}=       Convert To String    ${step_rate}

    Click Element    id=accelerate
#    Input text              id=procurementMethodDetails    quick, accelerator=1440
#    Input text              id=submissionMethodDetails    quick
#    Input text              id=mode    test

###    Input Dates
    Input text              xpath=//*[@id="datefieldEnquireStart"]/ng-form/div[1]/md-datepicker/div[1]/input       ${enquiryPeriod_startDate}
    Sleep    1
	Input text              xpath=(//*[@id="timeInput"])[1]         ${enquiryPeriod_startDate_time}
    Sleep    1
    Input text              xpath=//*[@id="datefieldEnquiryEnd"]/ng-form/div[1]/md-datepicker/div[1]/input        ${enquiryPeriod_endDate_str}
    Sleep    1
	Input text              xpath=(//*[@id="timeInput"])[2]      ${enquiryPeriod_endDate_time}
    Sleep    1
    Input text              xpath=//*[@id="datefieldTenderStart"]/ng-form/div[1]/md-datepicker/div[1]/input    ${tenderPeriod_startDate_str}
    Sleep    1
	Input text              xpath=(//*[@id="timeInput"])[3]    ${tenderPeriod_startDate_time}
    Sleep    1
    Input text              xpath=//*[@id="datefieldTenderEnd"]/ng-form/div[1]/md-datepicker/div[1]/input     ${tenderPeriod_endDate_str}
    Sleep    1
	Input text              xpath=(//*[@id="timeInput"])[4]      ${tenderPeriod_endDate_time}

	sleep  5
	Click Button       id=tender-apply   #Застосувати
	Sleep    10
	reload page
	sleep    10
	# Лоти закупівлі
    Execute Javascript    $(angular.element("md-tab-item")[1]).click()

#    Input text              id=lotTitle-0                ${title}
#    input text              id=lotDescription-0          ${description}
    Input text              id=lotTitle-0                ${lot1_title}
    input text              id=lotDescription-0          ${lot1_description}

	Input text              id=amount-lot-value.0        ${budget_str}
	sleep  10

	#Input text              id=amount-lot-guarantee.0    0
	Input text              id=amount-lot-minimalStep.0  ${step_rate_str}
	sleep  10

    #    Нажатие на кнопку "Спеціфікації закупівлі"
	Execute Javascript    $($("app-tender-lot")).find("md-tab-item")[1].click()
	Sleep    3s
	#Execute Javascript    angular.element("#lotDocumentAddAction")
	#Click button    id=lotDocumentAddAction
    Input text               id=itemDescription--                ${descr_lot}

    #Click Element           id=tender-value-vat

    #Код ДК 021-2015
	#Execute Javascript    angular.element("#cpv").scope().value.classification = {id: "${item_id}", description: "${item_descr_en}", scheme: "${item_scheme}"};
    Execute Javascript    angular.element("#cpv").scope().value.classification = {id: "${item_id}", description: "${item_descr}", scheme: "${item_scheme}"};

    #Додаткові коди
    #Execute Javascript    angular.element("#cpv").scope().value.additionalClassifications = [{id: "${add_id}", description: "${add_descr}", scheme: "${add_scheme}"}];
    run keyword and ignore error    Заповнити додаткові коди першого айтему
    Input text    id=itemQuantity--                                    ${quantity}
    Select From List    id=unit-unit--                                 ${unit}
    Input text    id=streetAddress.value.deliveryAddress--             ${streetAddress}
    Input text    id=locality.value.deliveryAddress--                  ${locality}
    Input text    id=region.value.deliveryAddress--                    ${region}
    Input text    id=postalCode.value.deliveryAddress--                ${postalCode}
    Select From List    id=countryName.value.deliveryAddress--         ${countryName}

    Input text    xpath=(.//app-lot-specification//app-datetime-picker)[1]//input[@class='md-datepicker-input']        ${delivery_StartDate_str}
    Sleep    1
	  Input text    xpath=(//*[@id="timeInput"])[5]    ${delivery_StartDate_time}
    Sleep    1
    Input text    xpath=(.//app-lot-specification//app-datetime-picker)[2]//input[@class='md-datepicker-input']           ${delivery_EndDate_str}
    Sleep    3
	  Input text    xpath=(//*[@id="timeInput"])[6]  ${delivery_EndDate_time}

    #    Нажатие на кнопку "Контактна особа"
    Execute Javascript    $(angular.element("md-tab-item")[3]).click()

    #    Нажатие на кнопку "Тендерна документація/нецінові критерії закупівлі"
    Execute Javascript    $(angular.element("md-tab-item")[2]).click()

    Click Button       id=tender-apply   #Застосувати

    ${NewTenderUrl}=   Execute Javascript    return window.location.href
    SET GLOBAL VARIABLE    ${NewTenderUrl}

    # Кнопка "Опубліковати"
    Page should contain element      id=tender-publish
    Wait Until Element Is Enabled    id=tender-publish
    Click Button    id=tender-publish

	# Кнопка "Так"
    Wait Until Page Contains Element    xpath=//div[@class="modal-dialog "]//button[@ng-click="ok()"]    20
    Click Button    xpath=//div[@class="modal-dialog "]//button[@ng-click="ok()"]
    Sleep    10
    ${localID}=    get_local_id_from_url        ${NewTenderUrl}
#    ${hrefToTender}=    Evaluate    "/etm-Qa_fe/dashboard/tender-drafts/" + str(${localID})
    ${hrefToTender}=    Evaluate    "/dashboard/tender-drafts/" + str(${localID})
	#Sleep    40
    Wait Until Page Contains Element    xpath=//a[@href="${hrefToTender}"]    300
    Go to    ${NewTenderUrl}

	Sleep    15
    ${tender_id}=     Get Text        xpath=//a[@id='tenderUID']
    ${TENDER_UA}=     Get Text        id=tenderID
    ${ViewTenderUrl}=    assemble_viewtender_url    ${NewTenderUrl}    ${tender_id}
	SET GLOBAL VARIABLE    ${ViewTenderUrl}
#    log to console  *
#    log to console      ${tender_id}
#    log to console      ${TENDER_UA}
    [return]    ${TENDER_UA}

Підготувати дані для оголошення тендера
    [Arguments]   ${username}    ${tender_data}     ${items}
    ${tender_data}=       adapt_data       ${tender_data}
    [return]    ${tender_data}

Отримати коди додаткової класифікації
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  tender_data
  ${items}=                             Get From Dictionary             ${ARGUMENTS[0].data}                      items
  ${item1_add_description}=             Get From Dictionary             ${items[0].additionalClassifications[0]}  description
  ${item1_add_id}=                      Get From Dictionary             ${items[0].additionalClassifications[0]}  id
  ${item1_add_scheme}=                  Get From Dictionary             ${items[0].additionalClassifications[0]}  scheme
  SET GLOBAL VARIABLE    ${item1_add_description}
  SET GLOBAL VARIABLE    ${item1_add_id}
  SET GLOBAL VARIABLE    ${item1_add_scheme}

Заповнити додаткові коди першого айтему
    Execute Javascript    angular.element("#cpv").scope().value.additionalClassifications = [{id: "${item1_add_id}", description: "${item1_add_description}", scheme: "${item1_add_scheme}"}];
    sleep  2


Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${filepath}
  ...      ${ARGUMENTS[2]} ==  ${TENDER}
  Go to               ${NewTenderUrl}
  # Нажатие на кнопку "Тендерна документація/нецінові критерії закупівлі"
  Sleep    5s
  Execute Javascript    $(angular.element("md-tab-item")[2]).click()
  # +Додати
  Click Button    id=tenderDocumentAddAction
  #Вибір тендерної документації з переліка
  Execute Javascript    $("#type-tender-documents-0").val("biddingDocuments");
  Log    ${ARGUMENTS[1]}
  Choose file     id=file-tender-documents-0    ${ARGUMENTS[1]}
  # Кнопка "Застосувати"
  sleep    3s
  Execute Javascript    $("#tender-apply").click()

  # Кнопка "Опублікувати"
  Page should contain element      id=tender-publish
  Wait Until Element Is Enabled    id=tender-publish
  Click Button    id=tender-publish

  # Кнопка "Так"
  Wait Until Page Contains Element    xpath=//div[@class="modal-dialog "]//button[@ng-click="ok()"]    20
  Click Button    xpath=//div[@class="modal-dialog "]//button[@ng-click="ok()"]
  ${localID}=    get_local_id_from_url        ${NewTenderUrl}
#  ${hrefToTender}=    Evaluate    "/etm-Qa_fe/dashboard/tender-drafts/" + str(${localID})
  ${hrefToTender}=    Evaluate    "/dashboard/tender-drafts/" + str(${localID})
  Sleep    40



Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER}
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  ${curPage}=   Execute Javascript    return window.location.href
  Log    ${curPage}
  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
  Sleep    10
#  Click Link    xpath=(//a[@href="/etm-Qa_fe/search/tenders"])[1]
  Click Link    xpath=(//a[@href="/search/tenders"])[1]
  # Кнопка  "Головна"
#  Wait Until Page Contains Element    xpath=//a[@href="/etm-Qa_fe/search"]    10
  Wait Until Page Contains Element    xpath=//a[@href="/search"]    10
#  Click Link    xpath=//a[@href="/etm-Qa_fe/search"]
  Click Link    xpath=//a[@href="/search"]
  # Кнопка  "Розширений пошук"
  Click Button    xpath=//tender-search-panel//div[@class='advanced-search-control']//button[contains(@ng-click, 'advancedSearchHidden')]
  Input Text      id=identifier    ${ARGUMENTS[1]}
  Click Button    id=searchButton
  Sleep    10s
  Run Keyword If   '${ARGUMENTS[0]}' != 'accept_Owner'   Kostyl for Provider    ${ARGUMENTS[1]}



Kostyl for Provider
  [Arguments]  @{ARGUMENTS}
  ${tenderHRef}=    Evaluate    "tender-" + "${ARGUMENTS[0]}"
  Wait Until Page Contains Element    id=${tenderHRef}
  Click Link    id=${tenderHRef}
  Sleep    10s
  ${ViewTenderUrl}=    Execute Javascript    return window.location.href
  SET GLOBAL VARIABLE    ${ViewTenderUrl}



Перейти до сторінки запитань
  Sleep    10

  ${someTender}=      Execute Javascript     return document.getElementById("identifier").value
  ${str1}=    "tender-"
  ${idTender}=    Evaluate    "tender-" + str(${someTender})

  ${href}=    Selenium2Library.Get Element Attribute    ${idTender}@href
  ${ViewTenderUrl}=    assemble_viewtender_url_url    ${NewTenderUrl}    ${href}
  Click Link    xpath=//a[@id=${idTender}]


Задати запитання на тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderUaId
  ...      ${ARGUMENTS[2]} ==  questionId
  Go to    ${ViewTenderUrl}
  Reload page
  Sleep    10
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description
  Log    ${ARGUMENTS[0]}
  ${WhereAmI}=   Execute Javascript    return window.location.href
  Wait Until Page Contains Element   xpath=//ng-form[@name='questionForm'][1]//button[@ng-click='toggleView()']
  Click Button     xpath=//ng-form[@name='questionForm'][1]//button[@ng-click='toggleView()']
  Sleep    5s
  input text       id=title          ${title}
  input text       id=description    ${description}
  Sleep    10
  Click Button     xpath=//ng-form[@name='questionForm'][1]//button[@ng-click='createQuestion()']
  Sleep    30

Оновити сторінку з тендером
    [Arguments]    @{ARGUMENTS}
    [Documentation]
    ...      ${ARGUMENTS[0]} = username
    ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
	Switch Browser    ${ARGUMENTS[0]}
	Run Keyword If   '${ARGUMENTS[0]}' == 'accept_Owner'   Go to    ${NewTenderUrl}
	Run Keyword If   '${ARGUMENTS[0]}' != 'accept_Owner'   Go to    ${ViewTenderUrl}

Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  ...      ${ARGUMENTS[2]} ==  fieldname
  Go to    ${ViewTenderUrl}
  sleep  20
  ${return_value}=  run keyword  Отримати інформацію про ${ARGUMENTS[2]}
  [return]  ${return_value}

Отримати інформацію із предмету
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${tender_uaid}
  ...      ${ARGUMENTS[2]} ==  ${object_id}
  ...      ${ARGUMENTS[3]} ==  ${field_name}
  Go to    ${ViewTenderUrl}
  sleep  10
  ${return_value}=  run keyword  Отримати інформацію із ${ARGUMENTS[3]}
  [return]  ${return_value}

Отримати інформацію із запитання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${tender_uaid}
  ...      ${ARGUMENTS[2]} ==  ${object_id}
  ...      ${ARGUMENTS[3]} ==  ${field_name}
  Go to    ${ViewTenderUrl}
  sleep  20
  ${return_value}=  run keyword  Отримати інформацію про запитання ${ARGUMENTS[3]}
  [return]  ${return_value}

Отримати інформацію із лоту
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${tender_uaid}
  ...      ${ARGUMENTS[2]} ==  ${object_id}
  ...      ${ARGUMENTS[3]} ==  ${field_name}
  Go to    ${ViewTenderUrl}
  sleep  20
  ${return_value}=  run keyword  Отримати інформацію із лоту ${ARGUMENTS[3]}
  [return]  ${return_value}

Отримати інформацію із документа
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${tender_uaid}
  ...      ${ARGUMENTS[2]} ==  ${object_id}
  ...      ${ARGUMENTS[3]} ==  ${field_name}
  Go to    ${ViewTenderUrl}
  sleep  20
  ${return_value}=  run keyword  Отримати інформацію із документа ${ARGUMENTS[3]}
  [return]  ${return_value}


Отримати документ
#Відображення вмісту документації до тенде
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  ${username}
  ...      ${ARGUMENTS[1]} ==  ${tender_uaid}
  ...      ${ARGUMENTS[2]} ==  ${doc_id}
  Go to    ${ViewTenderUrl}
  sleep  10
  click button    xpath=.//button[@tender-id='control.tenderId']
  sleep  5
  ${return_value}=    Get Text    xpath=.//a[@ng-click='loadUrl(gr)']
  ${link}=  get value  xpath=.//a[@ng-click='loadUrl(gr)']
  download_file       ${link}    ${return_value}      ${OUTPUT_DIR}
  sleep  10
  [return]  ${return_value}


Отримати інформацію про title
  ${return_value}=    Execute Javascript      return angular.element("#robotStatus").scope().data.title
  [return]  ${return_value}


Отримати інформацію про description
#Відображення опису тендера
    ${return_value}=    Get Text    xpath=(.//*[@dataanchor='tenderView']//*[@dataanchor='description'])[1]
    [return]  ${return_value}

Отримати інформацію про items[0].description
#Відображення опису номенклатур тендера
    ${return_value}=    Execute Javascript      return angular.element(document.querySelectorAll("[dataanchor='tenderView']")[0].querySelectorAll("[dataanchor='lots']")[0].querySelectorAll("[dataanchor='lot']")[0].querySelectorAll("[dataanchor='specifications']")[0].querySelectorAll("[dataanchor='specification']")[0]).scope().lotItem.items[0].description
    [return]  ${return_value}


Отримати інформацію про value.amount
  #Відображення бюджету тендера
  ${return_value}=    Get Text    xpath=(.//*[@dataanchor='value'])[1]
  ${return_value}=    get_numberic_part    ${return_value}
  ${return_value}=    adapt_numbers2   ${return_value}
  [return]  ${return_value}


Отримати інформацію про minimalStep.amount
	${return_value}=    Get Element Attribute    xpath=(.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='minimalStep.amount']@textContent
	${return_value}=    get_numberic_part    ${return_value}
	${return_value}=    Convert To Number    ${return_value}
    [return]  ${return_value}


Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  fieldname
  ...      ${ARGUMENTS[3]} ==  fieldvalue
  go to    ${NewTenderUrl}
  Sleep    20s

  ${temp}=  convert to string  ${ARGUMENTS[2]}

  run keyword if  '${temp}' == 'tenderPeriod.endDate'    Змінити дату в тендері при редагуванні          @{ARGUMENTS}
  run keyword if  '${temp}' == 'description'             Змінити description в тендері при редагуванні   @{ARGUMENTS}






Змінити дату в тендері при редагуванні
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[3]} =  fieldvalue
    #  Редагувати тендер
  ${time_1}=           convert_datetime_to_new_time    ${ARGUMENTS[3]}
  Wait Until Page Contains Element   ${locator.edit.${ARGUMENTS[2]}}   20
  Input Text      ${locator.edit.${ARGUMENTS[2]}}   ${time_1}
  Sleep    5s
  Execute Javascript    angular.element("md-tab-item")[1].click()
  Sleep    3s
  Execute Javascript    angular.element("md-tab-item")[2].click()
  Sleep    5s
  #Застосувати
  Sleep    5s
  #Log                ${NewTenderUrl}
  ${NewTenderUrl}=   Execute Javascript    return window.location.href
  SET GLOBAL VARIABLE    ${NewTenderUrl}


  # Кнопка "Опубліковати"
  Page should contain element      id=tender-publish
  Wait Until Element Is Enabled    id=tender-publish
  Click Button    id=tender-publish
  # Кнопка "Так"
  Wait Until Page Contains Element    xpath=//div[@class="modal-dialog "]//button[@ng-click="ok()"]    20
  Click Button    xpath=//div[@class="modal-dialog "]//button[@ng-click="ok()"]

  Wait Until Page Contains       Опубліковано          300
  go to    ${NewTenderUrl}
#  Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[1]}
  ${result_field}=  Get Value   ${locator.edit.${ARGUMENTS[2]}}
  ${delim}=         convert to string       T
  ${result_field}=  parse_smth              ${result_field}     ${0}       ${delim}
  ${delim_1}=         convert to string       +
  ${result_field}=  parse_smth              ${result_field}     ${0}       ${delim_1}
  ${result_field}=  adapt_time              ${result_field}
  [return]  ${result_field}
  Go to    ${ViewTenderUrl}


Змінити description в тендері при редагуванні
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  fieldvalue
    #  Редагувати тендер
  Wait Until Page Contains Element   ${locator.edit.${ARGUMENTS[2]}}   5
  Sleep    5s
  Input Text       ${locator.edit.${ARGUMENTS[2]}}   ${ARGUMENTS[3]}
  Sleep    5s
  Execute Javascript    angular.element("md-tab-item")[1].click()
  Sleep    3s
  Execute Javascript    angular.element("md-tab-item")[2].click()
  Sleep    5s
  #Застосувати
  Sleep    5s
  ${NewTenderUrl}=   Execute Javascript    return window.location.href
  SET GLOBAL VARIABLE    ${NewTenderUrl}


  # Кнопка "Опубліковати"
  Page should contain element      id=tender-publish
  Wait Until Element Is Enabled    id=tender-publish
  Click Button    id=tender-publish
  # Кнопка "Так"
  Wait Until Page Contains Element    xpath=//div[@class="modal-dialog "]//button[@ng-click="ok()"]    20
  Click Button    xpath=//div[@class="modal-dialog "]//button[@ng-click="ok()"]

  Wait Until Page Contains       Опубліковано          300
  ${result_field}=  Get Value   ${locator.edit.${ARGUMENTS[2]}}
  [return]  ${result_field}

  Go to    ${ViewTenderUrl}

Отримати інформацію із quantity
#Відображення кількості номенклатур тендера
#Отримати інформацію про items[0].quantity
  ${return_value}=    Execute Javascript    return angular.element(document.querySelectorAll("[dataanchor='tenderView']")[0].querySelectorAll("[dataanchor='lots']")[0].querySelectorAll("[dataanchor='lot']")[0].querySelectorAll("[dataanchor='specifications']")[0].querySelectorAll("[dataanchor='specification']")[0]).scope().lotItem.items[0].quantity
  [return]  ${return_value}

Отримати інформацію із unit.code
#Відображення коду одиниці номенклатур тендера
#Отримати інформацію про items[0].unit.code
  ${return_value}=    Execute Javascript    return angular.element(document.querySelectorAll("[dataanchor='tenderView']")[0].querySelectorAll("[dataanchor='lots']")[0].querySelectorAll("[dataanchor='lot']")[0].querySelectorAll("[dataanchor='specifications']")[0].querySelectorAll("[dataanchor='specification']")[0]).scope().lotItem.items[0].unit.code
  [return]  ${return_value}

Отримати інформацію із unit.name
#Відображення назви одиниці номенклатур тендера
#Отримати інформацію про items[0].unit.name
  ${return_value}=    Get Element Attribute    xpath=(((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='quantity.unit.name'])@textContent
  [return]  ${return_value}

Отримати інформацію про value.currency
  ${return_value}=    Get Text    xpath=.//*[@dataanchor='tenderView']//*[@dataanchor='value.currency']
  [return]  ${return_value}

Отримати інформацію про value.valueAddedTaxIncluded
  ${return_value}=    get text    xpath=.//*[@dataanchor='tenderView']//*[@dataanchor='value.valueAddedTaxIncluded']
  ${return_value}=    Evaluate    "${return_value}" == "(з ПДВ)"
  [return]    ${return_value}


Отримати інформацію про tenderId
  ${return_value}=    Get Text   id=tenderID
  [return]    ${return_value}


Отримати інформацію про procuringEntity.name
  ${return_value}=    Get Text    xpath=.//*[@dataanchor='tenderView']//*[@dataanchor='procuringEntity']//*[@dataanchor='name']
  [return]  ${return_value}

  #Go to               ${NewTenderUrl}
  #Execute Javascript    angular.element("md-tab-item")[3].click()
  #sleep    3s
  #${return_value}=    Get Text    xpath=//*[@id="tab-content-20"]/div/md-content/div[2]/div[1]/div[2]
  #${return_value}=    Get Text    id=procuringEntityContactPointName
  #[return]  ${return_value}

#У нас на майданчике еще не реализовано#########################################
#Отримати інформацію про items[0].deliveryLocation.latitude
#  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryLocation.latitude
#  ${return_value}=   Convert To Number   ${return_value}
#  [return]  ${return_value}

#Я вставил адрес. Я не знаю где у нас широта и долгота
# ${return_value}=    Get Text   id=streetAddress.value.deliveryAddress..
#  [return]  ${return_value}
#  Fail

#Отримати інформацію про items[0].deliveryLocation.longitude
#  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryLocation.longitude
#  ${return_value}=   Convert To Number   ${return_value}
#  [return]  ${return_value}

# ${return_value}=    Get Text   id=locality.value.deliveryAddress..
# [return]  ${return_value}
# Fail
##################################################################

Отримати інформацію про tenderPeriod.startDate
    ${return_value}=    Execute Javascript    return angular.element(document.querySelectorAll("[dataanchor='tenderView']")[0]).scope().data.tenderPeriod.startDate
    [return]    ${return_value}

Отримати інформацію про tenderPeriod.endDate
    ${return_value}=    Execute Javascript    return angular.element(document.querySelectorAll("[dataanchor='tenderView']")[0]).scope().data.tenderPeriod.endDate
    [return]    ${return_value}

Отримати інформацію про enquiryPeriod.startDate
  ${return_value}=    Execute Javascript    return angular.element(document.querySelectorAll("[dataanchor='tenderView']")[0]).scope().data.enquiryPeriod.startDate
  [return]    ${return_value}

Отримати інформацію про enquiryPeriod.endDate
    ${return_value}=    Execute Javascript    return angular.element(document.querySelectorAll("[dataanchor='tenderView']")[0]).scope().data.enquiryPeriod.endDate
	[return]    ${return_value}


Отримати інформацію із items[0].description
    Sleep    3
    ${return_value}=    Execute Javascript    return angular.element(document.querySelectorAll("[dataanchor='tenderView']")[0].querySelectorAll("[dataanchor='lots']")[0].querySelectorAll("[dataanchor='lot']")[0].querySelectorAll("[dataanchor='specifications']")[0].querySelectorAll("[dataanchor='specification']")[0]).scope().lotItem.items[0].description
	[return]  ${return_value}

Отримати інформацію із classification.id
#Отримати інформацію про items[0].classification.id
    ${return_value}=    Get Element Attribute    xpath=(((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='classifications'])[1]//*[@dataanchor="classification"]//*[@dataanchor="value"]@textContent
    [return]  ${return_value}

Отримати інформацію із classification.scheme
#Отримати інформацію про items[0].classification.scheme
#Відображення схеми основної/додаткової класифікації номенклатур
    ${return_value}=    Get Element Attribute    xpath=(((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='classifications'])[1]//*[@dataanchor="classification"]//*[@dataanchor="scheme"]@textContent
    [return]  ${return_value}

Отримати інформацію із classification.description
#Відображення опису основної/додаткової класифікації номенклатур
#Отримати інформацію про items[0].classification.description
    ${return_value}=    Get Element Attribute    xpath=(((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='classifications'])[1]//*[@dataanchor="classification"]//*[@dataanchor="description"]@textContent
    [return]  ${return_value}


Отримати інформацію про items[0].additionalClassifications[0].id

	${return_value}=    Get Element Attribute    xpath=(((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='additionalClassifications'])[1]//*[@dataanchor="classification"]//*[@dataanchor="value"]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].scheme
    ${return_value}=    Get Element Attribute    xpath=(((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='additionalClassifications'])[1]//*[@dataanchor="classification"]//*[@dataanchor="scheme"]@textContent
    [return]  ${return_value}


Отримати інформацію про items[0].additionalClassifications[0].description
    ${return_value}=    Get Element Attribute    xpath=(((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='additionalClassifications'])[1]//*[@dataanchor="classification"]//*[@dataanchor="description"]@textContent
	[return]  ${return_value}



Отримати інформацію із deliveryAddress.countryName
#Відображення назви нас. пункту доставки номенклатур тендера
#Отримати інформацію про items[0].deliveryAddress.countryName
	${return_value}=    Get Element Attribute    xpath=((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='deliveryAddress']//*[@dataanchor="countryName"]@textContent
    [return]  ${return_value}

Отримати інформацію із deliveryAddress.postalCode
#Отримати інформацію про items[0].deliveryAddress.postalCode
#Вдображення пошт. коду доставки номенклатур тендера
    ${return_value}=    Get Element Attribute    xpath=((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='deliveryAddress']//*[@dataanchor="postalCode"]@textContent
    [return]  ${return_value}

Отримати інформацію із deliveryAddress.region
#Отримати інформацію про items[0].deliveryAddress.region
#Відображення регіону доставки номенклатур тендера
    ${return_value}=    Get Element Attribute    xpath=((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='deliveryAddress']//*[@dataanchor="region"]@textContent
    [return]  ${return_value}

Отримати інформацію із deliveryAddress.locality
#Отримати інформацію про items[0].deliveryAddress.locality
#Відображення locality адреси доставки номенклатур тендера
    ${return_value}=    Get Element Attribute    xpath=((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='deliveryAddress']//*[@dataanchor="locality"]@textContent
    ${return_value}=    Get Element Attribute    xpath=((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='deliveryAddress']//*[@dataanchor="locality"]@textContent
    [return]  ${return_value}


Отримати інформацію із deliveryAddress.streetAddress
#Отримати інформацію про items[0].deliveryAddress.streetAddress
#Відображення вулиці доставки номенклатур тендера
    ${return_value}=    Get Element Attribute    xpath=((.//*[@dataanchor='tenderView']//*[@dataanchor='lots'])[1]//*[@dataanchor='lot']//*[@dataanchor='specifications'])[1]//*[@dataanchor='specification']//*[@dataanchor='deliveryAddress']//*[@dataanchor="streetAddress"]@textContent
    [return]  ${return_value}

Отримати інформацію із deliveryDate.startDate
#Отримати інформацію про items[0].deliveryDate.startDate
	${return_value}=    Execute Javascript    return angular.element(document.querySelectorAll("[dataanchor='tenderView']")[0].querySelectorAll("[dataanchor='lots']")[0].querySelectorAll("[dataanchor='lot']")[0].querySelectorAll("[dataanchor='specifications']")[0].querySelectorAll("[dataanchor='specification']")[0]).scope().lotItem.items[0].deliveryDate.startDate
    [return]  ${return_value}

Отримати інформацію із deliveryDate.endDate
#Отримати інформацію про items[0].deliveryDate.endDate
    ${return_value}=    Execute Javascript    return angular.element(document.querySelectorAll("[dataanchor='tenderView']")[0].querySelectorAll("[dataanchor='lots']")[0].querySelectorAll("[dataanchor='lot']")[0].querySelectorAll("[dataanchor='specifications']")[0].querySelectorAll("[dataanchor='specification']")[0]).scope().lotItem.items[0].deliveryDate.endDate
    [return]  ${return_value}

Отримати інформацію про запитання title
  Reload page
  Sleep    10
  ${return_value}=    Execute Javascript    return angular.element(document.querySelectorAll("[dataanchor='tenderView']")[0].querySelectorAll("[dataanchor='question']")[0].querySelectorAll("[dataanchor='title']")[0])[0].textContent
  [return]  ${return_value}


Отримати інформацію про запитання description
  ${return_value}=    Get Text     xpath=.//div[@class="message-row layout-row"]/div[1]/div[2]
  [return]  ${return_value}


Отримати інформацію про запитання date
   ${return_value}=    Execute Javascript    return angular.element(document.querySelectorAll("[dataanchor='tenderView']")[0].querySelectorAll("[dataanchor='question']")).scope().$parent.q.date
   [return]  ${return_value}

Отримати інформацію про запитання answer
#Отримати інформацію про questions[0].answer
  ${return_value}=    Get Text    xpath=.//div[@ng-if='question.answer']
  [return]  ${return_value}

Отримати інформацію із description
#Відображення опису номенклатур тендера
  ${return_value}=    Get Text    xpath=.//div[@ng-if='question.answer']
  [return]  ${return_value}

Отримати інформацію із документа title
#Відображення заголовку документації до тендера
  click button    xpath=.//button[@tender-id='control.tenderId']
  sleep  5
  ${return_value}=    Get Text    xpath=.//a[@ng-click='loadUrl(gr)']
  [return]  ${return_value}

Відповісти на запитання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = 0
  ...      ${ARGUMENTS[3]} = answer_data
  ${answer}=    Get From Dictionary  ${ARGUMENTS[2].data}    answer
  Log                ${NewTenderUrl}
  Log                ${ViewTenderUrl}
  #Перейти до сторінки запитань
  Go to    ${ViewTenderUrl}
  ${CurrentUrl}=   Execute Javascript    return window.location.href
  Wait until page contains Element    xpath=//*[@name="questionForm"][1]//button[1]    50s
  Click button    xpath=//*[@name="questionForm"][1]//button[1]
  Wait Until Page Contains Element    id=answer    3s
  Input Text      id=answer    ${answer}
  Sleep    5
  Click button    xpath=//*[@name='questionForm'][1]//button[1]
  Sleep    5


Подати цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  ${username}
    ...    ${ARGUMENTS[1]} ==  ${TENDER['TENDER_UAID']}
    ...    ${ARGUMENTS[2]} ==  ${bid}
    ...    ${ARGUMENTS[3]} ==  ${lots_ids}
    ...    ${ARGUMENTS[4]} ==  ${features_ids}
    ${bid_amount}=        adapt_numbers            ${ARGUMENTS[2].data.value.amount}
    ${bid_amount_str}=    convert to string              ${bid_amount}
    go to  ${ViewTenderUrl}
    wait until element is visible  xpath=.//span[@ng-if='data.status']  60
    sleep  5
    #Кнопка "Додати пропозицію"
    execute javascript             angular.element("#set-participate-in-lot").click()
    sleep  3
    input text                     id=lot-amount-0       ${bid_amount_str}
    sleep  5
    #Кнопка "Відправити пропозиції"
    execute javascript             angular.element("#tender-update-bid").click()
    wait until element is visible  xpath=.//button[@ng-click='ok()']  60
    click element                  xpath=.//button[@ng-click='ok()']
    sleep  10

Скасувати цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    go to  ${ViewTenderUrl}
    sleep  20
    Wait Until Page Contains Element   id=tender-cancel-bid   20
    Click Element       id=tender-cancel-bid
    Sleep   40
    Click Element       xpath=(//button[starts-with(@ng-click, "ok()")])[1]
	Sleep    40

Змінити цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  ${username}
    ...    ${ARGUMENTS[1]} ==  ${TENDER['TENDER_UAID']}
    ...    ${ARGUMENTS[2]} ==  ${field}
    ...    ${ARGUMENTS[3]} ==  ${value}
    go to  ${ViewTenderUrl}
    sleep  10
    ${var} =            adapt_numbers                     ${ARGUMENTS[3]}
    ${var} =            convert to string                 ${var}
    Input Text          id=lot-amount-0                   ${var}
    sleep   10
    Click Element       id=tender-update-bid
    wait until element is visible  xpath=.//button[@ng-click='ok()']  60
    click element                  xpath=.//button[@ng-click='ok()']
    sleep  10


Завантажити документ в ставку
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  file
    ...    ${ARGUMENTS[2]} ==  tenderId
  go to  ${ViewTenderUrl}
  sleep  10
  Wait Until Page Contains Element    xpath=(//button[starts-with(@ng-click, "onBidDocumentAdd")])[1]
  Click Button    xpath=(//button[starts-with(@ng-click, "onBidDocumentAdd")])[1]
  Sleep    10
  Choose file     id=file-lot-documents-0    ${ARGUMENTS[1]}
  Sleep    10
  # Кнопка "Додати пропозицію"
  Click Button    id=tender-update-bid
  wait until element is visible  xpath=.//button[@ng-click='ok()']  60
  click element                  xpath=.//button[@ng-click='ok()']
  sleep  10



Змінити документ в ставці
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} ==  username
  ...    ${ARGUMENTS[1]} ==  ${TENDER['TENDER_UAID']}
  ...    ${ARGUMENTS[2]} ==  ${file_path}
  ...    ${ARGUMENTS[3]} ==  ${USERS.users['${username}']['bid_document']['doc_id']}
  Reload Page
  Sleep    10
  Click Button    xpath=(//button[starts-with(@ng-click, "onBidDocumentAdd")])[1]
  Sleep    10
  Choose file     id=file-lot-documents-1    ${ARGUMENTS[2]}
  Sleep    10
  # Кнопка "Додати пропозицію"
  Click Button    id=tender-update-bid
  wait until element is visible  xpath=.//button[@ng-click='ok()']  60
  click element                  xpath=.//button[@ng-click='ok()']
  sleep  10

Отримати інформацію із пропозиції
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...    ${ARGUMENTS[0]} ==  username
  ...    ${ARGUMENTS[1]} ==  ${TENDER['TENDER_UAID']}
  ...    ${ARGUMENTS[2]} ==  ${field}
  sleep  10
  ${var}=             get value             id=lot-amount-0
  ${var}=             get_numberic_part     ${var}
  ${var}=             adapt_numbers2        ${var}
  [return]            ${var}

Отримати інформацію про bids
    [Arguments]  @{ARGUMENTS}
    go to  ${ViewTenderUrl}
    sleep  10
#    Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[1]}
    Click Link    xpath=//a[@href="dashboard"]
    Wait Until Page Contains Element    xpath=//a[@href="tender-drafts"]      20
    Click Link    xpath=//a[@href="tender-drafts"]

Отримати посилання на аукціон для глядача
    [Arguments]  @{ARGUMENTS}
    Selenium2Library.Switch Browser       ${ARGUMENTS[0]}
    go to  ${ViewTenderUrl}
    sleep  10
    Wait Until Page Contains Element    id=auctionUrl   60
    ${result} =   Get Element Attribute    id=auctionUrl@href
    [return]   ${result}

Отримати посилання на аукціон для учасника
    [Arguments]  @{ARGUMENTS}
    Selenium2Library.Switch Browser       ${ARGUMENTS[0]}
    go to  ${ViewTenderUrl}
    sleep  10
    Wait Until Page Contains Element    id=auctionUrl   60
    ${result} =   Get Element Attribute    id=auctionUrl@href
    [return]   ${result}

Отримати інформацію про status
  Reload Page
  #Wait Until Page Contains Element    id=robotStatus
  Sleep    30
  #${return_value}=   Get Text   id=robotStatus
  ${return_value}=   Execute Javascript      return angular.element("#robotStatus").scope().data.status
  [return]  ${return_value}
