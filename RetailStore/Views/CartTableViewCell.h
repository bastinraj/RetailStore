//
//  CartTableViewCell.h
//  RetailStore
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableViewCell : UITableViewCell


@property(nonatomic, strong) IBOutlet UIImageView *productImageView;
@property(nonatomic, strong) IBOutlet UILabel *productName;
@property(nonatomic, strong) IBOutlet UILabel *productCategory;
@property(nonatomic, strong) IBOutlet UILabel *productPrice;
@property(nonatomic, strong) IBOutlet UIButton *cartRemoveButton;

@end
