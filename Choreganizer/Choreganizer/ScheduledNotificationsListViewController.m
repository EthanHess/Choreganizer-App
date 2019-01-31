//
//  ScheduledNotificationsListViewController.m
//  Choreganizer
//
//  Created by Ethan Hess on 4/6/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

#import "ScheduledNotificationsListViewController.h"
#import "GlobalFunctions.h"

@import UserNotificationsUI; //For iOS 10 (TODO: Update)
@import UserNotifications;

@interface ScheduledNotificationsListViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ScheduledNotificationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![self notificationArray]) {
        NSLog(@"No notifications"); //alert
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setUpTableView];
    [self setUpDismissButton];
}

- (NSArray *)notificationArray {
    return [[UIApplication sharedApplication]scheduledLocalNotifications];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Not really any need for this anymore? Now that it's a tab bar
- (void)setUpDismissButton {
    if (self.dismissButton != nil) {
        NSLog(@"Button already exists"); //to prevent doubling up
        return;
    }
    self.dismissButton = [[UIButton alloc]initWithFrame:[self toolbarFrame]];
    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.dismissButton setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.dismissButton];
    
    CGRect frame;
    if ([self isIphoneX] == YES) {
        CGFloat yCoord = self.dismissButton.frame.size.height + 44;
        frame = CGRectMake(0, yCoord, self.view.frame.size.width, self.view.frame.size.height - yCoord);
    } else {
        frame = CGRectMake(0, self.dismissButton.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.dismissButton.frame.size.height);
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:@"NotifBG"];
    [self.view insertSubview:imageView atIndex:0];
}

- (CGRect)toolbarFrame {
    CGRect rect;
    if ([self isIphoneX] == YES) {
        rect = CGRectMake(0, 44, self.view.frame.size.width, 80);
    } else {
        rect = CGRectMake(0, 0, self.view.frame.size.width, 80);
    }
    return rect;
}

//Update for XR etc, 896 height I think?
- (BOOL)isIphoneX {
    return self.view.frame.size.height == 812;
}

- (BOOL)newerDevices {
    return self.view.frame.size.height == 896;
}

- (void)setUpTableView {
    
    if (self.tableView != nil) {
        NSLog(@"Already exists"); //to prevent doubling up
        return;
    }
    
    CGRect tableFrame = CGRectMake(0, 75, self.view.frame.size.width, self.view.frame.size.height - 75);
    
    self.tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self registerTableView:self.tableView];
    [self.view addSubview:self.tableView];
}

- (void)registerTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

//Table View Delegate + Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILocalNotification *notif = [self notificationArray][indexPath.row];

    CGFloat heightToAdd = [GlobalFunctions heightFromTextCount:(int)notif.alertBody.length];
    return 80 + heightToAdd;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self notificationArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.textLabel.textColor = [UIColor greenColor];
    cell.detailTextLabel.textColor = [UIColor greenColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.numberOfLines = 0;
    
    cell.imageView.image = [UIImage imageNamed:@"Clock"];
    
    UILocalNotification *notif = [self notificationArray][indexPath.row];
    
    CGFloat heightToAdd = [GlobalFunctions heightFromTextCount:(int)notif.alertBody.length];
    
    CGRect cellFrame = CGRectMake(0, 0, self.tableView.contentSize.width, 80 + heightToAdd);
    
    UIImageView *cellImageView = [[UIImageView alloc]initWithFrame:cellFrame];
    cellImageView.image = [UIImage imageNamed:@"NCBG"];
    [cell.contentView insertSubview:cellImageView atIndex:0];
    
    
    cell.textLabel.text = [self cutString:notif.alertBody];
    cell.detailTextLabel.text = [self stringFromDate:notif.fireDate];
    
    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILocalNotification *theNotif = [self notificationArray][indexPath.row];
    [self popOptionsAlertWithNotification:theNotif];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma helper fuctions

- (void)popOptionsAlertWithNotification:(UILocalNotification *)theNotif {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Remove notification?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication]cancelLocalNotification:theNotif];
        
        [self refresh];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:yesAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)stringFromDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MMM-dd HH:mm:ss";
    
    return [formatter stringFromDate:date];
}

- (NSString *)cutString:(NSString *)stringToCut {
    NSString *newString = [stringToCut stringByReplacingOccurrencesOfString:@"A friendly reminder, " withString:@""];
    
    return newString;
}

- (void)refresh {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
