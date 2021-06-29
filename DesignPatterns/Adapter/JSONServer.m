//
//  JSONServer.m
//  test
//
//  Created by 张森 on 2021/1/27.
//

#import "JSONServer.h"

@implementation JSONServer

+ (void)excuteJSONFormatFile:(JSONFormatFile *)file {
    
    NSLog(@"%@", [file getJSONContent]);
}
@end
