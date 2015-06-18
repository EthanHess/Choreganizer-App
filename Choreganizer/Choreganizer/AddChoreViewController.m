//
//  AddChoreViewController.m
//  Choreganizer
//
//  Created by Ethan Hess on 6/17/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "AddChoreViewController.h"
#import "ViewController.h"
#import "ChoreController.h"

@interface AddChoreViewController () <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation AddChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:232/255.0f blue:248/255.0f alpha:1.0f];
    
    self.textField = [UITextField new];
    self.textField.delegate = self;
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.placeholder = @"Add Chore Title";
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.textField];
    
    self.textView = [UITextView new];
    self.textView.delegate = self;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.textView];
    
    self.saveButton = [UIButton new];
    self.saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.saveButton.backgroundColor = [UIColor redColor];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveChoreToDay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
    
    self.dismissButton = [UIButton new];
    self.dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.dismissButton.backgroundColor = [UIColor blueColor];
    [self.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
    self.clearButton = [UIButton new];
    self.clearButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.clearButton.backgroundColor = [UIColor blueColor];
    [self.clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearFields) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearButton];
    
    
    [self setUpConstraints];
}

- (void)setUpConstraints {
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_textField, _textView, _saveButton, _dismissButton, _clearButton);
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_textField(==50)]-75-[_textView(==200)]-50-[_dismissButton(==75)]" options:0 metrics:nil views:viewsDictionary];
    
    NSArray *horizontalConstraintI = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_textField(==300)]" options:0 metrics:nil views:viewsDictionary];
    
    NSArray *horizontalConstraintII = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_textView(==300)]" options:0 metrics:nil views:viewsDictionary];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_saveButton(==75)]-25-[_dismissButton(==75)]-25-[_clearButton(==75)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary];
    
    NSLayoutConstraint *equalConstraint = [NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.clearButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0.0];
    
    NSLayoutConstraint *equalConstraintII = [NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.saveButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0.0];
    
    self.saveButton.layer.cornerRadius = 37.5;
    self.saveButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.saveButton.layer.borderWidth = 3.0;
    self.dismissButton.layer.cornerRadius = 37.5;
    self.dismissButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.dismissButton.layer.borderWidth = 3.0;
    self.clearButton.layer.cornerRadius = 37.5;
    self.clearButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.clearButton.layer.borderWidth = 3.0;
    
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalConstraintI];
    [self.view addConstraints:horizontalConstraintII];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraint:equalConstraint];
    [self.view addConstraint:equalConstraintII];
    
}

- (void)updateWithDay:(Day *)day {
    
    self.day = day;
    
}

- (void)dismissSelf {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)saveChoreToDay:(Day *)day {
    
    [[ChoreController sharedInstance]addChoreWithTitle:self.textField.text andDescription:self.textView.text toDay:self.day];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)clearFields {
    
    self.textField.text = @"";
    self.textView.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];
    
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
