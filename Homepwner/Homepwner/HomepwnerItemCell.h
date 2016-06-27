//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Alexander on 23/06/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface HomepwnerItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *serial;
@property (weak, nonatomic) IBOutlet UILabel *value;

@property (weak, nonatomic) id controller;
@property (weak, nonatomic) UITableView *tableView;

- (IBAction)showImage:(id)sender;

@end
