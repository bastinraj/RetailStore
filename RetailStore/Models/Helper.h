//
//  Helper.h
//  RetailStore
//
//  Created by Bastin Raj on 7/28/14.
//  Copyright (c) 2014 Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject
{
    NSManagedObjectContext *managedObjectContext;
}


-(NSMutableArray *) retrieveAllCartProducts;

@end
