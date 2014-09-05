//
//  ProductViewController.m
//  RetailStore
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductTableViewCell.h"
#import "ProductDetailViewController.h"
#import "CartViewController.h"
#import "Product.h"
#import "AppDelegate.h"
#import "Helper.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

@synthesize managedObjectContext;

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
    
    // Initialize method call to setup view controller and its associated data
    [self initialize];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// This method initializes required data source for table view
-(void) initialize
{
    // Add cart button on right side of navigation bar
    [self setupNavigationBarItems];
    
    // Electronics category products
    NSArray *electronics = [NSArray arrayWithObjects:@"Microwave oven", @"Television", @"Vacuum Cleaner", nil];
    
    // Furniture category products
    NSArray *furnitures = [NSArray arrayWithObjects:@"Table", @"Chair", @"Almirah", @"Sofa",nil];
    
    // Initialize dictionary for Electronics category
    NSMutableDictionary *electronicsDictionary = [[NSMutableDictionary alloc] init];
    
    // Add electrincs to data source array
    [electronicsDictionary setObject:electronics forKey: @"Electronics"];
    
    // Initialize dictionary for Furniture category
    NSMutableDictionary * furnitureDictionary = [[NSMutableDictionary alloc] init];
    
    // Add furnitures to data source array
    [furnitureDictionary setObject:furnitures forKey: @"Furnitures"];
    
    // Add both dictionaries to data source array
    dataSource = [[NSMutableArray alloc] init];
    
    [dataSource addObject: electronicsDictionary];
    [dataSource addObject: furnitureDictionary];
    
    
    // Initialize core data NSManagedObjectContext to interect with core data model
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = delegate.managedObjectContext;
}


// Method to add required setup of navigation bar. Add cart button on top right side
-(void) setupNavigationBarItems
{
    // Set up navigation bar title
    self.title = @"Products";
    
    // Add cart image on right side of navigation controller
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cart.png"] style: UIBarButtonItemStylePlain target: self action:@selector(goToCartAction)];
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

#pragma mark - UITableViewDataSourceDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *categoryDict = [dataSource objectAtIndex: section];
    NSArray  *categories = [categoryDict objectForKey: [categoryDict.allKeys objectAtIndex: 0]];
    
    return categories.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductTableViewCell *cell = nil;
    NSString *cellIdentifier = @"ProductTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed: cellIdentifier owner: nil options: nil];
        cell = [nibContents objectAtIndex: 0];
    }
    
    // Set cell category's name and its details
    NSDictionary *categoryDict = [dataSource objectAtIndex: indexPath.section];
    NSString *productCategory = [categoryDict.allKeys objectAtIndex: 0];
    
    NSArray *product = [categoryDict objectForKey: productCategory];  // Get categories array from its key
    NSString *productSubCategory = [product objectAtIndex: indexPath.row];
    
    // Set sub-category image
    cell.productImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", productSubCategory]];
    
     // Set sub-category name
    cell.productCategory.text = productSubCategory;

    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *categoryDict = [dataSource objectAtIndex: section];
    return [categoryDict.allKeys objectAtIndex: 0];
}


#pragma mark -UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: kStoryboardName bundle: nil];
    
    
    // Set cell category's name and its details
    NSDictionary *categoryDict = [dataSource objectAtIndex: indexPath.section];
    NSString *productCategory = [categoryDict.allKeys objectAtIndex: 0];
    
    NSArray *product = [categoryDict objectForKey: productCategory];  // Get categories array from its key
    NSString *productSubCategory = [product objectAtIndex: indexPath.row];
    
    NSArray *products = [self getSelectedCategoryProducts: productSubCategory];
    
    ProductDetailViewController *detailsController = (ProductDetailViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
    [self.navigationController pushViewController: detailsController animated: YES];
    detailsController.dataSource = products;
}


// Method to retrieve selected category products from database
-(NSMutableArray *) getSelectedCategoryProducts: (NSString *) subCategory
{
    NSMutableArray *products = [[NSMutableArray alloc] init];
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Product" inManagedObjectContext: self.managedObjectContext];
    [fetchRequest setEntity: entityDesc];
    
    // Get records only for the passed sub-category
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_subcategory == %@", subCategory];
    [fetchRequest setPredicate: predicate];
    
    NSArray *fetchedObject = [self.managedObjectContext executeFetchRequest: fetchRequest error: &error];
    for (NSManagedObject *object in fetchedObject)
    {
        NSString *name = [object valueForKey:@"product_name"];
        NSString *category = [object valueForKey:@"product_category"];
        NSInteger price = [[object valueForKey:@"product_price"] integerValue];
        
        // Once record or data retrieved, Add it to products array
        Product *product = [[Product alloc] init];
        product.name = name;
        product.category = category;
        product.subCategory = subCategory;
        product.price = price;
    
        [products addObject: product];
    }
    
    return products;
}


@end
