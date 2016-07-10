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
@property (nonatomic, strong) UISegmentedControl *segController;

@end

@implementation QuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    
    imageView.image = [UIImage imageNamed:@"ChoreganizerInstructions"];
    [self.view addSubview:imageView];
    
    [self setUpLabel];
    
    [self setUpToolbar];
    
    [self setUpSegControl];
    
}

- (void)setUpLabel {
    
    self.questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 150, self.view.frame.size.width - 60, 300)];
    self.questionLabel.layer.cornerRadius = 10;
//    self.questionLabel.layer.borderColor = [[UIColor whiteColor]CGColor];
//    self.questionLabel.layer.borderWidth = 1.0;
    self.questionLabel.layer.masksToBounds = YES;
    self.questionLabel.numberOfLines = 0;
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    self.questionLabel.textColor = [UIColor whiteColor];
    self.questionLabel.font = [UIFont fontWithName:@"Chalkduster" size:14];
    self.questionLabel.backgroundColor = [UIColor blackColor];
    self.questionLabel.text = @"Welcome to Choreganizer! Start by clicking the '+' button beside any day of the week to add a chore. If you happen to be forgetful and wish to have a notification sent to your phone, no problem. Just select the chore and send yourself as many notifications as you like! When you've finished just swipe to delete.";
    [self.view addSubview:self.questionLabel];
    
}

- (void)setUpToolbar {
    
    self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"toolbarBackground"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
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

- (void)setUpSegControl {
    
    CGRect segFrame = CGRectMake(30, 480, self.view.frame.size.width - 60, 50);
    
    self.segController = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Space Scheme", @"Color Scheme", nil]];
    
    self.segController.frame = segFrame;
    self.segController.tintColor = [UIColor whiteColor];
    self.segController.backgroundColor = [UIColor clearColor];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Chalkduster" size:15], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.segController setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    [self.segController addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:self.segController];
}

- (void)valueChanged:(UISegmentedControl *)segment {
    
    switch (segment.selectedSegmentIndex) {
            
        case 0: {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"Space" forKey:schemeKey];
            
            break; }
        case 1: {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"Color" forKey:schemeKey];
            
            break; }
            
        default:
            break;
    }
}

- (void)home {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    ViewController *viewController = [ViewController new];
    
//    [self.navigationController pushViewController:viewController animated:YES];

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
