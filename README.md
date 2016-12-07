# react-native-worldpay
react-native-worldpay api

IOS

1.drop RNWorldPay.xcodeproj to you ios project
2.BuildPhases ->Link Binary With Libraries ->choose libRNWorldPay
2.Clean and Build you project


Android

in app build.gradle
add  
//react-native-worldpay
compile project(':react-native-worldpay')
in Application 
add
new WorldPayPackage(),

just for this
