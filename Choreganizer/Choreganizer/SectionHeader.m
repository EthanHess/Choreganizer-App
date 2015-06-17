//
//  SectionHeader.m
//  Choreganizer
//
//  Created by Ethan Hess on 6/5/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "SectionHeader.h"
#import "ChoreController.h"

@implementation SectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkParchment"]];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:@"Chalkduster" size:20];
        [self addSubview:self.titleLabel];
        
        self.addButton = [UIButton new];
        self.addButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.addButton setTitle:@"+" forState:UIControlStateNormal];
        [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.addButton.backgroundColor = [UIColor blueColor];
        [self.addButton addTarget:self action:@selector(addChore) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addButton];
        
        [self setUpConstraints];
    }
    
    return self;
    
    
    
}

- (void)setUpConstraints {
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_titleLabel, _addButton);
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_titleLabel(==50)]" options:0 metrics:nil views:viewsDictionary];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_titleLabel(==140)]-50-[_addButton(==50)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary];
    
    NSLayoutConstraint *equalConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.addButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0.0];
    
    self.addButton.layer.cornerRadius = 25;
    self.addButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.addButton.layer.borderWidth = 3.0;
    
    
    [self addConstraints:verticalConstraints];
    [self addConstraints:horizontalConstraints];
    [self addConstraint:equalConstraint];
    
    
}

+ (CGFloat)headerHeight {
    
    return 80;
}

- (void)updateWithDay:(Day *)day {
    
    self.day = day;
    
}

- (void)updateWithTitle:(NSInteger)index {
    
    Day *day = [ChoreController sharedInstance].days[index];
    
    self.titleLabel.text = day.name;
    
}

- (void)addChore {
    
    [self.delegate addChore];
}


@end
