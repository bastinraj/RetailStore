//
//  ProductDetailViewController.m
//  RetailStore
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductDetailTableViewCell.h"
#import "CartViewController.h"
#import "Product.h"
#import "AppDelegate.h"
#import "Helper.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

@synthesize dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - UIViewController life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize method call to setup view controller and its associated data
    [self initialize];
    
    // View controller navigation bar setup
    [self setupNavigationBarItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// This method initializes table data source
-(void) initialize
{
    // Initialize core data NSManagedObjectContext to interect with core data model
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = delegate.managedObjectContext;
}


-(void) setupNavigationBarItems
{
    // Set navigation bar title
    self.title = @"Product Details";
    
    // Add cart image on right side of navigation controller
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cart.png"] style: UIBarButtonItemStylePlain target: self action:@selector(goToCartAction)];
}


// Method to go cart view controller
-(void) goToCartAction
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailTableViewCell *cell = nil;
    NSString *cellIdentifier = @"ProductDetailTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed: cellIdentifier owner: nil options: nil];
        cell = [nibContents objectAtIndex: 0];
    }
    
    // Set cell's product name, category price and add cart button action
    Product *product = [dataSource objectAtIndex: indexPath.row];
    
    cell.productName.text = product.name;    // product name
    cell.productImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", product.subCategory]];  // product image
    cell.productCategory.text = [NSString stringWithFormat:@"%@: %@", product.category, product.subCategory];    // product category
    cell.productPrice.text = [NSString stringWithFormat:@"$%ld", product.price];    // product price
    [cell.addToCartButton addTarget: self action:@selector(addToCartButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    
    // Set tag to know which button has been clicked
    cell.addToCartButton.tag = indexPath.row;
    
    return cell;
}


#pragma mark -UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115.0f;
}


// This method gets called when we click add cart button
-(void) addToCartButtonAction: (UIButton *) cartButton
{
    // Get current selected product
    Product *selectedProduct = [dataSource objectAtIndex: cartButton.tag];

    // Insert selected product into Cart object
    NSManagedObjectContext *modelContext = [self managedObjectContext];
    NSManagedObject *cartInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:modelContext];
    [cartInfo setValue:selectedProduct.name forKey:@"product_name"];
    [cartInfo setValue:selectedProduct.category forKey:@"product_category"];
    [cartInfo setValue:selectedProduct.subCategory forKey:@"product_subcategory"];
    [cartInfo setValue:[NSNumber numberWithInteger: selectedProduct.price] forKey:@"product_price"];
    
    NSError *error;
    if (![modelContext save:&error])
    {
        NSLog(@"ERROR: Error while inserting selected Cart (%@) into database: %@", selectedProduct.name, [error localizedDescription]);
    }
    else
    {
        NSLog(@"INFO: Successfully inserted Cart (%@) into database.!", selectedProduct.name);
    }

}

@end
