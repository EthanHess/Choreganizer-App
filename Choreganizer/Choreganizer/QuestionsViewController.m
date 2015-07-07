//
//  QuestionsViewController.m
//  Choreganizer
//
//  Created by Ethan Hess on 7/6/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "QuestionsViewController.h"
#import "ViewController.h"

@interface QuestionsViewController ()

@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation QuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:186/255.0f blue:99/255.0f alpha:1.0f];
    
    [self setUpLabel];
    
    [self setUpToolbar];
    
}

- (void)setUpLabel {
    
    self.questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 150, self.view.frame.size.width - 100, 300)];
    self.questionLabel.layer.cornerRadius = 10;
    self.questionLabel.layer.borderColor = [[UIColor colorWithRed:16/255.0f green:58/255.0f blue:131/255.0f alpha:1.0f]CGColor];
    self.questionLabel.layer.borderWidth = 3.0; 
    self.questionLabel.layer.masksToBounds = YES;
    self.questionLabel.numberOfLines = 0;
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    self.questionLabel.textColor = [UIColor colorWithRed:16/255.0f green:58/255.0f blue:131/255.0f alpha:1.0f];
    self.questionLabel.font = [UIFont fontWithName:@"Chalkduster" size:14];
    self.questionLabel.backgroundColor = [UIColor colorWithRed:147/255.0f green:243/255.0f blue:210/255.0f alpha:1.0f];
    self.questionLabel.text = @"Welcome to Choreganizer! Start by clicking the '+' button beside any day of the week to add a chore. If you happen to be forgetful and wish to have a notification sent to your phone, no problem. Just select the chore and send yourself as many notifications as you like! When you've finished just swipe to delete.";
    [self.view addSubview:self.questionLabel];
    
}

- (void)setUpToolbar {
    
    self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.view addSubview:self.toolbar];
    
    UIImage *arrow = [UIImage imageNamed:@"arrow"];
    
    NSMutableArray *navItems = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem *flexItem0 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [navItems addObject:flexItem0];
    
    UIBarButtonItem *arrowItem = [[UIBarButtonItem alloc]initWithImage:arrow style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    [navItems addObject:arrowItem];
    
    UIBarButtonItem *flexItem1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [navItems addObject:flexItem1];
    
    [self.toolbar setItems:navItems];
    
}

- (void)home {
    
    ViewController *viewController = [ViewController new];
                                      
    [self.navigationController pushViewController:viewController animated:YES];
    
    
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
