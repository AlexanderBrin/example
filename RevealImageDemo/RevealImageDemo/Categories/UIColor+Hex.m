//
//  AppDelegate.swift
//  RevealImageDemo
//
//  Created by Alexander on 07/06/16.
//  Copyright © 2016 Alexander Brin. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(NSString *)hex {
    unsigned int result;
    [[NSScanner scannerWithString:hex] scanHexInt:&result];

    float a = ((hex.length == 8) ? ((result >> 24) & 0xFF) / 255.0f : 1.0f);
    float r = ((result >> 16) & 0xFF) / 255.0f;
    float g = ((result >> 8) & 0xFF) / 255.0f;
    float b = ((result >> 0) & 0xFF) / 255.0f;
    
    return [UIColor colorWithRed:r
                           green:g
                            blue:b
                           alpha:a];
}

@end
