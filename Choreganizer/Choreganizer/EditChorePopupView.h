//
//  EditChorePopupView.h
//  Choreganizer
//
//  Created by Ethan Hess on 6/28/19.
//  Copyright © 2019 Ethan Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chore.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditChoreDelegate <NSObject>

@required
- (void)choreEditedWithChore:(Chore *)chore andNewText:(NSString *)newText andNewTitle:(NSString *)newTitle;
@end

@interface EditChorePopupView : UIView

@property (nonatomic, weak) id <EditChoreDelegate> delegate;
@property (nonatomic, strong) Chore *chore;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *saveButton;

- (void)updateChore:(Chore *)chore;

@end

NS_ASSUME_NONNULL_END

