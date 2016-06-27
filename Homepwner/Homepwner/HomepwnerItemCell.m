//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Alexander on 23/06/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell

- (IBAction)showImage:(id)sender {
    if (!self.controller) return;
    NSString *selector = NSStringFromSelector(_cmd);
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    SEL newSelector = NSSelectorFromString(selector);
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];

    if (indexPath) {
        if ([self.controller respondsToSelector:newSelector]) {
            [self.controller performSelector:newSelector
                                  withObject:sender
                                  withObject:indexPath];
            
        }
    }
}
@end
