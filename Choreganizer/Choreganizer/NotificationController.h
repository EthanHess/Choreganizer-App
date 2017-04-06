//
//  NotificationController.h
//  Choreganizer
//
//  Created by Ethan Hess on 4/6/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface NotificationController : NSObject

@property (nonatomic, strong, readonly) NSArray <UILocalNotification *> *notifications;

+ (NotificationController *)sharedInstance;

- (void)saveReferenceToNotification:(UILocalNotification *)localNotification;


@end
