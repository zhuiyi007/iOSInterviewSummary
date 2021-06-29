//
//  Adapter.h
//  test
//
//  Created by 张森 on 2021/1/27.
//

#import <Foundation/Foundation.h>
#import "JSONFormatFile.h"
#import "XMLFormatFile.h"
NS_ASSUME_NONNULL_BEGIN

@interface Adapter : NSObject

+ (Adapter *)getJSONFormatFile:(XMLFormatFile *)xmlFile;
- (NSString *)getJSONContent;
@end

NS_ASSUME_NONNULL_END
