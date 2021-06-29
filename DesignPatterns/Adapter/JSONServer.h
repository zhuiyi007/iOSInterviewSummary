//
//  JSONServer.h
//  test
//
//  Created by 张森 on 2021/1/27.
//

#import <Foundation/Foundation.h>
#import "JSONFormatFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSONServer : NSObject

+ (void)excuteJSONFormatFile:(JSONFormatFile *)file;

@end

NS_ASSUME_NONNULL_END
