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
    self.backgroundColor = [UIColor blackColor]; //TODO update for schemes
    self.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    //shadow?
}

- (CGRect)tfFrame {
    return CGRectMake(10, 10, self.frame.size.width - 20, 40);
}

- (CGRect)tvFrame {
    return CGRectMake(10, 60, self.frame.size.width - 20, self.frame.size.height - 130);
}

- (CGRect)dbFrame {
    return CGRectMake(10, self.frame.size.height - 60, (self.frame.size.width / 2) - 20, 40);
}

- (CGRect)sbFrame {
    return CGRectMake((self.frame.size.width / 2) + 10, self.frame.size.height - 60, (self.frame.size.width / 2) - 20, 40);
}

- (void)updateChore:(Chore *)chore {
    self.chore = chore;
    //Set TF and TV here
    if (self.textField != nil) {
        self.textField.text = chore.title;
    }
    if (self.textView != nil) {
        self.textView.text = chore.detail;
    }
}

- (NSArray *)uiColors {
    UIColor *tfColor = [UIColor colorWithRed:204.0f/255.0f green:207.0f/255.0f blue:238.0f/255.0f alpha:1.0];
    UIColor *tvColor = [UIColor colorWithRed:198.0f/255.0f green:238.0f/255.0f blue:245.0f/255.0f alpha:1.0];
    UIColor *dmColor = [UIColor colorWithRed:12.0f/255.0f green:145.0f/255.0f blue:168.0f/255.0f alpha:1.0];
    UIColor *svColor = [UIColor colorWithRed:17.0f/255.0f green:114.0f/255.0f blue:231.0f/255.0f alpha:1.0];
    return @[tfColor, tvColor, dmColor, svColor];
}

- (void)subviewConfig {
    NSString *choreTitle = self.chore != nil ? self.chore.title : @""; //can remove?
    NSString *choreBody = self.chore != nil ? self.chore.detail : @"";
    if (self.textField == nil) {
        self.textField = [[UITextField alloc]initWithFrame:[self tfFrame]];
        self.textField.text = choreTitle;
        self.textField.textColor = [UIColor blueColor];
        self.textField.backgroundColor = [self uiColors][0];
        [self stylizeSubview:self.textField];
        [self addSubview:self.textField];
    }
    if (self.textView == nil) {
        self.textView = [[UITextView alloc]initWithFrame:[self tvFrame]];
        self.textView.text = choreBody;
        self.textView.textColor = [UIColor blueColor];
        self.textView.backgroundColor = [self uiColors][1];
        [self stylizeSubview:self.textView];
        [self addSubview:self.textView];
    }
    if (self.dismissButton == nil) {
        self.dismissButton = [[UIButton alloc]initWithFrame:[self dbFrame]];
        [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
        [self.dismissButton addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
        self.dismissButton.backgroundColor = [self uiColors][2];
        [self stylizeSubview:self.dismissButton];
        [self addSubview:self.dismissButton];
    }
    if (self.saveButton == nil) {
        self.saveButton = [[UIButton alloc]initWithFrame:[self sbFrame]];
        [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [self.saveButton addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchUpInside];
        self.saveButton.backgroundColor = [self uiColors][3];
        [self stylizeSubview:self.saveButton];
        [self addSubview:self.saveButton];
    }
}

- (void)stylizeSubview:(UIView *)theView {
    //theView.backgroundColor = [UIColor blueColor]; //TODO update for schemes
    theView.layer.borderColor = [[UIColor whiteColor]CGColor];
    theView.layer.borderWidth = 1;
    theView.layer.cornerRadius = 5;
}

- (void)save {
    [self finished];
}

- (void)dismiss {
    
}

- (void)hideSelf {
    self.hidden = YES;
}

- (BOOL)didntEdit { //Didn't change anything, no need to write
    return [self.textField.text isEqualToString:self.chore.title] && [self.textView.text isEqualToString:self.chore.detail];
}

- (void)finished {
    if ([self didntEdit] == YES) {
        [self hideSelf];
        return;
    }
    [self.delegate choreEditedWithChore:self.chore andNewText:self.textField.text != nil ? self.textField.text : @"" andNewTitle:self.textView.text != nil ? self.textView.text : @""];
    [self hideSelf];
}

@end
