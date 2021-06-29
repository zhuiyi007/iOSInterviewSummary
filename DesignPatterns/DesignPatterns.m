//
//  DesignPatterns.m
//  test
//
//  Created by 张森 on 2021/2/8.
//

#import "DesignPatterns.h"
#import "BridgeHeader.h"
@implementation DesignPatterns

+ (void)test {
    // DesignPatterns
//    [Factory run];
//    [AbstractFactory run:2];
//    [JSONServer excuteJSONFormatFile:[Adapter getJSONFormatFile:[XMLFormatFile new]]];
    
//    Director *director = [Director new];
//    CarBuilder *carBuilder = [CarBuilder new];
//    [director getSUVCar:carBuilder];
//    Car *car = [carBuilder getProduct];
//
//    CarManualBuilder *manualBuilder = [CarManualBuilder new];
//    [director getSUVCarManual:manualBuilder];
//    Manual *maunal = [manualBuilder getProduct];
}

/// 桥接模式
+ (void)bridge {
    
    RemoteController *controller = [RemoteController new];
    
    TV *tv = [TV new];
    controller.device = tv;
    [controller power];
    [controller channelUp];
    [controller volumeDown];
    
    Radio *radio = [Radio new];
    controller.device = radio;
    [controller power];
    [controller channelDown];
    [controller volumeUp];
}
@end
