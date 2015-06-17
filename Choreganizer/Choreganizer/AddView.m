//
//  AddView.m
//  Choreganizer
//
//  Created by Ethan Hess on 6/14/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "AddView.h"

@implementation AddView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        self.backgroundColor = [UIColor colorWithRed:255/255.0f green:232/255.0f blue:248/255.0f alpha:1.0f];
        
        self.textField = [UITextField new];
        self.textField.translatesAutoresizingMaskIntoConstraints = NO;
        self.textField.placeholder = @"Add Chore Title";
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.textField];
        
        self.textView = [UITextView new];
        self.textView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.textView];
        
        self.saveButton = [UIButton new];
        self.saveButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.saveButton.backgroundColor = [UIColor redColor];
        [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [self.saveButton addTarget:self action:@selector(saveChoreToDay:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.saveButton];
        
        self.dismissButton = [UIButton new];
        self.dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.dismissButton.backgroundColor = [UIColor blueColor];
        [self.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
        [self.dismissButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.dismissButton];
        
        self.clearButton = [UIButton new];
        self.clearButton.translatesAutoresizingMaskIntoConstraints = NO; 
        self.clearButton.backgroundColor = [UIColor blueColor];
        [self.clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.clearButton setTitle:@"Clear" forState:UIControlStateNormal];
        [self.clearButton addTarget:self action:@selector(clearFields) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.clearButton];
        
        
        [self setUpConstraints];
    }
    
    return self;
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
    
    [self addConstraints:verticalConstraints];
    [self addConstraints:horizontalConstraintI];
    [self addConstraints:horizontalConstraintII];
    [self addConstraints:horizontalConstraints];
    [self addConstraint:equalConstraint];
    [self addConstraint:equalConstraintII];
    
}

- (void)updateWithDay:(Day *)day {
    
    self.day = day;
    
}

- (void)saveChoreToDay:(Day *)day {
    
    [self.delegate saveChoreToDay:self.day];
    
}

- (void)dismissSelf {
    
    [self.delegate dismissView];
    
}

- (void)clearFields {
    
    self.textField.text = @"";
    self.textView.text = @"";
}

@end
