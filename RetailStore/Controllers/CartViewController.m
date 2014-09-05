//
//  CartViewController.m
//  RetailStore
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import "Product.h"
#import "AppDelegate.h"

@interface CartViewController ()
{
}

@end

@implementation CartViewController

@synthesize grandTotal;
@synthesize products;
@synthesize cartTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


#pragma mark - UIViewController life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    // Initialize table data source
    [self initialize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) initialize
{
    // Initialize core data NSManagedObjectContext to interect with core data model
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    managedObjectContext = delegate.managedObjectContext;
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    
    // Set Cart summary price total. Calculate total price
    NSInteger totalPrice = 0;
    for (Product *product in products)
    {
        totalPrice += product.price;
    }
    
    // Set grand total price label text
    self.grandTotal.text = [NSString stringWithFormat: @"$%ld", totalPrice];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartTableViewCell *cell = nil;
    NSString *cellIdentifier = @"CartTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed: cellIdentifier owner: nil options: nil];
        cell = [nibContents objectAtIndex: 0];
    }
    
    // Set cell's product name, category price and add cart button action
    Product *product = [products objectAtIndex: indexPath.row];
    
    cell.productName.text = product.name;    // product name
    cell.productImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", product.subCategory]];  // product image
    cell.productCategory.text = [NSString stringWithFormat:@"%@: %@", product.category, product.subCategory];    // product category
    cell.productPrice.text = [NSString stringWithFormat:@"$%ld", product.price];    // product price
    [cell.cartRemoveButton addTarget: self action:@selector(cartDeleteButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    
    // Set tag to know which button has been clicked
    cell.cartRemoveButton.tag = indexPath.row;
    
    return cell;
}



#pragma mark -UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}


#pragma mark - User defined methods
// Method to delete Cart object from core data persistent
-(void) cartDeleteButtonAction: (UIButton *) cartButton
{
    selectedIndex = cartButton.tag;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to delete this product from Cart?" delegate: self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    
    [alertView show];
}


// After getting conformation from user this method will get called to remove from database and table view
-(void) removeProductFromCart
{
    NSError *error = nil;
    // Get current selected product
    Product *selectedProduct = [products objectAtIndex: selectedIndex];
    
    // Delete record from core data model
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Cart" inManagedObjectContext: managedObjectContext];
    [fetchRequest setEntity: entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_name == %@ AND product_price == %d", selectedProduct.name, selectedProduct.price];
    [fetchRequest setPredicate: predicate];
    
    NSArray *fetchedObject = [managedObjectContext executeFetchRequest:fetchRequest error: &error];
    for (NSManagedObject *object in fetchedObject)
    {
        [managedObjectContext deleteObject:  object];
    }
    
    NSError *deleteError = nil;
    if (![managedObjectContext save:&deleteError])
    {
        NSLog(@"ERROR: Error while deleting product (%@) from Cart: %@", selectedProduct.name, [deleteError userInfo]);
    }
    else
    {
        NSLog(@"INFO: Product (%@) successfully removed from Cart..!", selectedProduct.name);
    }
    
    // Delete from table view data source array and reload table view to show updated Cart items
    [products removeObject: selectedProduct];
    [self.cartTableView reloadData];
    
    // Update grand total price label
    NSInteger totalPrice = 0;
    for (Product *product in products)
    {
        totalPrice += product.price;
    }
    // Set grand total price label text
    self.grandTotal.text = [NSString stringWithFormat: @"$%ld", totalPrice];
}


#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) // Yes button clicked
    {
        [self removeProductFromCart];
    }
    else
    {
        // No button clicked. Ignore
    }
}


@end
