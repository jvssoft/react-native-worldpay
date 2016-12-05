//
//  RNWorldPay.m
//  RNWorldPay
//
//  Created by tidebuy-air on 2016/12/4.
//  Copyright © 2016年 tidebuy-air. All rights reserved.
//

#import "RNWorldPay.h"
#import <WorldpayCSE/WorldpayCSE.h>
@implementation RNWorldPay

//包含RCT_EXPORT_MODULE()宏
RCT_EXPORT_MODULE(RNWorldPay);

//导出testPrint方法
RCT_EXPORT_METHOD(testPrint:(NSString *)name info:(NSDictionary *)info) {
        //RCTLogInfo(@"%@: %@", name, info);
}
    
//导出encryptAction方法
RCT_EXPORT_METHOD(encryptAction:(NSString *)name info:(NSDictionary *)info) {
    NSError *error = nil;
    
    WorldpayCSE *wpCSE = [WorldpayCSE new];
    
    // set public key
    [wpCSE setPublicKey:
     @"1#10001#00ccca2c4ef80be7f7a98d5e0eef7e5e6eafe700ef054"
     "c07fa73cf86cd78d141f923cff2fb70afb40be36ec78c7a334ef2"
     "3451c34cc8df03c2f496cd7f4fcccfd35aba72417c859d7e5e960"
     "a5d1667010bb6d9d87b12d836405a5fb11ba28bb3a5e98e1c89d0"
     "65fc47de9d11bfac053b3d6550207752724d9fa31ec2255d4952a"
     "0dd0dc4f2be8a669b48eb247a1df5d94d921435af66588568999e"
     "6a984152c53af211aab64edcd94a0ce1aceb66c50c0d3c074bac3"
     "0d6f0ba81a367a03c3b94f17a6b896d34360dd7f459b715555dc0"
     "8ece11fc451ffe26a089a93122a699958d2ab8a4da4d2586474fc"
     "6e777a558d802381488c24a74cff4fcce3104e727ede3"
                  error:&error];
    
    if (error != nil) {
       // [self showErrorMessage:@"Invalid public key."];
        return;
    }
    
    // set card data
    WPCardData *cardData = [[WPCardData alloc] init];
    cardData.cardHolderName = @"";
    cardData.cardNumber = @"";
    cardData.cvc = @"";
    cardData.expiryMonth = @"";
    cardData.expiryYear = @"";
    
    // encrypt card data and validate
    NSString *encryptedData = [wpCSE encrypt:cardData error:&error];
    
    // handle error
    if (error) {
        NSString *errorMessage = [error description];
        
        if (error.code == WPErrorInvalidCardData) {
            NSArray *cardValidationErrors = error.userInfo[kWPErrorDetailsKey];
            
            errorMessage = @"Invalid card data.\n";
            for (NSNumber *errorCode in cardValidationErrors) {
                errorMessage = [errorMessage stringByAppendingFormat:@"%@\n", errorCode];
            }
        }
        //return encryptedData;
        //[self showErrorMessage:errorMessage];
    }
    
    // show the encrypted data
    //self.encryptedDataView.text = encryptedData;
}
@end
