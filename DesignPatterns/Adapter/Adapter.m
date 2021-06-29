//
//  Adapter.m
//  test
//
//  Created by 张森 on 2021/1/27.
//

#import "Adapter.h"

@interface Adapter ()

@property (nonatomic, strong) XMLFormatFile *content;
@end

@implementation Adapter

+ (Adapter *)getJSONFormatFile:(XMLFormatFile *)xmlFile {
    
    Adapter * adapter = [Adapter new];
    adapter.content = xmlFile;
    return adapter;
}

- (NSString *)getJSONContent {
    
    return [self.content getXMLContent];
}
@end
