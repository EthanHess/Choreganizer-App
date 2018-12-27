//
//  GlobalFunctions.m
//  Choreganizer
//
//  Created by Ethan Hess on 7/27/18.
//  Copyright © 2018 Ethan Hess. All rights reserved.
//

#import "GlobalFunctions.h"

@implementation GlobalFunctions

+ (void)presentAlertWithTitle:(NSString *)title andText:(NSString *)text fromVC:(UIViewController *)theVC {
    
    UIAlertController *theAlert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
    
    [theAlert addAction:okayAction];
    [theVC presentViewController:theAlert animated:YES completion:nil];
}

+ (void)presentChoiceAlertWithTitle:(NSString *)title andText:(NSString *)text fromVC:(UIViewController *)theVC andCompletion:(void (^)(BOOL))isCorrect {
    
    UIAlertController *theAlert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *correctAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        isCorrect(NO);
    }];
    
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        isCorrect(YES);
    }];
    
    [theAlert addAction:okayAction];
    [theAlert addAction:correctAction];
    [theVC presentViewController:theAlert animated:YES completion:nil];
}

+ (float)heightFromTextCount:(int)count {
    if (count > 60 && count < 120) {
        return 30.0; //add another line
    }
    if (count > 120 && count < 180) {
        return 60.0;
    }
    if (count > 180 && count < 240) {
        return 90.0;
    } else {
        return 0;
    }
}

//For ipad update

+ (BOOL)isIphone {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return YES;
    } else {
        return NO; //check if ipad? could be other things
    }
}

@end
