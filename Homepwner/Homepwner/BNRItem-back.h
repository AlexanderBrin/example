//
//  BNRItem.h
//  hello mac
//
//  Created by Александр Брин on 22/05/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface BNRItem : NSObject <NSCoding>

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic) BNRItem *containedItem;
@property (weak, nonatomic) BNRItem *container;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSData *thumbnailData;

+ (instancetype)randomItem;

- (instancetype)initWithItemName: (NSString *)name
                    serialNumber: (NSString *)serial
                  valueInDollars: (int)bablo;

- (instancetype)initWithItemName: (NSString *)name;

- (instancetype)initWithItemName: (NSString *)name
                    serialNumber:(NSString *)serial;

- (NSDate *)dateCreated;

- (void)setThumbnailDataFromImage:(UIImage *)image;

@end
