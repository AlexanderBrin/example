//
//  DetailViewController.h
//  Homepwner
//
//  Created by Александр Брин on 21/06/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) BNRItem *item;

- (instancetype) initForNewItem:(BOOL)isNew;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end
