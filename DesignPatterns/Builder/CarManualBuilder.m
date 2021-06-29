//
//  CarManualBuilder.m
//  test
//
//  Created by 张森 on 2021/1/28.
//

#import "CarManualBuilder.h"

@interface CarManualBuilder ()

@property (nonatomic, strong) Manual *manual;
@end

@implementation CarManualBuilder

- (void)reset {
    
    self.manual = [Manual new];
}

- (void)setSeat:(NSUInteger)seat {
    
    self.manual.seats = seat;
}
- (void)setWindow:(NSUInteger)window {
    
    self.manual.window = window;
}
- (void)setGPS:(NSString *)GPS {
    
    self.manual.GPS = GPS;
}

- (Manual *)getProduct {
    
    return self.manual;
}
@end
