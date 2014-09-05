//
//  ProductDetailTableViewCell.m
//  RetailStore
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import "ProductDetailTableViewCell.h"

@implementation ProductDetailTableViewCell


@synthesize productImageView;
@synthesize productName;
@synthesize productCategory;
@synthesize productPrice;
@synthesize addToCartButton;


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
