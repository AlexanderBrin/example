//
//  BNRItem.m
//  Homepwner
//
//  Created by Alexander on 26/06/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic imageKey;
@dynamic thumbnailData;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;

-(void)setThumbnailDataFromImage:(UIImage *)image {
    CGSize originalSize = image.size;
    CGRect newRect = CGRectMake(0, 0, 100, 100);
    float ratio = MAX(newRect.size.width / originalSize.width, newRect.size.height / originalSize.height);
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, .0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.];
    [path addClip];
    CGRect projectRect;
    projectRect.size.width = ratio * originalSize.width;
    projectRect.size.height = ratio * originalSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    [image drawInRect:projectRect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    self.thumbnailData = UIImagePNGRepresentation(smallImage);
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
    [self setPrimitiveValue:[UIImage imageWithData:self.thumbnailData] forKey:@"thumbnail"];
}

- (void)awakeFromInsert {
    self.dateCreated = [[NSDate alloc] init];
}

@end
