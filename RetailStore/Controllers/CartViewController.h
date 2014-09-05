//
//  CartViewController.h
//  RetailStore
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewController : UIViewController <UIAlertViewDelegate>
{
    NSManagedObjectContext *managedObjectContext;
    NSInteger selectedIndex;
}

@property(nonatomic, strong) IBOutlet UILabel *grandTotal;
@property(nonatomic, strong) NSMutableArray *products;
@property(nonatomic, retain) IBOutlet UITableView *cartTableView;

@end
