//
//  ImageViewController.h
//  Homepwner
//
//  Created by Alexander on 24/06/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIImage *image;

@end
