//
//  SpeechController.h
//  Choreganizer
//
//  Created by Ethan Hess on 8/10/18.
//  Copyright © 2018 Ethan Hess. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SpeechDelegate
- (void)stringDetermined:(NSString *)speechText;
- (void)handleError:(NSError *)error;
@end

@interface SpeechController : NSObject

@property (nonatomic, weak) id <SpeechDelegate> delegate ;

+ (SpeechController *)sharedInstance;

- (void)startAudio;
- (void)endAudio;

@end
