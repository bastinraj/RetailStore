//
//  ProductTableViewCell.h
//  RetailStore
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *productCategory;
@property(nonatomic, strong) IBOutlet UIImageView *productImageView;

@end
