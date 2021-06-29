//
//  Director.m
//  test
//
//  Created by 张森 on 2021/1/28.
//

#import "Director.h"

@implementation Director

- (void)getSUVCar:(Builder *)build {
    
    [build reset];
    [build setSeat:4];
    [build setWindow:4];
    [build setGPS:@"YES"];
}
- (void)getSportCar:(Builder *)build {
    
    [build reset];
    [build setSeat:2];
    [build setWindow:2];
    [build setGPS:@"NO"];
}

- (void)getSUVCarManual:(Builder *)build {
    
    [build reset];
    [build setSeat:4];
    [build setWindow:4];
    [build setGPS:@"YES"];
}
- (void)getSportCarManual:(Builder *)build {
    
    [build reset];
    [build setSeat:2];
    [build setWindow:2];
    [build setGPS:@"NO"];
}

@end
