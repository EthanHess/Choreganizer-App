//
//  ScheduledNotificationsListViewController.m
//  Choreganizer
//
//  Created by Ethan Hess on 4/6/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

#import "ScheduledNotificationsListViewController.h"
#import "UIColor+CustomColors.h"
#import "GlobalFunctions.h"
#import "ReminderCell.h"

@import UserNotificationsUI; //For iOS 10 (TODO: Update)
@import UserNotifications;

@interface ScheduledNotificationsListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CAGradientLayer *theGradient;
@property (nonatomic, strong) UIView *noNotifsView;

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
    
    //self.view.backgroundColor = [UIColor blackColor];
    
    if (self.theGradient == nil) {
        [self addGradient];
    }
    
    [self setUpTableView];
    //[self setUpDismissButton];
    //[self getPendingNotifications];
}

//For iOS update
- (void)getPendingNotifications {
    [[UNUserNotificationCenter currentNotificationCenter]getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        if (requests.count > 0) {
            
        } else {
            
        }
    }];
}

- (void)addGradient {
    UIColor *blackColor = [UIColor blackColor];
    UIColor *neptuneBlue = [UIColor colorWithRed:15.0f/255.0f green:165.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    self.theGradient = [CAGradientLayer layer];
    self.theGradient.colors = [NSArray arrayWithObjects:(id)blackColor.CGColor, (id)neptuneBlue.CGColor, nil];
    self.theGradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.theGradient atIndex:0];
    
    if ([self notificationArray].count == 0) {
        [self addNoNotifcationsView];
    }
}

//Update frame for devices
//TODO update text
- (void)addNoNotifcationsView { //If they don't have any
    if (self.noNotifsView == nil) {
        CGRect viewFrame = CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.height / 4, self.view.frame.size.width / 2, self.view.frame.size.height / 4);
        self.noNotifsView = [[UIView alloc]initWithFrame:viewFrame];
        self.noNotifsView.layer.cornerRadius = 5;
        self.noNotifsView.layer.borderColor = [[UIColor whiteColor]CGColor];
        self.noNotifsView.layer.borderWidth = 1;
        self.noNotifsView.backgroundColor = [UIColor blackColor];
        [self addShadowToView];
        [self.view addSubview:self.noNotifsView];
    }
}

//Move to utils?
- (void)addShadowToView {
    self.noNotifsView.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.noNotifsView.layer.shadowOffset = CGSizeMake(0, 1);
    self.noNotifsView.layer.shadowOpacity = 1;
    self.noNotifsView.layer.shadowRadius = 5.0;
    self.noNotifsView.clipsToBounds = NO;
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
    
    //TODO replaced with gradient but will keep temp. just in case
    
//    CGRect frame;
//    if ([self isIphoneX] == YES) {
//        CGFloat yCoord = self.dismissButton.frame.size.height + 44;
//        frame = CGRectMake(0, yCoord, self.view.frame.size.width, self.view.frame.size.height - yCoord);
//    } else {
//        frame = CGRectMake(0, self.dismissButton.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.dismissButton.frame.size.height);
//    }
//
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
//    imageView.image = [UIImage imageNamed:@"NotifBG"];
//    [self.view insertSubview:imageView atIndex:0];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerTableView:self.tableView];
    [self.view addSubview:self.tableView];
}

- (void)registerTableView:(UITableView *)tableView {
    [tableView registerClass:[ReminderCell class] forCellReuseIdentifier:@"cell"];
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
    
    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    UILocalNotification *notif = [self notificationArray][indexPath.row];
    CGFloat heightToAdd = [GlobalFunctions heightFromTextCount:(int)notif.alertBody.length];
    
    cell.heightToAdd = heightToAdd + 80;
    
    [cell viewSetup];
    
    [self addTwoColorsToMakeGradient:[UIColor topGradientSpace] colorTwo:[UIColor bottomGradientSpace] andView:cell andHeightToAdd:heightToAdd];
    
    NSString *topText = [self cutString:notif.alertBody];
    NSString *bottomText = [self stringFromDate:notif.fireDate];
    
    cell.topLabel.text = topText;
    cell.bottomLabel.text = bottomText;
    
    [cell layoutIfNeeded]; //calls layout subviews (which shouldn't be called directly)
    
    return cell; 
}

- (void)addTwoColorsToMakeGradient:(UIColor *)colorOne colorTwo:(UIColor *)colorTwo andView:(UIView *)theView andHeightToAdd:(CGFloat)heightToAdd {
    
    CAGradientLayer *theGradient = [CAGradientLayer layer];
    theGradient.colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    
    if ([theView isKindOfClass:[UITableViewCell class]]) {
        CGFloat width = self.view.frame.size.width;
        CGFloat height = 80 + heightToAdd;
        theGradient.frame = CGRectMake(7.5, 5, width - 15, height - 10);
        theGradient.cornerRadius = 5;
        [theView.layer insertSublayer:theGradient atIndex:0];
    } else {
        theGradient.frame = theView.bounds;
        theGradient.cornerRadius = 5; 
        [theView.layer insertSublayer:theGradient atIndex:0];
    }
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
