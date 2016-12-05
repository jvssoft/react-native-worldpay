#import "RNWorldPay.h"
#import "RCTBridge.h"
#import <WorldpayCSE/WorldpayCSE.h>

@implementation RNWorldPay

RCT_EXPORT_MODULE(RNWorldPay);

RCT_EXPORT_METHOD(encryptAction:(NSString *)cardHolderName
                  cardNumber:(NSString *)cardNumber
                  cvc:(NSString *) cvc
                  expiryMonth:(NSString *) expiryMonth
                  expiryYear:(NSString *) expiryYear)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        
        WorldpayCSE *wpCSE = [WorldpayCSE new];
        
        // set public key
        [wpCSE setPublicKey:@"1#10001#9de941921bee6b4dac397812a6f9a3d44561ad1a5a9fa8ddc50c70ba1b88ece7512e2f6f57ede3b111df63766b66c3daccf3fcd4f0cf3971b25ddc6cf2ccf0f47a7bfc93555ca7bd92f7dadad9ce5bcd2b70a2da41baf95ddfe45d436092e4f8dd66adbb3c8b3937deed0833e24f5f85014a1f8acc76586b776abc8c1adef1d910f7fa6f6187ef4a7dc6b6bf22bc9d7f1fd2d39f406eb59896b68dc158eb8357665ff84da09030d5094a44be783dad1f1c3f582c07245dbabdf5a845f5e2fa090e5a1670e3eef0bc11086a804f55a86902c3c03542316d584122794dcdc57efb3ba9554fd452df032959e0211c415eedb73fac7714c0ca2abf453a711b861799"
                      error:&error];
        
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
        //return encryptedData;
        // [self fireEvent:@"Success" withData:encryptedData];
    });
}


@end
