//
//  BNRItem.m
//  hello mac
//
//  Created by Александр Брин on 22/05/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

+ (instancetype) randomItem {
    NSString *name = [self generateRandomName];
    int valueInDollars = [self generateValueInDollars];
    NSString *serialNumber = [self generateSerialNumber];
    
    BNRItem *item = [[self alloc] initWithItemName:name
                                      serialNumber:serialNumber
                                    valueInDollars:valueInDollars];
    return item;
}

+ (NSString *) generateRandomName {
    NSArray *randomAdjectiveList = @[@"Floffy", @"Rusty", @"Shiny"];
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    return randomName;
}

+ (NSString *) generateSerialNumber {
    return [NSString stringWithFormat:@"%c%c%c%c%c",
            '0' + rand() % 10,
            'A' + rand() % 26,
            '0' + rand() % 10,
            'A' + rand() % 26,
            '0' + rand() % 10];
}

+ (int) generateValueInDollars {
    return rand() % 100;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.itemName = @"Item";
        _dateCreated = [[NSDate alloc] init];
    }
    return self;
}

- (instancetype)initWithItemName: (NSString *) name
                     serialNumber: (NSString *) serial
                   valueInDollars: (int) bablo {
    self = [self init];
    if (self) {
        [self setItemName:name];
        [self setSerialNumber:serial];
        [self setValueInDollars:bablo];
    }
    return self;
}

- (instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)serial {
    return [self initWithItemName:name
                     serialNumber:serial
                   valueInDollars:0];
}

- (instancetype)initWithItemName: (NSString *) name {
    return [self initWithItemName:name
                     serialNumber:@""
                   valueInDollars:0];
}

- (NSString *) description {
    return [[NSString alloc] initWithFormat:@"%@ (%@) Worth $%d, recorded on %@",
            self.itemName,
            self.serialNumber,
            self.valueInDollars,
            self.dateCreated];
}

- (void) dealloc {
    NSLog(@"Destroing item with name: %@", self.itemName);
}

- (void) setContainedItem:(BNRItem *)containedItem {
    _containedItem = containedItem;
    [containedItem setContainer:self];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.imageKey forKey:@"imageKey"];
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:self.thumbnailData forKey:@"thumbnailData"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.itemName = [aDecoder decodeObjectForKey:@"itemName"];
        self.serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        self.imageKey = [aDecoder decodeObjectForKey:@"imageKey"];
        self->_dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        self.valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
        self.valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
        self.thumbnailData = [aDecoder decodeObjectForKey:@"thumbnailData"];
    }
    return self;
}

-(UIImage *)thumbnail {
    if (!self->_thumbnailData) {
        return nil;
    }
    
    if (!self->_thumbnail) {
        _thumbnail = [UIImage imageWithData:self.thumbnailData];
    }
    
    return _thumbnail;
}

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
@end
