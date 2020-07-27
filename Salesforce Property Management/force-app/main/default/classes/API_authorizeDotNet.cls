
public class API_authorizeDotNet {
    // variables to hold our login credentials
    public static string APILOGIN;
    public static string APITRANSKEY;

    public static void getAuthNetCreds() {
        Authorize_Net_Setting__c apiLoginSetting = Authorize_Net_Setting__c.getInstance('API Login');
        Authorize_Net_Setting__c apiTransKeySetting = Authorize_Net_Setting__c.getInstance('TransKey');
        System.debug(apiLoginSetting);
        SYstem.debug(apiTransKeySetting);
    }
}

