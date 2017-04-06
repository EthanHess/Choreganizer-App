//
//  NotificationController.m
//  Choreganizer
//
//  Created by Ethan Hess on 4/6/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

#import "NotificationController.h"

@implementation NotificationController

+ (NotificationController *)sharedInstance {
    static NotificationController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NotificationController new];
    });
    
    return sharedInstance;
    
}

- (void)saveReferenceToNotification:(UILocalNotification *)localNotification {
    
    
}

@end
