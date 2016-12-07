package tidebuy.app.com.react_native_worldpay;

import android.content.res.Configuration;
import android.os.Build;
import android.provider.Settings.Secure;

import com.facebook.react.bridge.Callback;
import com.worldpay.cse.WPCardData;
import com.worldpay.cse.WorldpayCSE;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.worldpay.cse.exception.WPCSEException;
import com.worldpay.cse.exception.WPCSEInvalidCardData;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import com.facebook.react.bridge.ReadableMap;

import javax.annotation.Nullable;

public class WorldPayModule extends ReactContextBaseJavaModule {

  ReactApplicationContext reactContext;

  public WorldPayModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "WorldPayPackage";
  }



  public void encrypt(final ReadableMap payPalParameters,final Callback _callback){
    WPCardData cardData = new WPCardData();
    final String publicKey = payPalParameters.getString("publicKey");
    final String cardNumber=payPalParameters.getString("cardNumber");
    final String cvc=payPalParameters.getString("cvc");
    final String expiryMonth=payPalParameters.getString("expiryMonth");
    final String expiryYear=payPalParameters.getString("expiryYear");
    final String cardHolderName=payPalParameters.getString("cardHolderName");
    WorldpayCSE worldpayCSE = new WorldpayCSE();
    worldpayCSE.setPublicKey(publicKey);
    try  {
      String encryptedData = worldpayCSE.encrypt(cardData);
    }  catch  (WPCSEInvalidCardData e)  {
      //Alternatively to catching this exception, there is a convenient method
      //WorldpayCSE#validate(WPCardData)that can be used for a similar purpose
      //displayFormFieldErrors(e.getErrorCodes());
    }  catch (WPCSEException e)  {
      //show error message
    }
  }
}
