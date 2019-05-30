//
//  UIColor+CustomColors.m
//  Choreganizer
//
//  Created by Ethan Hess on 5/30/19.
//  Copyright © 2019 Ethan Hess. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)topGradientSpace {
    return [UIColor colorWithRed:1.0f/255.0f green:1.0f/255.0f blue:22.0f/255.0f alpha:1.0];
}

+ (UIColor *)bottomGradientSpace {
    return [UIColor colorWithRed:8.0f/255.0f green:6.0f/255.0f blue:119.0f/255.0f alpha:1.0]; 
}

+ (UIColor *)topGradientColor {
    return [UIColor colorWithRed:8.0f/255.0f green:6.0f/255.0f blue:94.0f/255.0f alpha:1.0];
}

+ (UIColor *)bottomGradientColor {
    return [UIColor colorWithRed:8.0f/255.0f green:173.0f/255.0f blue:227.0f/255.0f alpha:1.0];
}

@end
