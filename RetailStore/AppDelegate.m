//
//  AppDelegate.m
//  RetailStore
//
//  Created by Bastin Raj on 7/25/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "Product.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self insertProductOnce];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




//Explicitly write Core Data accessors
- (NSManagedObjectContext *) managedObjectContext
{
    if (managedObjectContext != nil)
    {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: kSqliteFileName]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:nil error:&error])
    {
        /*Error for store creation should be handled in here*/
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


// Method to insert
-(void) insertProductOnce
{
    if ( [self getProductCount] == 0  )
    {
        // Insert all required products in database
        NSManagedObjectContext *modelContext = [self managedObjectContext];
        
        NSArray *products = [self getAllStoreProducts];  // This method gets all store products and insert into database
        // Insert products in to database
        for (Product *product in products)
        {
            NSManagedObject *productInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:modelContext];
            [productInfo setValue:product.name forKey:@"product_name"];
            [productInfo setValue:product.category forKey:@"product_category"];
            [productInfo setValue:product.subCategory forKey:@"product_subcategory"];
            [productInfo setValue:[NSNumber numberWithInteger: product.price] forKey:@"product_price"];
            
            NSError *error;
            if (![modelContext save:&error])
            {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"Successfully inserted into coredata sqlite..");
            }
        }
        
        // This is for testing
        [self getProductCount];
    }
}


/*
 All store products are hard coded here. But here we are manually inserting some data to populate products
 If we have all products in database or plist, then we could read all those data and populate in product view controller
 */
-(NSMutableArray *) getAllStoreProducts
{
    NSMutableArray *products = [[NSMutableArray alloc] init];
    
    // Category: Electronics & Sub-Category: Television
    //Insert 2 records for all categories
    Product *television1 = [[Product alloc] init];
    television1.name = @"LG LED 32LED";
    television1.category = @"Electronics";
    television1.subCategory = @"Television";
    television1.price = 669;
    [products addObject: television1];
    
    Product *television2 = [[Product alloc] init];
    television2.name = @"Samsung LCD 38LED";
    television2.category = @"Electronics";
    television2.subCategory = @"Television";
    television2.price = 749;
    [products addObject: television2];

    
    // Category: Electronics & Sub-Category: Microwave oven
    Product *microwave1 = [[Product alloc] init];
    microwave1.name = @"Onida 324OOV";
    microwave1.category = @"Electronics";
    microwave1.subCategory = @"Microwave oven";
    microwave1.price = 97;
    [products addObject: microwave1];
    
    Product *microwave2 = [[Product alloc] init];
    microwave2.name = @"Godrej 235GOV";
    microwave2.category = @"Electronics";
    microwave2.subCategory = @"Microwave oven";
    microwave2.price = 80;
    [products addObject: microwave2];
    
    
    // Category: Electronics & Sub-Category: Vacuum Cleaner
    Product *vacuum1 = [[Product alloc] init];
    vacuum1.name = @"BOS DJCL";
    vacuum1.category = @"Electronics";
    vacuum1.subCategory = @"Vacuum Cleaner";
    vacuum1.price = 15;
    [products addObject: vacuum1];
    
    Product *vacuum2 = [[Product alloc] init];
    vacuum2.name = @"AIRC CL03";
    vacuum2.category = @"Electronics";
    vacuum2.subCategory = @"Vacuum Cleaner";
    vacuum2.price = 22;
    [products addObject: vacuum2];
    
    
    // Category: Furniture & Sub-Category: Chair
    Product *chair1 = [[Product alloc] init];
    chair1.name = @"Nilkamal CHA7DF";
    chair1.category = @"Furniture";
    chair1.subCategory = @"Chair";
    chair1.price = 15;
    [products addObject: chair1];
    
    Product *chair2 = [[Product alloc] init];
    chair2.name = @"Life CHA04";
    chair2.category = @"Furniture";
    chair2.subCategory = @"Chair";
    chair2.price = 22;
    [products addObject: chair2];
    
    
    // Category: Furniture & Sub-Category: Table
    Product *table1 = [[Product alloc] init];
    table1.name = @"Nilkamal TAB7GKL";
    table1.category = @"Furniture";
    table1.subCategory = @"Table";
    table1.price = 15;
    [products addObject: table1];
    
    Product *table2 = [[Product alloc] init];
    table2.name = @"Life TAB77Y";
    table2.category = @"Furniture";
    table2.subCategory = @"Table";
    table2.price = 22;
    [products addObject: table2];
    
    
    // Category: Furniture & Sub-Category: Almirah
    Product *almirah1 = [[Product alloc] init];
    almirah1.name = @"WoodPec FURDCDG8";
    almirah1.category = @"Furniture";
    almirah1.subCategory = @"Almirah";
    almirah1.price = 270;
    [products addObject: almirah1];
    
    Product *almirah2 = [[Product alloc] init];
    almirah2.name = @"Heritage FUR345M";
    almirah2.category = @"Furniture";
    almirah2.subCategory = @"Almirah";
    almirah2.price = 330;
    [products addObject: almirah2];
    
    // Category: Furniture & Sub-Category: Sofa
    Product *sofa1 = [[Product alloc] init];
    sofa1.name = @"Home SOA7DF";
    sofa1.category = @"Furniture";
    sofa1.subCategory = @"Sofa";
    sofa1.price = 740;
    [products addObject: sofa1];
    
    Product *sofa2 = [[Product alloc] init];
    sofa2.name = @"Life SO89345";
    sofa2.category = @"Furniture";
    sofa2.subCategory = @"Sofa";
    sofa2.price = 860;
    [products addObject: sofa2];
    
    return products;
}


-(NSInteger) getProductCount
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Product" inManagedObjectContext: self.managedObjectContext];
    [fetchRequest setEntity: entityDesc];
    
    NSArray *fetchedObject = [self.managedObjectContext executeFetchRequest: fetchRequest error: &error];
    return fetchedObject.count;
}

@end
