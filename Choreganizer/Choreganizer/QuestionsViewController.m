//
//  QuestionsViewController.m
//  Choreganizer
//
//  Created by Ethan Hess on 7/6/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "QuestionsViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "ScheduledNotificationsListViewController.h"

@import UserNotifications;
@import UserNotificationsUI;

@interface QuestionsViewController ()

@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *segLabel;

//@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UISegmentedControl *segController;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *seeButton;


@end

@implementation QuestionsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *schemeString = [[NSUserDefaults standardUserDefaults]objectForKey:schemeKey];
    if (schemeString) {
        if ([schemeString isEqualToString:@"Space"]) {
            [self backgroundImage:@"ChoreganizerInstructions"];
        } else if ([schemeString isEqualToString:@"Color"]) {
            [self backgroundImage:@"InstructionsColor"];
        }
    }
    else {
        [self backgroundImage:@"ChoreganizerInstructions"];
    }
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setUpViewsWrapper {
    [self setUpScrollView];
    [self setUpLabel];
    [self setUpSegControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewsWrapper];
}

- (void)setUpScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 250);
    [self.view sendSubviewToBack:self.scrollView];
    [self.view addSubview:self.scrollView];
}

- (void)backgroundImage:(NSString *)imageString {
    CGRect frame;
    if ([self isIphoneX] == YES) {
        CGFloat yCoord = 44;
        frame = CGRectMake(0, yCoord, self.view.frame.size.width, self.view.frame.size.height - yCoord);
    } else {
        frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageString];
    [self.view insertSubview:imageView atIndex:0];
}

- (void)setUpLabel {
    
    self.questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 150, self.view.frame.size.width - 60, 300)];
    self.questionLabel.layer.cornerRadius = 10;
    self.questionLabel.layer.masksToBounds = YES;
    self.questionLabel.numberOfLines = 0;
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    self.questionLabel.textColor = [UIColor whiteColor];
    self.questionLabel.font = [UIFont fontWithName:arialHebrew size:14];
    self.questionLabel.backgroundColor = [UIColor blackColor];
    self.questionLabel.text = @"Welcome to Choreganizer! Start by clicking the '+' button beside any day of the week to add a chore. If you happen to be forgetful and wish to have a notification sent to your phone, no problem. Just select the chore and send yourself as many notifications as you like! When you've finished just swipe to delete.";
    [self.scrollView addSubview:self.questionLabel];
    
    //and buttons to cancel / see notifications
    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 580, self.view.frame.size.width - 60, 50)];
    self.cancelButton.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:92.0f/255.0f blue:92.0f/255.0f alpha:1.0]; //TODO add to custom class/extension
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    [self.cancelButton setTitle:@"Cancel Notifications" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelNotifications) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.cancelButton];
    
//    self.seeButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 660, self.view.frame.size.width - 60, 50)];
//    self.seeButton.backgroundColor = [UIColor colorWithRed:92.0f/255.0f green:154.0f/255.0f blue:229.0f/255.0f alpha:1.0];
//    self.seeButton.layer.cornerRadius = 5;
//    self.seeButton.layer.borderWidth = 1;
//    self.seeButton.layer.borderColor = [[UIColor whiteColor]CGColor];
//    [self.seeButton setTitle:@"See Notifications" forState:UIControlStateNormal];
//    [self.seeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.seeButton addTarget:self action:@selector(seeNotifications) forControlEvents:UIControlEventTouchUpInside];
//    [self.scrollView addSubview:self.seeButton];
    
    //and seg label (and selected index?)
    self.segLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 450, self.view.frame.size.width - 60, 50)];
    self.segLabel.text = @"Choose scheme";
    self.segLabel.textColor = [UIColor whiteColor];
    self.segLabel.textAlignment = NSTextAlignmentCenter;
    self.segLabel.font = [UIFont fontWithName:arialHebrew size:22];
    self.segLabel.font = [UIFont systemFontOfSize:22];
    self.segLabel.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.segLabel];
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

- (void)addImageToToolbar:(NSString *)imageName andToolbar:(UIToolbar *)toolbar {
    CGRect imageFrame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageFrame];
    imageView.image = [UIImage imageNamed:imageName];
    [toolbar addSubview:imageView];
}


- (void)setUpSegControl {
    CGRect segFrame = CGRectMake(30, 500, self.view.frame.size.width - 60, 50);
    self.segController = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Space Scheme", @"Color Scheme", nil]];
    self.segController.frame = segFrame;
    self.segController.tintColor = [UIColor whiteColor];
    self.segController.backgroundColor = [UIColor colorWithRed:92.0f/255.0f green:154.0f/255.0f blue:229.0f/255.0f alpha:1.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:arialHebrew size:15], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.segController setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.segController addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    [self.scrollView addSubview:self.segController];
}

- (void)valueChanged:(UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0: {
            [[NSUserDefaults standardUserDefaults]setObject:@"Space" forKey:schemeKey];
            [self backgroundImage:@"ChoreganizerInstructions"];
            break; }
        case 1: {
            [[NSUserDefaults standardUserDefaults]setObject:@"Color" forKey:schemeKey];
            [self backgroundImage:@"IstructionsColor"];
            break; }
        default:
            break;
    }
}

- (void)home {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)cancelNotifications {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to cancel all notifications?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication]cancelAllLocalNotifications];
        //TODO update, the above is deprecated
        //[[UNUserNotificationCenter currentNotificationCenter]removeAllPendingNotificationRequests];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:yesAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//- (void)seeNotifications {
//    ScheduledNotificationsListViewController *scheduledList = [ScheduledNotificationsListViewController new];
//    [self.navigationController presentViewController:scheduledList animated:YES completion:nil];
//}


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
