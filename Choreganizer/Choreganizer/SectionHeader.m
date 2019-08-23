//
//  SectionHeader.m
//  Choreganizer
//
//  Created by Ethan Hess on 6/5/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "SectionHeader.h"
#import "ChoreController.h"
#import "AppDelegate.h"

@implementation SectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
    
        self.titleLabel = [UILabel new];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:arialHebrew size:36];
        self.titleLabel.font = [UIFont systemFontOfSize:24];
        [self addSubview:self.titleLabel];
        
        self.addButton = [UIButton new];
        self.addButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.addButton setTitle:@"+" forState:UIControlStateNormal];
        [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addChore) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addButton];
        
        [self setUpConstraints];
    }
    
    return self;
}

- (void)setUpConstraints {
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_titleLabel, _addButton);
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_titleLabel(==50)]" options:0 metrics:nil views:viewsDictionary];
    
    CGFloat bufferBetween = self.frame.size.width - (165 + 65);
    NSString *constraintStr = [NSString stringWithFormat:@"H:|-15-[_titleLabel(==150)]-%f-[_addButton(==50)]", bufferBetween];
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintStr options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary];
    
    NSLayoutConstraint *equalConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.addButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0.0];
    
    self.addButton.layer.cornerRadius = 25;
    self.addButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.addButton.layer.borderWidth = 1.0;
    
    [self addConstraints:verticalConstraints];
    [self addConstraints:horizontalConstraints];
    [self addConstraint:equalConstraint];
}

+ (CGFloat)headerHeight {
    return 80;
}

- (void)updateWithBackgroundImage:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed:imageName];
    [self insertSubview:imageView atIndex:0];
}

- (void)updateWithDay:(Day *)day {
    self.day = day;
}

- (void)updateWithTitle:(NSInteger)index {
    Day *day = [ChoreController sharedInstance].days[index];
    self.titleLabel.text = day.name;
}

- (void)addChore {
    [self.delegate popAddChoreView:self.day];
}



@end
