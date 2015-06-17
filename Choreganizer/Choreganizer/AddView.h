//
//  AddView.h
//  Choreganizer
//
//  Created by Ethan Hess on 6/14/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@protocol DismissDelegate <NSObject>

@required

- (void)dismissView;
- (void)saveChoreToDay:(Day *)day;

@end

@interface AddView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) id<DismissDelegate> delegate;
@property (nonatomic, strong) Day *day;

- (void)updateWithDay:(Day *)day;

@end
