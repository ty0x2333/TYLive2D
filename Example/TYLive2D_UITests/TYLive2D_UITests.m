//
//  TYLive2D_UITests.m
//  TYLive2D_UITests
//
//  Created by yinhun on 2017/3/22.
//  Copyright © 2017年 luckytianyiyan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TYLive2D_UITests-Swift.h"

@interface TYLive2D_UITests : XCTestCase

@end

@implementation TYLive2D_UITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [Snapshot setupSnapshot:app];
    [app launch];
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}

- (void)testExample {
    [Snapshot snapshot:@"MainScreen" waitForLoadingIndicator:YES];
}

@end
