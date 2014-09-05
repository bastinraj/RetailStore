//
//  ViewController.m
//  RetailStore
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import "MainViewController.h"
#import "Helper.h"
#import "CartViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController


#pragma mark - UIViewController life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Cart button action
-(IBAction) goToCartAction:(id) sender
{
    // Get all added products into Cart
    Helper *helper = [[Helper alloc] init];
    NSMutableArray *cartProducts = [helper retrieveAllCartProducts];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:kStoryboardName bundle: nil];
    CartViewController *cartController = (CartViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"CartViewController"];
    [self.navigationController pushViewController: cartController animated: YES];
    cartController.products = cartProducts;
    
    // Helper object no longer required
    helper = nil;
}

@end
