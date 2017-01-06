package tidebuy.app.com.react_native_worldpay;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import com.worldpay.cse.WPCardData;
import com.worldpay.cse.WorldpayCSE;
import com.worldpay.cse.exception.WPCSEException;
import com.worldpay.cse.exception.WPCSEInvalidCardData;
import com.worldpay.cse.WPValidationErrorCodes;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import com.facebook.react.bridge.ReadableMap;


public class WorldPayModule extends ReactContextBaseJavaModule {

  ReactApplicationContext reactContext;
  Map<Integer, String> errorList = new HashMap<Integer, String>();

  public WorldPayModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    errorList.put(101,"Credit card number is empty.");
    errorList.put(102,"Invalid credit card number, numbers only and should be between 12 and 20 digits.");
    errorList.put(103,"Invalid credit card number, input doesn't verify Luhn check.");
    errorList.put(201,"Invalid security code, numbers only and should be between 3 and 4 digits.");
    errorList.put(301,"Expiry month is empty.");
    errorList.put(302,"Invalid expiry month; only numbers expected and in XX form (e.g. 09).");
    errorList.put(303,"Invalid expiry month, should range from 01 to 12.");
    errorList.put(304,"Expiry year is mandatory.");
    errorList.put(305,"Invalid expiry year, only numbers expected.");
    errorList.put(306,"Expiry date is not in the future.");
    errorList.put(401,"Card holder's name is empty.");
    errorList.put(402,"Card holder's name exceeds thirty characters.");
  }

  @Override
  public String getName() {
    return "WorldPayModule";
  }


  @ReactMethod
  public void encryptAction( final ReadableMap Parameters,final Callback callback)
  {
    try {

      WorldpayCSE worldpayCSE = new WorldpayCSE();
      worldpayCSE.setPublicKey(Parameters.getString("publicKey"));

      WPCardData cardData = new WPCardData();
      cardData.setCardHolderName(Parameters.getString("cardHolderName"));
      cardData.setCardNumber(Parameters.getString("cardNumber"));
      cardData.setCvc(Parameters.getString("cvc"));
      cardData.setExpiryMonth(Parameters.getString("expiryMonth"));
      cardData.setExpiryYear(Parameters.getString("expiryYear"));

      String encryptedData = worldpayCSE.encrypt(cardData);
      callback.invoke(null,encryptedData);
    }catch (WPCSEInvalidCardData e){
      callback.invoke(displayFormFieldErrors(e.getErrorCodes()),null);
    }catch (WPCSEException e){
      callback.invoke(e.getMessage(),null);
    }
  }

  //Matches the error codes obtained after card data validation with the corresponding fields
  private String displayFormFieldErrors(Set<Integer> errorCodes) {
    String msg="";
    //cardHolder
    msg+= getErrorMessage(errorCodes,
            WPValidationErrorCodes.EMPTY_CARD_HOLDER_NAME,
            WPValidationErrorCodes.INVALID_CARD_HOLDER_NAME);

    //cardNumber
    msg+="\r\n"+getErrorMessage(errorCodes,
            WPValidationErrorCodes.EMPTY_CARD_NUMBER,
            WPValidationErrorCodes.INVALID_CARD_NUMBER_BY_LUHN,
            WPValidationErrorCodes.INVALID_CARD_NUMBER);

    //cardExpiryMonth
    msg+="\r\n"+getErrorMessage(errorCodes,
            WPValidationErrorCodes.EMPTY_EXPIRY_MONTH,
            WPValidationErrorCodes.INVALID_EXPIRY_MONTH,
            WPValidationErrorCodes.INVALID_EXPIRY_MONTH_OUT_RANGE,
            WPValidationErrorCodes.INVALID_EXPIRY_DATE);

    //cardExpiryYear
    msg+="\r\n"+getErrorMessage(errorCodes,
            WPValidationErrorCodes.EMPTY_EXPIRY_YEAR,
            WPValidationErrorCodes.INVALID_EXPIRY_YEAR,
            WPValidationErrorCodes.INVALID_EXPIRY_DATE);

    //cardCVC
    msg+="\r\n"+getErrorMessage(errorCodes, WPValidationErrorCodes.INVALID_CVC);

    return  msg;
  }

  //Returns the error message for the provided 'errorCodes' parameter that a contained in 'errorRange'
  private String getErrorMessage(Set<Integer> errorCodes, int...errorRange) {
    for (int code: errorRange) {
      if (errorCodes.contains(code)) {
        return errorList.get(code);
      }
    }
    return null;
  }
}