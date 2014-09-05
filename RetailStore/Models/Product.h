//
//  Product.h
//  RetailStore
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *category;
@property(nonatomic, strong) NSString *subCategory;
@property(nonatomic, assign) NSInteger price;


@end
