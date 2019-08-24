//
//  AddChoreViewController.m
//  Choreganizer
//
//  Created by Ethan Hess on 6/17/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "AddChoreViewController.h"
#import "ViewController.h"
#import "ChoreController.h"
#import "QuestionsViewController.h"
#import "SpeechContainerView.h"
#import "AppDelegate.h"
//#import "SpeechController.h"
#import "GlobalFunctions.h"

#import <Speech/Speech.h> //Should updgrade to Siri kit eventually
#import <AVKit/AVKit.h>

#define IS_IPHONE_4 ([UIScreen mainScreen].bounds.size.height == 480.0)

static NSString *const pencilFilled = @"icons8filledPencil";
static NSString *const microFilled = @"icons8filledMicro";
static NSString *const pencilWhite = @"icons8whitePencil";
static NSString *const microWhite = @"icons8whiteMicro";

static NSString *const locale = @"en-UR";

@interface AddChoreViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSString *schemeString;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, assign) CGRect labelFrame;
@property (nonatomic, strong) NSString *chosenString;
@property (nonatomic, strong) UIView *containerView; //for write/speech choice
@property (nonatomic, strong) UIImageView *microImageView;
@property (nonatomic, strong) UIImageView *pencilImageView;
@property (nonatomic, strong) UIButton *textOptionsButton;
@property (nonatomic, strong) UIButton *containerDismissButton; //CV subviews
@property (nonatomic, strong) UILabel *inputTypeLabel;

@property (nonatomic, strong) SpeechContainerView *speechContainer;

@property (nonatomic) BOOL microMode;

//For speech
@property (nonatomic, strong) SFSpeechRecognizer *speechRec;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *theRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask *theTask;
@property (nonatomic, strong) AVAudioEngine *theEngine;

@property (nonatomic, strong) NSString *speechStringSoFar; //chosen string can replace this
@property (nonatomic, strong) NSTimer *speechTimer; //To detect lack of speech for however many seconds.
@property (nonatomic, strong) NSTimer *checkFinishedTimer;
@property (nonatomic, assign) int secondsWithoutSpeaking;
@property (nonatomic, assign) BOOL shouldEndAudio;
//@property (nonatomic, assign) BOOL shouldShowAlert;

@end

@implementation AddChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.microMode = NO;
    self.secondsWithoutSpeaking = 0;
    self.shouldEndAudio = NO;
    //self.shouldShowAlert = NO;
    
    //TODO Should reconfigure with stack views
    
    [self setScheme];
    
    self.textField = [UITextField new];
    self.textField.delegate = self;
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.placeholder = @"Add Chore Title";
    self.textField.backgroundColor = [UIColor colorWithRed:217/255.0f green:251/255.0f blue:244/255.0f alpha:1.0f];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.layer.borderColor = [[UIColor blackColor]CGColor];
    self.textField.layer.borderWidth = 1.5;
    self.textField.layer.masksToBounds = YES;
    [self.view addSubview:self.textField];
    
    self.textView = [UITextView new];
    self.textView.delegate = self;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.backgroundColor = [UIColor colorWithRed:217/255.0f green:251/255.0f blue:244/255.0f alpha:1.0f];
    self.textView.layer.borderColor = [[UIColor blackColor]CGColor];
    self.textView.layer.borderWidth = 1.5;
    self.textView.text = @"Chore Description";
    [self.view addSubview:self.textView];
    
    self.saveButton = [UIButton new];
    self.saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.saveButton.backgroundColor = [UIColor colorWithRed:15.0f/255.0f green:157.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    //[self.saveButton setBackgroundImage:[UIImage imageNamed:@"BBG"] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveChoreToDay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
    
    self.dismissButton = [UIButton new];
    self.dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.dismissButton.backgroundColor = [UIColor colorWithRed:15.0f/255.0f green:114.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    self.dismissButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    //[self.dismissButton setBackgroundImage:[UIImage imageNamed:@"BBG"] forState:UIControlStateNormal];
    [self.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
    self.clearButton = [UIButton new];
    self.clearButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.clearButton.backgroundColor = [UIColor colorWithRed:67.0f/255.0f green:15.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    self.clearButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    //[self.clearButton setBackgroundImage:[UIImage imageNamed:@"BBG"] forState:UIControlStateNormal];
    [self.clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearFields) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearButton];
    
    [self setUpConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //[self kvo];
    [self speechFunctionalitySetup];
}

- (void)kvo {
    [self addObserver:self forKeyPath:@"chosenString" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
}

- (void)handleError:(NSError *)error {
    [GlobalFunctions presentAlertWithTitle:error.localizedDescription andText:@"" fromVC:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[[SpeechController sharedInstance]startAudio];
    self.chosenString = @"";
}

- (void)setUpTitleLabel {
    
    if (IS_IPHONE_4) {
        self.labelFrame = CGRectMake(0, 60, self.view.frame.size.width, 100);
    } else {
        self.labelFrame = CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100);
    }
    
    self.titleLabel = [[UILabel alloc]initWithFrame:self.labelFrame];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:arialHebrew size:32];
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    self.titleLabel.text = self.day.name;
    self.titleLabel.textColor = self.labelColor;
    [self.view addSubview:self.titleLabel];
}

- (void)setScheme {
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:schemeKey]) {
        self.schemeString = [[NSUserDefaults standardUserDefaults]objectForKey:schemeKey];
    }
    
    if ([self.schemeString isEqualToString:@"Space"]) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        imageView.image = [UIImage imageNamed:@"ChoreganizerAdd"];
        [self.view addSubview:imageView];
        self.labelColor = [UIColor whiteColor];
        
    } else if ([self.schemeString isEqualToString:@"Color"]) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        imageView.image = [UIImage imageNamed:@"sunchore"];
        [self.view addSubview:imageView];
        self.labelColor = [UIColor whiteColor];
    }
    else {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        imageView.image = [UIImage imageNamed:@"ChoreganizerAdd"];
        [self.view addSubview:imageView];
        self.labelColor = [UIColor whiteColor];
    };
}

//Update for iPad too
- (BOOL)isIphoneX {
    return self.view.frame.size.height == 812;
}

- (BOOL)isIphoneXR {
    return self.view.frame.size.height == 896;
}


- (void)setUpConstraints {
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_textField, _textView, _saveButton, _dismissButton, _clearButton);
    
    CGFloat yCoord = 0;
    if ([self isIphoneX] == YES || [self isIphoneXR] == YES) {
        yCoord = 69;
    } else {
        yCoord = 25;
    }
    //TODO update ^^ (for new iPhones too)
    
    CGFloat buttonWidth = self.view.frame.size.width / 5;
    CGFloat buttonPadding = self.view.frame.size.width / 10;
    CGFloat textInputWidth = self.view.frame.size.width - 50; //for both text field and view
    //CGFloat textViewHeight = (self.view.frame.size.height / 2) - 80;
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_textField(==50)]-75-[_textView(==200)]-50-[_dismissButton(==%f)]", yCoord, buttonWidth] options:0 metrics:nil views:viewsDictionary];
    
    NSArray *horizontalConstraintI = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-25-[_textField(==%f)]", textInputWidth] options:0 metrics:nil views:viewsDictionary];
    
    NSArray *horizontalConstraintII = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-25-[_textView(==%f)]", textInputWidth] options:0 metrics:nil views:viewsDictionary];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[_saveButton(==%f)]-%f-[_dismissButton(==%f)]-%f-[_clearButton(==%f)]" , buttonPadding, buttonWidth, buttonPadding, buttonWidth, buttonPadding, buttonWidth] options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary];
    
    NSLayoutConstraint *equalConstraint = [NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.clearButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0.0];
    
    NSLayoutConstraint *equalConstraintII = [NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.saveButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0.0];
    
    self.saveButton.layer.cornerRadius = buttonWidth / 2;
    self.saveButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.borderWidth = 1.5;
    
    self.dismissButton.layer.cornerRadius = buttonWidth / 2;
    self.dismissButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.dismissButton.layer.masksToBounds = YES;
    self.dismissButton.layer.borderWidth = 1.5;
    
    self.clearButton.layer.cornerRadius = buttonWidth / 2;
    self.clearButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.clearButton.layer.masksToBounds = YES;
    self.clearButton.layer.borderWidth = 1.5;
    
    self.textField.layer.cornerRadius = 10;
    self.textView.layer.cornerRadius = 10; 
    
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalConstraintI];
    [self.view addConstraints:horizontalConstraintII];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraint:equalConstraint];
    [self.view addConstraint:equalConstraintII];
    
    [self addShadowToView:self.saveButton];
    [self addShadowToView:self.dismissButton];
    [self addShadowToView:self.clearButton];
    
    [self addContainerViewWithImages];
}

//TODO add button to toggle container

- (void)addContainerViewWithImages {
    
    CGFloat yCoord = self.view.frame.size.height / 1.5;
    
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(50, yCoord, self.view.frame.size.width - 100, 150)];
    self.containerView.backgroundColor = [UIColor blackColor]; //Change
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.userInteractionEnabled = YES;
    self.containerView.hidden = YES; 
    [self addImageViewsToContainer];
    [self.view addSubview:self.containerView];
    [self addShadowToView:self.containerView];
}

- (void)addImageViewsToContainer {
    
    self.microImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 35, 80, 80)];
    self.microImageView.userInteractionEnabled = YES;
    self.microImageView.clipsToBounds = NO;
    self.microImageView.contentMode = UIViewContentModeScaleToFill;
    self.microImageView.image = [UIImage imageNamed:microWhite]; //default is filled
    
    UITapGestureRecognizer *microTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleMicroTap)];
    [self.microImageView addGestureRecognizer:microTap];
    [self.containerView addSubview:self.microImageView];
    
    CGFloat secondX = self.containerView.frame.size.width - 120;
    
    self.pencilImageView = [[UIImageView alloc]initWithFrame:CGRectMake(secondX, 35, 80, 80)];
    self.pencilImageView.userInteractionEnabled = YES;
    self.pencilImageView.clipsToBounds = NO;
    self.pencilImageView.contentMode = UIViewContentModeScaleToFill;
    self.pencilImageView.image = [UIImage imageNamed:pencilFilled]; //default is filled
    
    UITapGestureRecognizer *pencilTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePencilTap)];
    [self.pencilImageView addGestureRecognizer:pencilTap];
    [self.containerView addSubview:self.pencilImageView];
    
    [self addOtherSubviewsToContainerView];
    [self textOptionsToggleButton];
}

- (void)addOtherSubviewsToContainerView {
    self.containerDismissButton = [[UIButton alloc]initWithFrame:CGRectMake(self.containerView.frame.size.width - 35, 10, 25, 25)] ;
    [self.containerDismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.containerDismissButton setTitle:@"X" forState:UIControlStateNormal];
    self.containerDismissButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.containerDismissButton.layer.borderWidth = 1;
    self.containerDismissButton.layer.cornerRadius = 12.5;
    [self.containerDismissButton addTarget:self action:@selector(textOptionsHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.containerDismissButton];
    
    self.inputTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.containerView.frame.size.width / 3, 5, self.containerView.frame.size.width / 3, 20)];
    self.inputTypeLabel.text = self.microMode == YES ? @"Microphone" : @"Manual";
    self.inputTypeLabel.textColor = [UIColor whiteColor];
    self.inputTypeLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.inputTypeLabel];
}

- (void)textOptionsToggleButton {
    if (self.textOptionsButton == nil) {
        self.textOptionsButton = [[UIButton alloc]initWithFrame:CGRectMake(50, self.view.frame.size.height - 140, self.view.frame.size.width - 100, 30)];
        [self.textOptionsButton addTarget:self action:@selector(textOptionsHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.textOptionsButton setTitle:@"Input options" forState:UIControlStateNormal];
        [self.textOptionsButton setBackgroundColor:[UIColor colorWithRed:15.0f/255.0f green:114.0f/255.0f blue:242.0f/255.0f alpha:1.0]]; //TODO custom
        self.textOptionsButton.layer.cornerRadius = 5;
        [self.textOptionsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:self.textOptionsButton];
    }
}

- (void)textOptionsHandler {
    if (self.containerView.hidden == YES) {
        self.containerView.hidden = NO;
        //TODO config
    } else {
        self.containerView.hidden = YES;
    }
}

- (void)indicator {
    if (self.speechContainer == nil) {
        self.speechContainer = [[SpeechContainerView alloc]initWithFrame:CGRectMake(100, (self.view.frame.size.height / 2) - 35, self.view.frame.size.width - 200, 70)];
        [self.view addSubview:self.speechContainer];
        [self addShadowToView:self.speechContainer];
        
         //test, hide eventually by default
        [self performSelector:@selector(animateDots) withObject:nil afterDelay:1];
    }
}

- (void)animateDots {
    [self.speechContainer animateDots];
}

- (void)handleMicroTap {
    if (self.microMode == YES) {
        //Do nothing
        
    } else {
        [self indicator]; 
        self.inputTypeLabel.text = @"Microphone";
        self.microImageView.image = [UIImage imageNamed:microFilled];
        self.pencilImageView.image = [UIImage imageNamed:pencilWhite];
        self.microMode = YES;
        [self startRecording];
        [self inputTypeAnimationWrapper]; 
    }
}

- (void)handlePencilTap {
    if (self.microMode == YES) {
        self.inputTypeLabel.text = @"Manual";
        self.microImageView.image = [UIImage imageNamed:microWhite];
        self.pencilImageView.image = [UIImage imageNamed:pencilFilled];
        self.microMode = NO;
        [self endRecording];
        [self inputTypeAnimationWrapper];
    } else {
        //Do nothing
    }
}

- (void)inputTypeAnimationWrapper {
    NSString *animationKey = @"transform";
    CABasicAnimation *pulsate = [CABasicAnimation animationWithKeyPath:animationKey];
    pulsate.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    pulsate.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.5)];
    [pulsate setDuration:0.5];
    [pulsate setAutoreverses:YES];
    [pulsate setRepeatCount:1];
    [self.inputTypeLabel.layer addAnimation:pulsate forKey:animationKey];
}

- (void)updateWithDay:(Day *)day {
    self.day = day;
    [self setUpTitleLabel];
}


- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveChoreToDay {
    [[ChoreController sharedInstance]addChoreWithTitle:self.textField.text andDescription:self.textView.text toDay:self.day];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)clearFields {
    self.textField.text = @"";
    self.textView.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound) {
        return YES;
    }
    
    [textView resignFirstResponder];
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Chore Description";
    }
}

- (void)addShadowToView:(UIView *)view {
    view.layer.shadowColor = [UIColor whiteColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 5.0;
    if (![view isKindOfClass:[UIButton class]]) {
        view.clipsToBounds = NO;
    }
}

#pragma Speech

- (void)speechFunctionalitySetup {
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

- (void)startRecording {
    if (self.speechRec.isAvailable == NO) {
        NSLog(@"--- SPEECH NOT AVAILABLE ---");
        return;
    } else {
        NSError *error = nil;
        [self.theEngine startAndReturnError:&error];
        //Start task
        
        [self startSpeechTimer];
        [self startCheckFinishedTimer];
        
        self.theTask = [self.speechRec recognitionTaskWithRequest:self.theRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            if (error) {
                [self handleError:error];
                [self.theRequest endAudio];
                [self endRecording];
                [self endSpeechTimer];
                [self endCheckTimer];
                return;
            }
            if (result == nil) {
                NSLog(@"--- NO RESULT ---");
                [self.theRequest endAudio];
                [self endRecording];
                [self endSpeechTimer];
                [self endCheckTimer];
                return;
            }
            NSString *resultString = [result.bestTranscription formattedString];
            if (resultString) {
                self.speechStringSoFar = resultString;
                self.secondsWithoutSpeaking = 0; //is this the best place to set?
                
                //End audio should be called within block so we'll set a bool in another function then right after we'll check, could also use a completion block or return yes/no value
                
                //Delayed block here to check has finished boolean, then end audio (from inside block)
                dispatch_time_t dt = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(dt, dispatch_get_main_queue(), ^{
                    if (self.shouldEndAudio == YES) {
                        [self.theRequest endAudio];
                        [self endRecording];
                    }
                });
            }
        }];
    }
}

#pragma Speech

- (void)handlePresentSpeechText {
    if (self.secondsWithoutSpeaking > 3) {
        self.shouldEndAudio = NO;
        [self endSpeechTimer];
        [self endCheckTimer];
        self.secondsWithoutSpeaking = 0;
        [GlobalFunctions presentChoiceAlertWithTitle:self.speechStringSoFar andText:@"Is this what you meant to say?" fromVC:self andCompletion:^(BOOL correct) {
            if (correct == YES) {
                self.textView.text = @"";
                self.textView.text = self.speechStringSoFar;
                //set has finished boolean
            } else {
                //try again (start timer/reset)
                self.shouldEndAudio = NO;
                [self startSpeechTimer];
                [self startCheckFinishedTimer];
            }
        }];
    }
}

- (void)incrementHasntSpokenSeconds {
    self.secondsWithoutSpeaking = self.secondsWithoutSpeaking + 1;
}

- (void)startCheckFinishedTimer {
    self.checkFinishedTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handlePresentSpeechText) userInfo:nil repeats:YES];
}

- (void)endCheckTimer {
    [self.checkFinishedTimer invalidate];
}

- (void)startSpeechTimer {
    self.speechTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementHasntSpokenSeconds) userInfo:nil repeats:YES];
}

- (void)endSpeechTimer {
    [self.speechTimer invalidate];
}

- (void)endRecording {
    if (self.theTask == nil || self.theEngine == nil) {
        return;
    }
    [self.theTask finish];
    self.theTask = nil;
    [self.theEngine stop];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Memory warning recieved in %@", self);
}

//End lifecycle

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
