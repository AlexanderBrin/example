//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Александр Брин on 20/06/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;
@class NSManagedObjectContext;
@class NSManagedObjectModel;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
    NSMutableArray * allAssetTypes;
    NSManagedObjectModel *model;
    NSManagedObjectContext *context;
}

+ (instancetype)sharedStore;

- (NSArray *)allItems;
- (NSArray *)allAssetTypes;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)item;
- (void)removeItemAtIndex:(NSInteger)index;
- (void)moveItemAtIndex:(NSUInteger)from to:(NSInteger)to;
- (NSString *)itemArchivePath;
- (BOOL)saveChanges;
- (void)loadAllItems;


@end
