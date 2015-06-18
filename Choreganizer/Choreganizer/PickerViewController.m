//
//  PickerViewController.m
//  Choreganizer
//
//  Created by Ethan Hess on 6/18/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()

@property (nonatomic, strong) Chore *chore;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *dismissButton;

@end

@implementation PickerViewController

- (void)updateWithChore:(Chore *)chore {
    
    self.chore = chore;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 150)];
    [self.view addSubview:self.datePicker];
    
    self.sendButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 300, 100, 100)];
    self.sendButton.backgroundColor = [UIColor greenColor];
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    self.sendButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.sendButton.layer.borderWidth = 3.0;
    self.sendButton.layer.cornerRadius = 50;
    [self.sendButton addTarget:self action:@selector(sendNotification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendButton];
    
    self.dismissButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, 300, 100, 100)];
    self.dismissButton.backgroundColor = [UIColor redColor];
    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    self.dismissButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.dismissButton.layer.borderWidth = 3.0;
    self.dismissButton.layer.cornerRadius = 50;
    [self.dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
}





- (void)sendNotification {
    
    NSString *choreTitle = [NSString stringWithFormat:@"%@", self.chore.title];
    NSString *choreDetail = [NSString stringWithFormat:@"%@", self.chore.detail];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    if (localNotification) {
        localNotification.fireDate = self.datePicker.date;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.repeatInterval = 0;
        localNotification.soundName = @"bell_tree.mp3";
        localNotification.alertBody = [NSString stringWithFormat: @"A friendly reminder, %@, %@", choreTitle, choreDetail];
        localNotification.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)dismiss {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
