//
//  ViewController.m
//  Choreganizer
//
//  Created by Ethan Hess on 6/5/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "ViewController.h"
#import "ChoreController.h"
#import "SectionHeader.h"
#import "AddChoreViewController.h"
#import "PickerViewController.h"
#import "QuestionsViewController.h"
#import "AppDelegate.h"
#import "UIColor+CustomColors.h"
#import "GlobalFunctions.h"
#import "EditChorePopupView.h"
#import "ChoreTodoCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, AddDelegate, EditChoreDelegate, UITextViewDelegate, UITextFieldDelegate>

typedef enum {
    Space,
    Color,
} Scheme;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SectionHeader *sectionHeader;
@property (nonatomic, strong) UIToolbar *toolbar; 
@property (nonatomic, strong) Day *day;
@property (nonatomic, strong) EditChorePopupView *editChoreView;

@property (nonatomic, assign) Scheme scheme;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *schemeString = [[NSUserDefaults standardUserDefaults]objectForKey:schemeKey];
    if (schemeString) {
        if ([schemeString isEqualToString:@"Space"]) {
            self.scheme = (Scheme)Space;
        } else if ([schemeString isEqualToString:@"Color"]) {
            self.scheme = (Scheme)Color;
        }
    } else {
        self.scheme = (Scheme)Space; //default
    }
    [self setUpToolbar];
    [self setUpTableView];
    [self editChoreViewSetup];
    
    //[self preferredStatusBarStyle];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)editChoreViewSetup {
    if (self.editChoreView == nil) {
        //TODO account for safe area y coord for new devices
        self.editChoreView = [[EditChorePopupView alloc]initWithFrame:CGRectMake(50, 150, self.view.frame.size.width - 100, self.view.frame.size.height - 250)];
        self.editChoreView.delegate = self;
        self.editChoreView.textView.delegate = self;
        self.editChoreView.textField.delegate = self;
        self.editChoreView.hidden = YES;
        [self.view addSubview:self.editChoreView];
    }
}

- (BOOL)isIphoneX {
    return self.view.frame.size.height == 812;
}

- (BOOL)isIphoneXR {
    return self.view.frame.size.height == 896;
}

//iOS 10
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (CGRect)tableFrame {
    CGRect rect;
    if ([self isIphoneX] == YES || [self isIphoneXR] == YES) {
        rect = CGRectMake(0, self.toolbar.frame.size.height + 44, self.view.frame.size.width, self.view.frame.size.height - 60);
    } else {
        rect = CGRectMake(0, self.toolbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 60);
    }
    return rect;
}

//Global functions, since we'll use more than once?
- (CGRect)toolbarFrame {
    CGRect rect;
    if ([self isIphoneX] == YES || [self isIphoneXR] == YES) {
        rect = CGRectMake(0, 44, self.view.frame.size.width, 80);
    } else {
        rect = CGRectMake(0, 0, self.view.frame.size.width, 80);
    }
    return rect;
}

- (void)setUpTableView {
    
    self.navigationController.navigationBarHidden = YES;
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:[self tableFrame]];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.panGestureRecognizer.cancelsTouchesInView = NO;
        [self registerTableView:self.tableView];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:self.tableView];
    }
    
    switch (self.scheme) {
        case Space:
            self.tableView.backgroundColor = [UIColor blackColor];
            break;
            
        case Color:
            self.tableView.backgroundColor = [UIColor colorWithRed:10.0f/255.0f green:116.0f/255.0f blue:245.0f/255.0f alpha:1.0];
            break;
            
        default:
            self.tableView.backgroundColor = [UIColor blackColor];
            break;
    }

    [self.tableView setEditing:NO]; //Will need to do to move chores around
    
    [self refresh];
}

- (void)refresh {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//Remove and add gradient
- (void)addImageToToolbar:(NSString *)imageName andToolbar:(UIToolbar *)toolbar {
    CGRect imageFrame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageFrame];
    imageView.image = [UIImage imageNamed:imageName];
    [toolbar addSubview:imageView];
}

- (void)setUpToolbar {
    self.toolbar = [[UIToolbar alloc]initWithFrame:[self toolbarFrame]];
    switch (self.scheme) {
        case Space:
            [self addTwoColorsToMakeGradient:[UIColor topGradientSpace] colorTwo:[UIColor bottomGradientSpace] andView:self.toolbar andAddedHeight:0];
            break;
        case Color:
            [self addTwoColorsToMakeGradient:[UIColor topGradientColor] colorTwo:[UIColor bottomGradientColor] andView:self.toolbar andAddedHeight:0];
            break;
    }
    
    [self.view addSubview:self.toolbar];
    UIImage *edit = [UIImage imageNamed:@"mainTopEdit"];
    edit = [edit imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableArray *navItems = [[NSMutableArray alloc] initWithCapacity:3];
    UIBarButtonItem *flexItem0 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [navItems addObject:flexItem0];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithImage:edit style:UIBarButtonItemStylePlain target:self action:@selector(editHandle)];
    editItem.tintColor = [UIColor whiteColor];
    [navItems addObject:editItem];
    UIBarButtonItem *flexItem1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [navItems addObject:flexItem1];
    [self.toolbar setItems:navItems];
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

- (void)editHandle {
    if (self.tableView.isEditing == NO) {
        [self.tableView setEditing:YES];
    } else {
        [self.tableView setEditing:NO];
    }
}


- (void)registerTableView:(UITableView *)tableView {
    [tableView registerClass:[ChoreTodoCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [ChoreController sharedInstance].days.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [SectionHeader headerHeight]; 
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, [SectionHeader headerHeight]);
    
    //TODO don't necessarily need as property anymore
    self.sectionHeader = [[SectionHeader alloc]initWithFrame:frame];
    [self.sectionHeader updateWithTitle:section];
    self.sectionHeader.delegate = self;
    
    Day *day = [ChoreController sharedInstance].days[section];
    
    [self.sectionHeader updateWithDay:day];
    [self configureGradient:self.sectionHeader];
    
    return self.sectionHeader;
}

- (void)configureGradient:(SectionHeader *)header {
    switch (self.scheme) {
        case Space:
            [self addTwoColorsToMakeGradient:[UIColor colorWithRed:3.0f/255.0f green:33.0f/255.0f blue:61.0f/255.0f alpha:1.0] colorTwo:[UIColor blackColor] andView:self.sectionHeader andAddedHeight:0];
            self.sectionHeader.addButton.backgroundColor = [UIColor topGradientColor];
            break;
        case Color:
            [self addTwoColorsToMakeGradient:[UIColor colorWithRed:11.0f/255.0f green:241.0f/255.0f blue:223.0f/255.0f alpha:1.0] colorTwo:[UIColor colorWithRed:11.0f/255.0f green:67.0f/255.0f blue:241.0f/255.0f alpha:1.0] andView:self.sectionHeader andAddedHeight:0];
            self.sectionHeader.addButton.backgroundColor = [UIColor colorWithRed:12.0f/255.0f green:57.0f/255.0f blue:130.0f/255.0f alpha:1.0];
            break;
    }
}

//Add util function, eventually move out of VC
- (void)addTwoColorsToMakeGradient:(UIColor *)colorOne colorTwo:(UIColor *)colorTwo andView:(UIView *)theView andAddedHeight:(CGFloat)addedHeight {
    
    CAGradientLayer *theGradient = [CAGradientLayer layer];
    theGradient.colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    
    for (CALayer *layer in [theView.layer sublayers]) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            [layer removeFromSuperlayer];
            break; //will crash if mutated while enumerating
        }
    }
    
    if ([theView isKindOfClass:[UITableViewCell class]]) {
        CGFloat width = self.view.frame.size.width;
        CGFloat height = 160 + addedHeight;
        theGradient.frame = CGRectMake(7.5, 5, width - 15, height - 10);
        theGradient.cornerRadius = 5;
        [theView.layer insertSublayer:theGradient atIndex:0];
    } else {
        theGradient.frame = theView.bounds;
        [theView.layer insertSublayer:theGradient atIndex:0];
    }
}

//TV 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Day *day = [[ChoreController sharedInstance].days objectAtIndex:indexPath.section];
    Chore *chore = [day.chores objectAtIndex:indexPath.row];
    CGFloat heightToAddOne = [GlobalFunctions heightFromTextCount:(int)chore.title.length];
    CGFloat heightToAddTwo = [GlobalFunctions heightFromTextCount:(int)chore.detail.length];
    CGFloat fullHeight = heightToAddOne + heightToAddTwo;
    return 160 + fullHeight; //TODO size for text
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChoreTodoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Day *day = [[ChoreController sharedInstance].days objectAtIndex:indexPath.section];
    Chore *chore = [day.chores objectAtIndex:indexPath.row];
    
    CGFloat heightToAddOne = [GlobalFunctions heightFromTextCount:(int)chore.title.length];
    CGFloat heightToAddTwo = [GlobalFunctions heightFromTextCount:(int)chore.detail.length];
    CGFloat fullHeight = heightToAddOne + heightToAddTwo;

    cell.heightToAdd = 160 + fullHeight; //TODO update with global functions for text count
    [cell cellSetup];
    
    cell.headerLabel.text = chore.title;
    cell.bodyLabel.text = chore.detail;
    
    UIColor *topColorSpace = [UIColor colorWithRed:14.0f/255.0f green:125.0f/255.0f blue:227.0f/255.0f alpha:1.0];
    UIColor *topColorColor = [UIColor colorWithRed:11.0f/255.0f green:241.0f/255.0f blue:223.0f/255.0f alpha:1.0];
    
    [self configureEditImageForCell:cell];
    
    switch (self.scheme) {
        case Space:
            [self addTwoColorsToMakeGradient:topColorSpace colorTwo:[UIColor blackColor] andView:cell andAddedHeight:fullHeight];
            cell.mainImageView.image = [UIImage imageNamed:@"planetCH"];
            cell.headerLabel.textColor = [UIColor cyanColor];
            cell.bodyLabel.textColor = [UIColor whiteColor];
            break;
        case Color:
            [self addTwoColorsToMakeGradient:topColorColor colorTwo:[UIColor colorWithRed:11.0f/255.0f green:67.0f/255.0f blue:241.0f/255.0f alpha:1.0] andView:cell andAddedHeight:fullHeight];
            cell.mainImageView.image = [UIImage imageNamed:@"photosCH"];
            cell.headerLabel.textColor = [UIColor whiteColor];
            cell.bodyLabel.textColor = [UIColor whiteColor];
            break;
    }
    
    return cell;
}

//Will want to subclass for best effect
- (void)cellContentView:(UITableViewCell *)cell {
    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.layer.masksToBounds = YES; 
}

- (void)addImageToCell:(NSString *)imageName andCell:(UITableViewCell *)cell {
    CGRect imageFrame = CGRectMake(0, 0, self.tableView.contentSize.width, 160);
    UIImageView *cellImageView = [[UIImageView alloc]initWithFrame:imageFrame];
    cellImageView.image = [UIImage imageNamed:imageName];
    [cell.contentView insertSubview:cellImageView atIndex:0];
}

- (void)configureEditImageForCell:(ChoreTodoCell *)theCell {
    theCell.editImageView.image = [UIImage imageNamed:@"blueEdit"];
    theCell.editImageView.userInteractionEnabled = YES;
    //addShadow?
    UITapGestureRecognizer *theTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleEditChore:)];
    [theCell.editImageView addGestureRecognizer:theTap];
}

- (void)handleEditChore:(id)sender {
    NSLog(@"--- SENDER --- %@", sender);
    UITapGestureRecognizer *senderGR = (UITapGestureRecognizer *)sender;
    CGPoint senderPosition = [senderGR.view convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:senderPosition];
    if (indexPath != nil) {
        NSLog(@"--- ROW --- %ld --- SECTION --- %ld", (long)indexPath.row, (long)indexPath.section);
        //Get chore
        Day *chosenDay = [ChoreController sharedInstance].days[indexPath.section];
        Chore *chosenChore = chosenDay.chores[indexPath.row];
        NSString *title = [NSString stringWithFormat:@"Would you like to edit %@?", chosenChore.title];
        [GlobalFunctions presentChoiceAlertWithTitle:title andText:@"" fromVC:self andCompletion:^(BOOL correct) { //Correct in this case will just be chose yes, but we'll use the same utils method
            if (correct == YES) {
                //Present edit view
                [self handleShowHideEditView:NO];
                self.editChoreView.chore = chosenChore;
                [self.editChoreView updateChore:chosenChore];
            } else {
                //Do nothing
            }
        }];
    } else {
        
    }
}

- (void)handleShowHideEditView:(BOOL)hide {
    if (self.editChoreView == nil) {
        return;
    }
    self.editChoreView.hidden = NO;
    //TODO animate
    
    //[self dimBackgroundWhenViewIsPopped:!hide];
}

- (void)dimBackgroundWhenViewIsPopped:(BOOL)dim {
    for (UIView *theView in self.view.subviews) {
        if (![theView isKindOfClass:[EditChorePopupView class]]) {
            theView.alpha = dim == YES ? 0.7 : 1;
            theView.userInteractionEnabled = dim == YES ? NO : YES;
        }
    }
}

//Delegate
- (void)choreEditedWithChore:(Chore *)chore andNewText:(NSString *)newText andNewTitle:(NSString *)newTitle {
    [[ChoreController sharedInstance]updateChore:chore newTitle:newText andNewText:newTitle];
    [self refresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Day *day = [[ChoreController sharedInstance].days objectAtIndex:section];
    return day.chores != nil ? day.chores.count : 0;
}

#pragma cell header delegate

- (void)popAddChoreView:(Day *)day {
    AddChoreViewController *addChoreVC = [AddChoreViewController new];
    addChoreVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [addChoreVC updateWithDay:day];
    [self.navigationController presentViewController:addChoreVC animated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Day *day = [ChoreController sharedInstance].days[indexPath.section];
        [[ChoreController sharedInstance]removeChore:day.chores[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Send notification?" message:@"Would you like to be sent a reminder to do this chore?" preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        Day *day = [ChoreController sharedInstance].days[indexPath.section];
        Chore *chore = day.chores[indexPath.row];
        [self popPickerViewControllerWithChore:chore andDay:day];
    }]];
     
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if (sourceIndexPath != destinationIndexPath) {
        
        //Really "remove from"
        Day *dayToRemove = [[ChoreController sharedInstance].days objectAtIndex:sourceIndexPath.section];
        Chore *chore = [dayToRemove.chores objectAtIndex:sourceIndexPath.row];
        
        //Really "add to"
        Day *dayToAdd = [[ChoreController sharedInstance].days objectAtIndex:destinationIndexPath.section];
        
        [[ChoreController sharedInstance]addChoreWithTitle:chore.title andDescription:chore.detail toDay:dayToAdd];
        [[ChoreController sharedInstance]removeChore:chore];
    
        [self refresh];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)popPickerViewControllerWithChore:(Chore *)chore andDay:(Day *)day {
    PickerViewController *pickerVC = [PickerViewController new];
    pickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [pickerVC updateWithChore:chore andDay:day];
    [self.navigationController presentViewController:pickerVC animated:YES completion:nil];
}

#pragma TField + TView delegates

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
