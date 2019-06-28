//
//  SpeechContainerView.m
//  Choreganizer
//
//  Created by Ethan Hess on 7/27/18.
//  Copyright © 2018 Ethan Hess. All rights reserved.
//

#import "SpeechContainerView.h"

@interface SpeechContainerView()

@property (nonatomic, strong) UILabel *saySomethingLabel;
@property (nonatomic, strong) NSMutableArray *dotArray;

@end

@implementation SpeechContainerView

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
        self.backgroundColor = [UIColor darkGrayColor];
        [self cornerRadiusConfig];
        [self setUpDots];
    }
    
    return self;
}

- (void)cornerRadiusConfig {
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = NO;
    //Border?
}

- (void)setUpDots {
    
    //Label
    self.saySomethingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    self.saySomethingLabel.textColor = [UIColor whiteColor];
    self.saySomethingLabel.text = @"Say Something";
    self.saySomethingLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.saySomethingLabel];
    
    //Dots
    if (self.dotArray == nil) {
        self.dotArray = [[NSMutableArray alloc]init];
    }
    [self.dotArray removeAllObjects];
    
    for (int i = 0; i < 10; i += 2) {
        CGFloat x = (self.frame.size.width / 11) * i;
        CGFloat buffer = x + (self.frame.size.width / 22);
        UIView *theView = [[UIView alloc]initWithFrame:CGRectMake(i + buffer, 40, 20, 20)];
        theView.backgroundColor = [self customColors][i / 2];
        theView.layer.cornerRadius = theView.frame.size.width / 2;
        //theView.layer.borderColor = [[UIColor darkGrayColor]CGColor];
        //theView.layer.borderWidth = 3;
        theView.layer.masksToBounds = YES;
        [self.dotArray addObject:theView];
        [self addSubview:theView];
    }
}

- (NSArray *)customColors {
    UIColor *colorOne = [UIColor colorWithRed:15.0f/255.0f green:242.0f/255.0f blue:208.0f/255.0f alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:15.0f/255.0f green:144.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    UIColor *colorThree = [UIColor colorWithRed:216.0f/255.0f green:242.0f/255.0f blue:15.0f/255.0f alpha:1.0];
    UIColor *colorFour = [UIColor colorWithRed:242.0f/255.0f green:15.0f/255.0f blue:225.0f/255.0f alpha:1.0];
    UIColor *colorFive = [UIColor colorWithRed:148.0f/255.0f green:242.0f/255.0f blue:15.0f/255.0f alpha:1.0];
    return @[colorOne, colorTwo, colorThree, colorFour, colorFive];
}

- (void)animateDots {
    if (!self.dotArray) {
        return;
    }
    for (int i = 0; i < self.dotArray.count; i++) {
        UIView *view = self.dotArray[i];
        [UIView animateWithDuration:1 delay:0.5 * i options:UIViewAnimationOptionAutoreverse animations:^{
            view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            //Do something?
            if (!self.hidden) {
                [self performSelector:@selector(setHidden) withObject:nil afterDelay:3];
            }
        }];
    }
}

//Fade away? May be too abrupt
- (void)setHidden {
    self.hidden = YES;
}

- (void)setBack {
    for (UIView *theView in self.dotArray) {
        NSLog(@"--- DESC --- %@", theView.description);
    }
}

@end
