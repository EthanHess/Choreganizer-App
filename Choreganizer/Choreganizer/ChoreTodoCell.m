//
//  ChoreTodoCell.m
//  Choreganizer
//
//  Created by Ethan Hess on 7/15/19.
//  Copyright © 2019 Ethan Hess. All rights reserved.
//

#import "ChoreTodoCell.h"

@implementation ChoreTodoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellSetup {
    
    CGFloat theHeight = self.heightToAdd / 2;
    
    if (self.mainImageView == nil) {
        self.mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
        [self.contentView addSubview:self.mainImageView];
    }
    if (self.editImageView == nil) {
        self.editImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 70, 10, 50, 50)];
        [self.contentView addSubview:self.editImageView];
    }
    if (self.headerLabel == nil) {
        self.headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, self.contentView.frame.size.width - 160, theHeight - 20)];
        self.headerLabel.textColor = [UIColor whiteColor];
        self.headerLabel.textAlignment = NSTextAlignmentCenter;
        self.headerLabel.numberOfLines = 0;
        [self.contentView addSubview:self.headerLabel];
    }
    if (self.bodyLabel == nil) {
        self.bodyLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, theHeight + 10, self.contentView.frame.size.width - 160, theHeight - 20)];
        self.bodyLabel.textColor = [UIColor whiteColor];
        self.bodyLabel.textAlignment = NSTextAlignmentCenter;
        self.bodyLabel.numberOfLines = 0;
        [self.contentView addSubview:self.bodyLabel];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = UIEdgeInsetsInsetRect(self.contentView.frame, UIEdgeInsetsMake(5, 7.5, 5, 7.5));
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.contentView.layer.borderWidth = 1;
    self.contentView.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
}

@end
