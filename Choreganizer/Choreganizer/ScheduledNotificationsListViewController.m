//
//  ScheduledNotificationsListViewController.m
//  Choreganizer
//
//  Created by Ethan Hess on 4/6/17.
//  Copyright © 2017 Ethan Hess. All rights reserved.
//

#import "ScheduledNotificationsListViewController.h"

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
    
    [self setUpTableView];
    [self setUpDismissButton]; 
}

- (NSArray *)notificationArray {
    
    return [[UIApplication sharedApplication]scheduledLocalNotifications];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpDismissButton {
    
    CGRect buttonFrame = CGRectMake(0, 0, self.view.frame.size.width, 75);
    
    self.dismissButton = [[UIButton alloc]initWithFrame:buttonFrame];
    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.dismissButton setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.dismissButton];
}

- (void)setUpTableView {
    
    CGRect tableFrame = CGRectMake(0, 75, self.view.frame.size.width, self.view.frame.size.height - 75);
    
    self.tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self registerTableView:self.tableView];
    [self.view addSubview:self.tableView];
}

- (void)registerTableView:(UITableView *)tableView {
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

//Table View Delegate + Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [self notificationArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"]; 

    UILocalNotification *notif = [self notificationArray][indexPath.row];
    
    cell.textLabel.text = [self cutString:notif.alertBody];
    cell.detailTextLabel.text = [self stringFromDate:notif.fireDate];
    
    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILocalNotification *theNotif = [self notificationArray][indexPath.row];
    
    [self popOptionsAlertWithNotification:theNotif];
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
    
    formatter.dateFormat = @"YYYY-MM-DD";
    
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
