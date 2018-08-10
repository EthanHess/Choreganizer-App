//
//  GlobalFunctions.h
//  Choreganizer
//
//  Created by Ethan Hess on 7/27/18.
//  Copyright © 2018 Ethan Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalFunctions : NSObject

+ (void)presentAlertWithTitle:(NSString *)title andText:(NSString *)text fromVC:(UIViewController *)theVC;

+ (void)presentChoiceAlertWithTitle:(NSString *)title andText:(NSString *)text fromVC:(UIViewController *)theVC andCompletion:(void (^)(BOOL correct))isCorrect;

+ (float)heightFromTextCount:(int)count;

@end
