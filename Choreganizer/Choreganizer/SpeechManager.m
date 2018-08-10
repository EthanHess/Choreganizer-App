//
//  SpeechManager.m
//  Choreganizer
//
//  Created by Ethan Hess on 7/27/18.
//  Copyright © 2018 Ethan Hess. All rights reserved.
//

#import "SpeechManager.h"

@implementation SpeechManager

+ (SpeechManager *)sharedInstance {
    static SpeechManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [SpeechManager new];
    });
    
    return sharedInstance;
    
}

@end
