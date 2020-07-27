
public class API_authorizeDotNet {
    // variables to hold our login credentials
    public static string APILOGIN;
    public static string APITRANSKEY;

    // Method to retrieve the credentials
    public static void getAuthNetCreds() {
        Authorize_Net_Setting__c apiLoginSetting = Authorize_Net_Setting__c.getInstance('API Login');
        Authorize_Net_Setting__c apiTransKeySetting = Authorize_Net_Setting__c.getInstance('TransKey');

        APILOGIN = apiLoginSetting.Value__c;
        APITRANSKEY = apiTransKeySetting.Value__c;
    }

    //Make a request to the Authorized.net
    public static AuthNetResp_Wrapper authDotNetCharge(AuthNetReq_Wrapper input) {
        getAuthNetCreds();

        // construct request
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://test.authorize.net/gateway/transact.dll'); //test
        req.setMethod('POST');

        //Build message
        Map<String, String> messageString = new Map<String, String>();
        messageString.put('x_login', APILOGIN);
        messageString.put('x_tran_key', APITRANSKEY);
        messageString.put('x_version', '3.1');
        messageString.put('x_delim_data', 'TRUE');
        messageString.put('x_delim_char', ';');
        messageString.put('x_relay_respons', 'FALSE');

        //The type of transaction
        messageString.put('x_type', 'AUTH_CAPTURE');
        messageString.put('x_method', 'CC');

        //transaction specific information
        messageString.put('x_card_num', input.ccnum);
        messageString.put('x_exp_date', input.ccexp);
        messageString.put('x_card_code', input.ccsec);

        //Transaction amount
        messageString.put('x_amount', input.amt);

        //Description of transaction
        messageString.put('x_description', 'Your transaction ' + input.orderName);

        //Billing Information
        messageString.put('x_first_name', input.firstName);
        messageString.put('x_las_name', input.lastName);
        messageString.put('x_address', input.billStreet);
        messageString.put('x_city', input.billCity);
        messageString.put('x_state', input.billState);
        messageString.put('x_zip', input.billZip);

        //Encode the message components
        String encodeMsg = '';
        for (string s : messageString.keySet()) {
            String v = messageString.get(s);
            //fix null value
            if (String.isBlank(v)) {
                v = '';
            } else {
                encodeMsg += s + '=' + EncodingUtil.urlEncode(v, 'UTF-8')+ '&';
            }
        }

        //Add message termination
        encodeMsg += 'endOfData';
        System.debug(encodeMsg);
        req.setBody(encodeMsg);

        //Send and collect the response
        Http http = new Http();
        String resp = http.send(req).getBody();
        System.debug(resp);

        //Split the response by our delimiter
        List<String> responses = resp.split(';');
        AuthNetResp_Wrapper parsedResponse = parseIntoResponseWrapper(responses);
        return parsedResponse;
    }

    public static AuthNetResp_Wrapper parseIntoResponseWrapper(List<String> input) {
        AuthNetResp_Wrapper temp = new AuthNetResp_Wrapper();
        temp.responseCode = input[0];
        temp.responseSubCode = input[1];
        temp.responseReasonText = input[3];
        temp.responseReasonCode = input[2];
        temp.authorizationCode = input[4];
        temp.AVSResponse = input[5];
        temp.transactionID = input[6];
        temp.invoiceNumber = input[7];
        temp.description = input[8];
        temp.amount = input[9];
        temp.method = input[10];
        temp.transactionType = input[11];
        temp.customerID = input[12];
        temp.firstName = input[13];
        temp.lastName = input[14];
        temp.company = input[15];
        temp.address = input[16];
        temp.city = input[17];
        temp.ZIPCode = input[18];
        temp.country = input[19];
        temp.phone = input[20];
        temp.fax = input[21];
        temp.emailAddress = input[22];
        temp.shipToFirstName = input[23];
        temp.shipToLastName = input[24];
        temp.shipToCompany = input[25];
        temp.shipToAddress = input[26];
        temp.shipToCity = input[27];
        temp.shipToState = input[28];
        temp.shipToZIPCode = input[29];
        temp.shipToCountry = input[30];
        temp.tax = input[31];
        temp.duty = input[32];
        temp.freight = input[33];
        temp.taxExempt = input[34];
        temp.purchaseOrderNumber = input[35];
        temp.MD5Hash = input[36];
        temp.cardCodeResponse = input[37];
        temp.cardHolderAuthenticationVerificationResponse = input[38];
        temp.accountNumber = input[39];
        temp.cardType = input[40];
        temp.splitTenderID = input[41];
        temp.requestAmount = input[42];
        
        return temp;
    }

}

