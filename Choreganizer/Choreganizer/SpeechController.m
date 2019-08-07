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

static NSString *const locale = @"en-UR";

@interface SpeechController()

@property (nonatomic, strong) SFSpeechRecognizer *speechRec;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *theRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask *theTask;
@property (nonatomic, strong) AVAudioEngine *theEngine;
@property (nonatomic, strong) NSString *stringSoFar;
@property (nonatomic, assign) BOOL hasPassedFive;

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
    [self setup];
    self.hasPassedFive = NO;
    self.stringSoFar = @"";
    [self performSelector:@selector(setHasPassedFiveSeconsBoolean) withObject:nil afterDelay:5];
    
    if (self.theTask != nil || self.speechRec.isAvailable == NO) {
        //Present alert and return
        return;
    } else {
        NSError *error = nil;
        [self.theEngine startAndReturnError:&error];
        
        self.theTask = [self.speechRec recognitionTaskWithRequest:self.theRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            if (error) {
                [self.delegate handleError:error];
                return;
            }
            NSString *resultString = [result.bestTranscription formattedString];
            self.stringSoFar = resultString;
            if (resultString && self.delegate) {
                NSLog(result.isFinal ? @"FN YES" : @"FN NO");
                if (result.isFinal) {
                    [self.delegate stringDetermined:resultString];
                } else {
                    NSLog(@"STRING SEGMENT %@", resultString);
                    if (self.hasPassedFive == YES) {
                        if ([self.stringSoFar isEqualToString:resultString]) {
                            [self.delegate stringDetermined:resultString];
                        }
                    }
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
