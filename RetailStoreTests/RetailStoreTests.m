//
//  RetailStoreTests.m
//  RetailStoreTests
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"

@interface RetailStoreTests : XCTestCase

@end

@implementation RetailStoreTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void) testManagedObjectContext
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    XCTAssertNotNil(appDelegate.managedObjectContext, @"Core data managed object is not nil..");
    
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
