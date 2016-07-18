//
//  Application.h
//  iPenYou
//
//  Created by trgoofi on 14-5-30.
//  Copyright (c) 2014年 vbuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBApplication : NSObject

+ (NSString *)shortVersion;

+ (NSString *)bundleVersion;

+ (NSString *)deviceId;

+ (NSString *)resolution;

+ (BOOL)isPlus;

+ (NSURL *)directoryOfDocument;

+ (NSManagedObjectContext *)sharedManagedObjectContext;

+ (void)saveSharedManagedObjectContext;

+ (void)deleteShareManagedObjectContext:(NSManagedObject *)object;

@end
