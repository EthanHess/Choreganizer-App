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
