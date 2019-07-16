//
//  ReminderCell.h
//  Choreganizer
//
//  Created by Ethan Hess on 7/15/19.
//  Copyright © 2019 Ethan Hess. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReminderCell : UITableViewCell

@property (nonatomic, strong) UIImageView *reminderClockIV;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic) CGFloat heightToAdd; 

- (void)viewSetup; 

@end

NS_ASSUME_NONNULL_END
