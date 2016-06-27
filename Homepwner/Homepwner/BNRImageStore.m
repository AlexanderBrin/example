//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Александр Брин on 21/06/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

+ (instancetype)sharedStore {
    static BNRImageStore *sharedStore;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedStore];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dictionary = [[NSMutableDictionary alloc] init];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [self.dictionary setObject:image forKey:key];
    
    NSString *path = [self imagePathForKey:key];
    NSData *d = UIImageJPEGRepresentation(image, 1);
    [d writeToFile:path atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key {
    UIImage * image = [self.dictionary objectForKey:key];;
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[self imagePathForKey:key]];
        if (image) {
            [self.dictionary setObject:image forKey:key];
        }
    }
    return image;
}

- (void)deleteImageForKey:(NSString *)key {
    if (key) {
        [self.dictionary removeObjectForKey:key];
        NSString *path = [self imagePathForKey:key];[[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
}

- (NSString *)imagePathForKey:(NSString *)key {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [documentDirectories objectAtIndex:0];
    NSMutableString * path = [[NSMutableString alloc] initWithString:docDir];

    if (![docDir hasSuffix:@"/"]) {
        [path appendString:@"/"];
    }
    [path appendString:key];
    return path;
}

- (void)clearCache:(NSNotification *)notification {
    [self.dictionary removeAllObjects];
}

@end
