//
//  Helper.m
//  RetailStore
//
//  Created by Bastin Raj on 7/28/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import "Helper.h"
#import "AppDelegate.h"
#import "Product.h"

@implementation Helper


-(NSMutableArray *) retrieveAllCartProducts
{
    NSMutableArray *cartProducts = [[NSMutableArray alloc] init];
    
    // Initialize core data NSManagedObjectContext to interect with core data model
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    managedObjectContext = delegate.managedObjectContext;
    
    // Get all Cart objects
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Cart" inManagedObjectContext: managedObjectContext];
    [fetchRequest setEntity: entityDesc];
    
    NSArray *fetchedObject = [managedObjectContext executeFetchRequest: fetchRequest error: &error];
    for (NSManagedObject *object in fetchedObject)
    {
        NSString *name = [object valueForKey:@"product_name"];
        NSString *category = [object valueForKey:@"product_category"];
        NSString *subCategory = [object valueForKey:@"product_subcategory"];
        NSInteger price = [[object valueForKey:@"product_price"] integerValue];
        
        // Convert all values into Product object and add it in array
        Product *product = [[Product alloc] init];
        product.name = name;
        product.category = category;
        product.subCategory = subCategory;
        product.price = price;
        
        [cartProducts addObject: product];
        
    }
    
    return cartProducts;
}

@end
