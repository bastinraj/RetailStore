//
//  ProductDetailViewController.h
//  RetailStore
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController
{
    NSArray *dataSource;
}

@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
