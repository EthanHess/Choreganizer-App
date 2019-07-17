//
//  ChoreTodoCell.h
//  Choreganizer
//
//  Created by Ethan Hess on 7/15/19.
//  Copyright © 2019 Ethan Hess. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChoreTodoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIImageView *editImageView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic) CGFloat heightToAdd;

- (void)cellSetup;

@end

NS_ASSUME_NONNULL_END
