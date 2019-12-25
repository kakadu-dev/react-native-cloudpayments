package com.rncloudpayments;

import android.content.Intent;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import ru.cloudpayments.sdk.cp_card.CPCard;
import ru.cloudpayments.sdk.three_ds.ThreeDsDialogFragment;


public class CloudPayments extends ReactContextBaseJavaModule {
  public CloudPayments(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  public String getName() {
    return "RNCloudPayments";
  }

  @ReactMethod
  public void isValidNumber(String cardNumber, Promise promise) {
    try {
      String validFormatNumber = cardNumber.replace(" ", "");
      boolean numberStatus = CPCard.isValidNumber(validFormatNumber);

      promise.resolve(numberStatus);
    } catch (Exception e) {
      promise.reject(e.getMessage());
    }
  }

  @ReactMethod
  public void isValidExpired(String cardExpired, Promise promise) {
    try {
      String validFormatExp = cardExpired.replace("/", "");
      boolean expiredStatus = CPCard.isValidExpDate(validFormatExp);

      promise.resolve(expiredStatus);
    } catch (Exception e) {
      promise.reject(e.getMessage());
    }
  }

  @ReactMethod
  public void getType(String cardNumber, String cardExp, String cardCvv, Promise promise) {
    try {
      CPCard card = new CPCard(cardNumber, cardExp, cardCvv);

      String cardType = card.getType();

      promise.resolve(cardType);
    } catch (Exception e) {
      promise.reject(e.getMessage());
    }
  }

  @ReactMethod
  public void createCryptogram(String cardNumber, String cardExp, String cardCvv, String publicId, Promise promise) {
    try {
      String validFormatNumber = cardNumber.replace(" ", "");
      String validFormatExp = cardExp.replace("/", "");

      CPCard card = new CPCard(validFormatNumber, validFormatExp, cardCvv);

      String cryptoprogram = card.cardCryptogram(publicId);

      promise.resolve(cryptoprogram);
    } catch (Exception e) {
      e.printStackTrace();
      promise.reject(e.getMessage());
    }
  }

  @ReactMethod
  public void show3DS(String acsUrl, String paReq, String transactionId, Promise promise) {
    try {
      Intent intent = new Intent(getReactApplicationContext(), CheckoutActivity.class);

      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

      CheckoutActivity.acsUrl = acsUrl;
      CheckoutActivity.paReq = paReq;
      CheckoutActivity.transactionId = transactionId;
      CheckoutActivity.promise = promise;

      getReactApplicationContext().startActivity(intent);
    } catch (Exception e) {
      promise.reject(e.getMessage());
    }
  }
}