//
//  ProductViewController.h
//  RetailStore
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dataSource;
}

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
