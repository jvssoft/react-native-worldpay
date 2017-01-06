#import "RNWorldPay.h"
#import "RCTConvert.h"
#import <WorldpayCSE/WorldpayCSE.h>

@implementation RNWorldPay

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(encryptAction:(NSDictionary *)details findEvents:(RCTResponseSenderBlock)callback)
{
    NSDictionary *errorCodeMsgMap = @{
                                      @(WPCardValidatorErrorEmptyCardNumber) :  @"Credit card number is mandatory.",
                                      @(WPCardValidatorErrorInvalidCardNumber) : @"Enter a valid credit card number; numbers only and should be between 12 and 20 digits.",
                                      @(WPCardValidatorErrorInvalidCardNumberLuhn) : @"Enter a valid credit card number; input doesn't verify Luhn check.",
                                      @(WPCardValidatorErrorInvalidSecurityCode) : @"Enter a valid security code; numbers only and should be between 3 and 4 digits.",
                                      @(WPCardValidatorErrorEmptyExpiryMonth) : @"Expiry month is mandatory.",
                                      @(WPCardValidatorErrorInvalidExpiryMonthValue) : @"Enter a valid expiry month; only numbers expected and in XX form (e.g. 09).",
                                      @(WPCardValidatorErrorInvalidExpiryMonthRange) : @"Enter a valid expiry month; should range from 01 to 12.",
                                      @(WPCardValidatorErrorEmptyExpiryYear) : @"Expiry year is mandatory.",
                                      @(WPCardValidatorErrorInvalidExpiryYearValue) : @"Enter a valid expiry year; only numbers expected.",
                                      @(WPCardValidatorErrorExpiryYearFromPast) : @"Expiry date should be in future.",
                                      @(WPCardValidatorErrorEmpyCardholderName) : @"Card holder's name is mandatory.",
                                      @(WPCardValidatorErrorCardholderNameTooLong) : @"Name should not exceed thirty characters."
                                      };
    
    NSString *publicKey =
    @"1#10001#9de941921bee6b4dac397812a6f9a3d44561ad1a5a"
    "9fa8ddc50c70ba1b88ece7512e2f6f57ede3b111df63766b66"
    "c3daccf3fcd4f0cf3971b25ddc6cf2ccf0f47a7bfc93555ca7"
    "bd92f7dadad9ce5bcd2b70a2da41baf95ddfe45d436092e4f8"
    "dd66adbb3c8b3937deed0833e24f5f85014a1f8acc76586b77"
    "6abc8c1adef1d910f7fa6f6187ef4a7dc6b6bf22bc9d7f1fd2"
    "d39f406eb59896b68dc158eb8357665ff84da09030d5094a44"
    "be783dad1f1c3f582c07245dbabdf5a845f5e2fa090e5a1670"
    "e3eef0bc11086a804f55a86902c3c03542316d584122794dcd"
    "c57efb3ba9554fd452df032959e0211c415eedb73fac7714c0"
    "ca2abf453a711b861799";
    
    NSString *cardHolderName=details[@"cardHolderName"];
    NSString *cardNumber = details[@"cardNumber"];
    NSString *cvc = details[@"cvc"];
    NSString *expiryMonth = details[@"expiryMonth"];
    NSString *expiryYear =details[@"expiryYear"];
    NSError *error = nil;
    
    WorldpayCSE *wpCSE = [WorldpayCSE new];
    
    // set public key
    [wpCSE setPublicKey:publicKey error:&error];
    
    if (error != nil) {
        // [self showErrorMessage:@"Invalid public key."];
        //return @"Invalid public key.";
        //[self fireEvent:@"Error" withData:@"Invalid public key."];
    }
    
    // set card data
    WPCardData *cardData = [[WPCardData alloc] init];
    cardData.cardHolderName = cardHolderName;
    cardData.cardNumber = cardNumber;
    cardData.cvc = cvc;
    cardData.expiryMonth = expiryMonth;
    cardData.expiryYear =expiryYear;
    
    // encrypt card data and validate
    NSString *encryptedData = [wpCSE encrypt:cardData error:&error];
    
    if (error) {
        NSString *errorMessage = [error description];
        
        if (error.code == WPErrorInvalidCardData) {
            NSArray *cardValidationErrors = error.userInfo[kWPErrorDetailsKey];
            
            //errorMessage = @"Invalid card data.\n";
            for (NSNumber *errorCode in cardValidationErrors) {
                errorMessage = [errorMessage stringByAppendingFormat:@"%@",errorCodeMsgMap[errorCode]];
            }
        }
        callback(@[errorMessage, @""]);
    }else{
        callback(@[[NSNull null], encryptedData]);
    }
    
}


@end
