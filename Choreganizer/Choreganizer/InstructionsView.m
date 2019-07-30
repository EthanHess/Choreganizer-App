//
//  InstructionsView.m
//  Choreganizer
//
//  Created by Ethan Hess on 6/6/19.
//  Copyright © 2019 Ethan Hess. All rights reserved.
//

#import "InstructionsView.h"
#import "UIColor+CustomColors.h"

@interface InstructionsView()

@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UILabel *typewriter;

@end

@implementation InstructionsView

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
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)expandedInit {
    [self configureSelf];
    [self addSubviews];
}

- (void)configureSelf {
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5]; //custom?
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    //Shadows?
}

- (void)hideTappedHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.typewriter setText:@""];
        [self.delegate hideTapped];
    });
}

- (void)addSubviews {
    
    //check nil
    self.typewriter = [[UILabel alloc]initWithFrame:[self labelFrame]];
    self.typewriter.layer.cornerRadius = 5;
    self.typewriter.backgroundColor = [UIColor blackColor];
    self.typewriter.layer.borderWidth = 1;
    self.typewriter.layer.borderColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5].CGColor;
    self.typewriter.textColor = [UIColor cyanColor];
    self.typewriter.font = [UIFont fontWithName:@"Arial-Hebrew" size:14];
    self.typewriter.textAlignment = NSTextAlignmentCenter;
    self.typewriter.numberOfLines = 0;
    [self addSubview:self.typewriter];
    
//    if (self.dismissButton != nil) {
//        return;
//    }
    self.dismissButton = [[UIButton alloc]initWithFrame:[self dismissFrame]];
    [self.dismissButton setTitle:@"X" forState:UIControlStateNormal];
    self.dismissButton.layer.cornerRadius = 30;
    self.dismissButton.backgroundColor = [UIColor topGradientColor];
    self.dismissButton.alpha = 1;
    self.dismissButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.dismissButton.layer.borderWidth = 1;
    [self.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(hideTappedHandler) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.dismissButton]; //Make sure to add above everything and that the overlapping part still recognizes touch
    
    [self.typewriter setText:@""];
    [self performSelector:@selector(animationWrapper) withObject:nil afterDelay:1];
}

- (void)animationWrapper {
    if (![self.typewriter.text  isEqual: @""]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self typwriterText:@"Welcome to Choreganizer, add to do items and send yourself reminders, via microphone or text" delayBetweenChars:0.015];
    });
}

//TODO update for ipad
- (CGRect)dismissFrame {
    return CGRectMake(self.frame.size.width - 30, - 30, 60, 60);
}

- (CGRect)labelFrame {
    return CGRectMake(30, 30, self.frame.size.width - 60, self.frame.size.height - 60);
}

//https://stackoverflow.com/questions/11686642/letter-by-letter-animation-for-uilabel

- (void)typwriterText:(NSString *)text delayBetweenChars:(NSTimeInterval)delay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.typewriter setText:@""];
    });
    for (int i=0; i < text.length; i++) {
        dispatch_async(dispatch_get_main_queue(), ^{ //may be on main thread, check?
            if (self.hidden == YES) {
                return; //Set string property back?
            }
            NSString *toSet = [NSString stringWithFormat:@"%@%C", self.typewriter.text, [text characterAtIndex:i]];
            if (!toSet) {
                return;
            }
            [self.typewriter setText:toSet];
        });
        //Necessary?
        [NSThread sleepForTimeInterval:delay];
    }
}

@end
