//
//  AssetTypePickerViewController.h
//  Homepwner
//
//  Created by Александр Брин on 27/06/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;

@interface AssetTypePickerViewController : UITableViewController
@property (strong, nonatomic) BNRItem *item;

@end
