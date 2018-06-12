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
#import "AppDelegate.h"
#import <Speech/Speech.h>

#define IS_IPHONE_4 ([UIScreen mainScreen].bounds.size.height == 480.0)

@interface AddChoreViewController () <UITextFieldDelegate, UITextViewDelegate, SFSpeechRecognizerDelegate>

@property (nonatomic, strong) NSString *schemeString;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, assign) CGRect labelFrame;

//Speech
@property (nonatomic, strong) SFSpeechRecognizer *speechRec;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *speechRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask *speechTask;
@property (nonatomic, strong) AVAudioEngine *theAudioEngine;
@property (nonatomic, strong) NSString *chosenString;

@end

@implementation AddChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    //self.saveButton.backgroundColor = [UIColor colorWithRed:182/255.0f green:66/255.0f blue:45/255.0f alpha:1.0f];
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"BBG"] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveChoreToDay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
    
    self.dismissButton = [UIButton new];
    self.dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    //self.dismissButton.backgroundColor = [UIColor colorWithRed:182/255.0f green:243/255.0f blue:13/255.0f alpha:1.0f];
    self.dismissButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.dismissButton setBackgroundImage:[UIImage imageNamed:@"BBG"] forState:UIControlStateNormal];
    [self.dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
    self.clearButton = [UIButton new];
    self.clearButton.translatesAutoresizingMaskIntoConstraints = NO;
    //self.clearButton.backgroundColor = [UIColor colorWithRed:99/255.0f green:48/255.0f blue:225/255.0f alpha:1.0f];
    self.clearButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"BBG"] forState:UIControlStateNormal];
    [self.clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearFields) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearButton];
    
    [self setUpConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setUpSpeechRecognizer];
}

- (void)setUpSpeechRecognizer {
    
    NSLocale *theLocale = [[NSLocale alloc]initWithLocaleIdentifier:@"en-US"]; //TODO, update for other languages
    
    self.speechRec = [[SFSpeechRecognizer alloc]initWithLocale:theLocale];
    self.speechRec.delegate = self;
    
    self.theAudioEngine = [[AVAudioEngine alloc]init];
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"Determined");
                break;
            default:
                break;
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startRecording];
}

- (void)startRecording {
    
    if (self.speechTask != nil) {
        [self.speechTask cancel];
        self.speechTask = nil;
    }
    
    AVAudioSession *theSession = [AVAudioSession sharedInstance];
    
    NSError *theError = nil;
    
    [theSession setCategory:AVAudioSessionCategoryRecord error:&theError];
    [theSession setMode:AVAudioSessionModeMeasurement error:&theError];
    [theSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&theError];
    
    self.speechRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    
    if (self.theAudioEngine.inputNode != nil) {
        if (self.speechRequest) {
            
            self.speechRequest.shouldReportPartialResults = YES;
            self.speechTask = [self.speechRec recognitionTaskWithRequest:self.speechRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"ERROR %@", error.localizedDescription); //Pop alert?
                }
                else {
                    
                    BOOL isFinal = NO;
                    
                    if (result != nil) {
                        self.chosenString = result.bestTranscription.formattedString;
                        isFinal = result.isFinal;
                    }
                    if (error != nil || isFinal == YES) {
                        [self.theAudioEngine stop];
                        [self.theAudioEngine.inputNode removeTapOnBus:0];
                        
                        self.speechTask = nil;
                        self.speechRequest = nil;
                    }
                }
            }];
            
            AVAudioFormat *format = [self.theAudioEngine.inputNode outputFormatForBus:0];
            
            [self.theAudioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:format block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
                [self.speechRequest appendAudioPCMBuffer:buffer];
            }];
            
            [self.theAudioEngine prepare];
            [self.theAudioEngine startAndReturnError:&theError];
        }
    } else {
        NSLog(@"No input node!");
    }
}

- (void)setUpTitleLabel {
    
    if (IS_IPHONE_4) {
        _labelFrame = CGRectMake(0, 60, self.view.frame.size.width, 100);
    } else {
        _labelFrame = CGRectMake(0, self.view.frame.size.height -100, self.view.frame.size.width, 100);
    }
    
    self.titleLabel = [[UILabel alloc]initWithFrame:_labelFrame];
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
        imageView.image = [UIImage imageNamed:@"ColorBackground"];
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

- (void)setUpConstraints {
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_textField, _textView, _saveButton, _dismissButton, _clearButton);
    
    CGFloat buttonWidth = self.view.frame.size.width / 5;
    CGFloat buttonPadding = self.view.frame.size.width / 10;
    CGFloat textInputWidth = self.view.frame.size.width - 50; //for both text field and view
    //CGFloat textViewHeight = (self.view.frame.size.height / 2) - 80;
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-25-[_textField(==50)]-75-[_textView(==200)]-50-[_dismissButton(==%f)]", buttonWidth] options:0 metrics:nil views:viewsDictionary];
    
    NSArray *horizontalConstraintI = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-25-[_textField(==%f)]", textInputWidth] options:0 metrics:nil views:viewsDictionary];
    
    NSArray *horizontalConstraintII = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-25-[_textView(==%f)]", textInputWidth] options:0 metrics:nil views:viewsDictionary];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[_saveButton(==%f)]-%f-[_dismissButton(==%f)]-%f-[_clearButton(==%f)]" , buttonPadding, buttonWidth, buttonPadding, buttonWidth, buttonPadding, buttonWidth] options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary];
    
    NSLayoutConstraint *equalConstraint = [NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.clearButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0.0];
    
    NSLayoutConstraint *equalConstraintII = [NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.saveButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0.0];
    
    self.saveButton.layer.cornerRadius = buttonWidth / 2;
    self.saveButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.borderWidth = 1.5;
    
    self.dismissButton.layer.cornerRadius = buttonWidth / 2;
    self.dismissButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.dismissButton.layer.masksToBounds = YES;
    self.dismissButton.layer.borderWidth = 1.5;
    
    self.clearButton.layer.cornerRadius = buttonWidth / 2;
    self.clearButton.layer.borderColor = [[UIColor blackColor]CGColor];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
