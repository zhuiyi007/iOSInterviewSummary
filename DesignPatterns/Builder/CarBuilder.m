//
//  CarBuilder.m
//  test
//
//  Created by 张森 on 2021/1/28.
//

#import "CarBuilder.h"

@interface CarBuilder ()

@property (nonatomic, strong) Car *car;
@end

@implementation CarBuilder

- (void)reset {
    
    self.car = [Car new];
}

- (void)setSeat:(NSUInteger)seat {
    
    self.car.seats = seat;
}
- (void)setWindow:(NSUInteger)window {
    
    self.car.window = window;
}
- (void)setGPS:(NSString *)GPS {
    
    self.car.GPS = GPS;
}

- (Car *)getProduct {
    
    return self.car;
}
@end
