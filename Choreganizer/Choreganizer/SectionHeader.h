//
//  SectionHeader.h
//  Choreganizer
//
//  Created by Ethan Hess on 6/5/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@protocol AddDelegate <NSObject>

@required

- (void)popAddChoreView:(Day *)day;

@end

@interface SectionHeader : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) id <AddDelegate> delegate;
@property (nonatomic, strong) Day *day; 

+ (CGFloat)headerHeight;
- (void)updateWithDay:(Day *)day;
- (void)updateWithTitle:(NSInteger)index;

@end
