//
//  Shape.h
//  test
//
//  Created by 张森 on 2021/1/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Shape : NSObject

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, strong) NSString *mark;

- (Shape *)clone;
@end

NS_ASSUME_NONNULL_END
