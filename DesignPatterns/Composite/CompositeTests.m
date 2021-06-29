//
//  CompositeTests.m
//  testTests
//
//  Created by 张森 on 2021/2/9.
//

#import <XCTest/XCTest.h>
#import "ConpositeHeader.h"

@interface CompositeTests : XCTestCase

@end

@implementation CompositeTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testPrice {
    
    CompositeBox *box = [CompositeBox creatBox];
    
    // 第一层嵌套
    CompositeBox *box_1 = [CompositeBox creatBox];
    [box add:box_1];
    CompositeProduct *product_1 = [CompositeProduct creatProduct:2];
    [box_1 add:product_1];
    CompositeProduct *product_2 = [CompositeProduct creatProduct:3];
    [box_1 add:product_2];
    
    CompositeBox *box_2 = [CompositeBox creatBox];
    [box add:box_2];
    CompositeProduct *product_3 = [CompositeProduct creatProduct:4];
    [box_2 add:product_3];
    
    // 第二层嵌套
    CompositeBox *box_1_1 = [CompositeBox creatBox];
    [box_1 add:box_1_1];
    CompositeProduct *product_1_1 = [CompositeProduct creatProduct:5];
    [box_1_1 add:product_1_1];
    CompositeProduct *product_1_2 = [CompositeProduct creatProduct:7];
    [box_1_1 add:product_1_2];
    CompositeBox *box_1_2 = [CompositeBox creatBox];
    [box_1 add:box_1_2];
    CompositeBox *box_2_1 = [CompositeBox creatBox];
    [box_2 add:box_2_1];
    CompositeProduct *product_2_1 = [CompositeProduct creatProduct:10];
    [box_2_1 add:product_2_1];
    
    // 第三层嵌套
    CompositeBox *box_1_1_1 = [CompositeBox creatBox];
    [box_1_1 add:box_1_1_1];
    CompositeProduct *product_1_1_1 = [CompositeProduct creatProduct:15];
    [box_1_1_1 add:product_1_1_1];
    
    XCTAssert([box_1_1_1 price] == 16);
    XCTAssert([box_1_1 price] == 29);
    XCTAssert([box_1_2 price] == 1);
    XCTAssert([box_2_1 price] == 11);
    XCTAssert([box_1 price] == 36);
    XCTAssert([box_2 price] == 16);
    XCTAssert([box price] == 53);
    [box_1 remove:box_1_1];
    XCTAssert([box_1 price] == 7);
    XCTAssert([box price] == 24);
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

@end
