//
//  ReminderCell.m
//  Choreganizer
//
//  Created by Ethan Hess on 7/15/19.
//  Copyright © 2019 Ethan Hess. All rights reserved.
//

#import "ReminderCell.h"

@implementation ReminderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)viewSetup {
    //For main labels
    CGFloat theHeight = self.heightToAdd / 2;
    //will be same size in top left corner
    if (self.reminderClockIV == nil) {
        self.reminderClockIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.reminderClockIV.image = [UIImage imageNamed:@"clockIcon"];
        //config with shadow and radius?
        [self.contentView addSubview:self.reminderClockIV];
    }
    //TODO stylize
    if (self.topLabel == nil) {
        self.topLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, self.contentView.frame.size.width - 80, theHeight - 20)];
        self.topLabel.numberOfLines = 0;
        self.topLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.topLabel];
    }
    if (self.bottomLabel == nil) {
        self.bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, theHeight + 10, self.contentView.frame.size.width - 80, theHeight - 20)];
        self.bottomLabel.numberOfLines = 0;
        self.bottomLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bottomLabel];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.contentView.layer.borderWidth = 1;
    self.backgroundColor = [UIColor clearColor];
    
    self.contentView.frame = UIEdgeInsetsInsetRect(self.contentView.frame, UIEdgeInsetsMake(5, 7.5, 5, 7.5));
    self.contentView.layer.masksToBounds = YES;
}

@end
