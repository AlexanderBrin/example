//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Александр Брин on 20/06/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
@import CoreData;

@implementation BNRItemStore


+ (instancetype)sharedStore {
    static BNRItemStore *sharedStore;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedStore];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSURL *storeURL = [NSURL fileURLWithPath:self.itemArchivePath];
        NSError *error;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason %@", [error localizedDescription]];
        }
        context = [[NSManagedObjectContext alloc] init];
        context.persistentStoreCoordinator = psc;
        [self loadAllItems];
    }
    return self;
}

- (NSArray *)allItems {
    return allItems;
}

- (BNRItem *)createItem {
    double order;
    if (allItems.count == 0) {
        order = 1.;
    } else {
        order = [allItems.lastObject orderingValue].doubleValue + 1.;
    }
    NSLog(@"Adding after %lu items, order = %.2f", (unsigned long)allItems.count, order);
    BNRItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:context];
    item.orderingValue = @(order);
    [allItems addObject:item];
    return item;
}

- (void)removeItem:(BNRItem *)item {
    [[BNRImageStore sharedStore] deleteImageForKey:item.imageKey];
    [context deleteObject:item];
    [allItems removeObjectIdenticalTo:item];
}

- (void)removeItemAtIndex:(NSInteger)index {
    [self removeItem:allItems[index]];
}

- (void)moveItemAtIndex:(NSUInteger)from to:(NSInteger)to {
    if (from == to) {
        return;
    }
    
    BNRItem *item = allItems[(NSUInteger) from];
    [allItems removeObjectAtIndex:from];
    [allItems insertObject:item atIndex:to];
    
    double upperBound = 0.0, lowerBound = 0.0;
    
    if (to > 0) {
        lowerBound = [allItems[to - 1] orderingValue].floatValue;
    } else {
        lowerBound = [allItems[1] orderingValue].floatValue - 2.;
    }
    
    if (to < allItems.count - 1) {
        upperBound = [allItems[to + 1] orderingValue].floatValue;
    } else {
        upperBound = [allItems[to - 1] orderingValue].floatValue + 2.;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.;
    
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = [NSNumber numberWithDouble:newOrderValue];
}

- (NSString *)itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirectories[0];
    if ([docDir hasSuffix:@"/"]) {
        return [docDir stringByAppendingString:@"store.data"];
    } else {
        return [docDir stringByAppendingString:@"/store.data"];
    }
}

- (BOOL)saveChanges {
    NSError *error;
    BOOL successful = [context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)loadAllItems {
    if (!allItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [model entitiesByName][@"BNRItem"];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", error.localizedDescription];
        }
        
        allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSArray *)allAssetTypes {
    if (!allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [model entitiesByName][@"BNRAssetType"];
        request.entity = e;
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason %@", error.localizedDescription];
        }
        allAssetTypes = result.mutableCopy;
    }
    
    if (allAssetTypes.count == 0) {
        NSManagedObject *type;
        type = [self insetNewAssetType];
        [type setValue:@"Furniture" forKey:@"label"];
        [allAssetTypes addObject:type];
        type = [self insetNewAssetType];
        [type setValue:@"Jewerly" forKey:@"label"];
        [allAssetTypes addObject:type];
        type = [self insetNewAssetType];
        [type setValue:@"Electronics" forKey:@"label"];
        [allAssetTypes addObject:type];
    }
    return allAssetTypes;
}

- (NSManagedObject *)insetNewAssetType {
    return [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:context];
}


@end
