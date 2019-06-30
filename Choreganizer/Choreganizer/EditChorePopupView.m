//
//  EditChorePopupView.m
//  Choreganizer
//
//  Created by Ethan Hess on 6/28/19.
//  Copyright © 2019 Ethan Hess. All rights reserved.
//

#import "EditChorePopupView.h"

@implementation EditChorePopupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self subviewConfig];
        [self stylize];
    }
    return self;
}

- (void)stylize {
    
}

- (void)subviewConfig {
    if (self.textField == nil) {
        
    }
    if (self.textView == nil) {
        
    }
    if (self.dismissButton == nil) {
        
    }
    if (self.saveButton == nil) {
        
    }
}

- (void)save {
    [self finished];
}

- (void)dismiss {
    
}

- (void)hideSelf {
    
}

- (BOOL)didntEdit { //Didn't change anything, no need to write
    return [self.textField.text isEqualToString:self.chore.title] && [self.textView.text isEqualToString:self.chore.detail];
}

- (void)finished {
    if ([self didntEdit] == YES) {
        return;
    }
    [self.delegate choreEditedWithChore:self.chore andNewText:self.textField.text != nil ? self.textField.text : @"" andNewTitle:self.textView.text != nil ? self.textView.text : @""];
    [self hideSelf];
}

@end
