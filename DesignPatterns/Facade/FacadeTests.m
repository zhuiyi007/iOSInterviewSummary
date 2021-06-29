//
//  FacadeTests.m
//  testTests
//
//  Created by 张森 on 2021/3/3.
//

#import <XCTest/XCTest.h>
#import "FacadeConvert.h"

@interface FacadeTests : XCTestCase

@end

@implementation FacadeTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testFacade {
    
    FacadeVideo *video = [FacadeConvert convert:@"1.mp4" :@"wmv"];
    XCTAssert([[video getVideoType] isEqualToString:@"wmv"]);
    
    FacadeVideo *video1 = [FacadeConvert convert:@"1.wmv" :@"mp4"];
    XCTAssert([[video1 getVideoType] isEqualToString:@"mp4"]);
}

@end
