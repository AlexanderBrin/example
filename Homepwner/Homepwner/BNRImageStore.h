//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Александр Брин on 21/06/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface BNRImageStore : NSObject

@property (nonatomic, strong) NSMutableDictionary*dictionary;

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;
- (NSString *)imagePathForKey:(NSString *)key;

@end
