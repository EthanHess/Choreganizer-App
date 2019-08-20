//
//  SpeechController.m
//  Choreganizer
//
//  Created by Ethan Hess on 8/10/18.
//  Copyright © 2018 Ethan Hess. All rights reserved.
//

#import "SpeechController.h"
#import <Speech/Speech.h>
#import <AVKit/AVKit.h>

//TODO move to Add Chore VC
static NSString *const locale = @"en-UR";

//Can discard this class after test
@interface SpeechController()

@property (nonatomic, strong) SFSpeechRecognizer *speechRec;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *theRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask *theTask;
@property (nonatomic, strong) AVAudioEngine *theEngine;
@property (nonatomic, strong) NSString *stringSoFar;
@property (nonatomic, assign) BOOL hasPassedFive;
@property (nonatomic, assign) BOOL duplicateStringOne;

@end

@implementation SpeechController

+ (SpeechController *)sharedInstance {
    static SpeechController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [SpeechController new];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //[self setup];
    }
    return self;
}

- (void)setup {
    self.theEngine = [[AVAudioEngine alloc] init];
    self.speechRec = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:locale]];
    self.theRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    self.theRequest.shouldReportPartialResults = YES;
    
    AVAudioInputNode *node =  [self.theEngine inputNode];
    AVAudioFormat *format = [node outputFormatForBus:0];
    [node installTapOnBus:0 bufferSize:1024 format:format block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.theRequest appendAudioPCMBuffer:buffer];
    }];
    
    [self.theEngine prepare];
}

//isFinal boolean is taking forever, so we'll do this temporary workaround

- (void)setHasPassedFiveSeconsBoolean {
    self.hasPassedFive = YES;
}

- (void)startAudio {
    [self.theRequest endAudio]; //?
    self.duplicateStringOne = NO;
    [self setup];
    //self.hasPassedFive = NO;
    self.stringSoFar = @"";
    //[self performSelector:@selector(setHasPassedFiveSeconsBoolean) withObject:nil afterDelay:5];
    
    if (self.speechRec.isAvailable == NO) {
        NSLog(@"--- SPEECH NOT AVAILABLE ---");
        return;
    } else {
        NSError *error = nil;
        [self.theEngine startAndReturnError:&error];
        
        self.theTask = [self.speechRec recognitionTaskWithRequest:self.theRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            if (error) {
                [self.delegate handleError:error];
                [self.theRequest endAudio];
                [self endAudio];
                return;
            }
            if (result == nil) {
                NSLog(@"--- NO RESULT ---");
                return;
            }
            NSString *resultString = [result.bestTranscription formattedString];
            self.stringSoFar = resultString;
            if (resultString && self.delegate) {
                NSLog(result.isFinal ? @"FN YES" : @"FN NO");
                if (result.isFinal) {
                    [self.theRequest endAudio];
                    [self.delegate stringDetermined:resultString];
                    [self endAudio];
                } else {
                    NSLog(@"STRING SEGMENT %@ --- %@", resultString, self.stringSoFar);
                    //if (self.hasPassedFive == YES) {
                        if ([self.stringSoFar isEqualToString:resultString]) {
                            if (self.duplicateStringOne == YES) {
                                [self.theRequest endAudio];
                                [self.delegate stringDetermined:resultString];
                                [self endAudio];
                            } else {
                                self.duplicateStringOne = YES;
                            }
                        }
                    //}
                }
            }
        }];
    }
}

- (void)endAudio {
    if (self.theTask == nil || self.theEngine == nil) {
        return;
    }
    [self.theTask finish];
    self.theTask = nil;
    [self.theEngine stop];
}

@end
