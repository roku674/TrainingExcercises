def response_message = messageExchange.responseContent

def response_json = new groovy.json.JsonSlurper().parseText(response_message)

log.info(response_json.day_of_year)

def response_day = response_json.day_of_year

if 1 <= response_day & response_day <= 366){
    assert true
}
else{
    log.info("wrong day of year: ${response_day}")
    assert false
}