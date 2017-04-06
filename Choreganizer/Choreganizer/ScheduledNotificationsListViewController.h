//
//  ScheduledNotificationsListViewController.h
//  Choreganizer
//
//  Created by Ethan Hess on 4/6/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduledNotificationsListViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) NSArray *notificationArray;

@end
