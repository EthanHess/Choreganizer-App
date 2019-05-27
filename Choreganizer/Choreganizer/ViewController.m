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

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, AddDelegate>

typedef enum {
    Space,
    Color,
} Scheme;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SectionHeader *sectionHeader;
@property (nonatomic, strong) UIToolbar *toolbar; 
@property (nonatomic, strong) Day *day;

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
    //[self preferredStatusBarStyle];
    self.view.backgroundColor = [UIColor blackColor];
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
    
    self.tableView = [[UITableView alloc]initWithFrame:[self tableFrame]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.panGestureRecognizer.cancelsTouchesInView = NO;
    [self registerTableView:self.tableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
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

    [self.view addSubview:self.tableView];
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
            [self addImageToToolbar:@"toolbarBackground" andToolbar:self.toolbar];
            break;
        case Color:
            [self addImageToToolbar:@"ColorToolbar" andToolbar:self.toolbar];
            break;
    }
    
    [self.view addSubview:self.toolbar];
    UIImage *question = [UIImage imageNamed:@"questionMarkI8"];
    UIImage *edit = [UIImage imageNamed:@"editX"];
    NSMutableArray *navItems = [[NSMutableArray alloc] initWithCapacity:3];
    UIBarButtonItem *flexItem0 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [navItems addObject:flexItem0];
    UIBarButtonItem *questionItem = [[UIBarButtonItem alloc]initWithImage:question style:UIBarButtonItemStylePlain target:self action:@selector(pushToOnboarding)];
    questionItem.tintColor = [UIColor whiteColor]; 
    [navItems addObject:questionItem];
    UIBarButtonItem *flexItem1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [navItems addObject:flexItem1];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithImage:edit style:UIBarButtonItemStylePlain target:self action:@selector(editHandle)];
    editItem.tintColor = [UIColor whiteColor];
    [navItems addObject:editItem];
    UIBarButtonItem *flexItem2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [navItems addObject:flexItem2];
    [self.toolbar setItems:navItems];
}

//We already have QVC in the stack, push to new/improved oboarding conroller
- (void)pushToOnboarding {
    //QuestionsViewController *qvc = [QuestionsViewController new];
    //[self.navigationController pushViewController:qvc animated:YES];
}

- (void)editHandle {
    if (self.tableView.isEditing == NO) {
        [self.tableView setEditing:YES];
    } else {
        [self.tableView setEditing:NO];
    }
}


- (void)registerTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
            [self addTwoColorsToMakeGradient:[UIColor colorWithRed:3.0f/255.0f green:33.0f/255.0f blue:61.0f/255.0f alpha:1.0] colorTwo:[UIColor blackColor] andView:self.sectionHeader];
            self.sectionHeader.addButton.backgroundColor =  [UIColor colorWithRed:165.0f/255.0f green:245.0f/255.0f blue:179.0f/255.0f alpha:1.0];
            break;
        case Color:
            [self addTwoColorsToMakeGradient:[UIColor colorWithRed:11.0f/255.0f green:241.0f/255.0f blue:223.0f/255.0f alpha:1.0] colorTwo:[UIColor colorWithRed:11.0f/255.0f green:67.0f/255.0f blue:241.0f/255.0f alpha:1.0] andView:self.sectionHeader];
            self.sectionHeader.addButton.backgroundColor = [UIColor colorWithRed:12.0f/255.0f green:57.0f/255.0f blue:130.0f/255.0f alpha:1.0];
            break;
    }
}

//Add util function, eventually move out of VC
- (void)addTwoColorsToMakeGradient:(UIColor *)colorOne colorTwo:(UIColor *)colorTwo andView:(UIView *)theView {
    
    CAGradientLayer *theGradient = [CAGradientLayer layer];
    theGradient.colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    
    if ([theView isKindOfClass:[UITableViewCell class]]) {
        CGFloat width = self.view.frame.size.width;
        CGFloat height = 160;
        theGradient.frame = CGRectMake(0, 0, width, height);
        [theView.layer insertSublayer:theGradient atIndex:0];
    } else {
        theGradient.frame = theView.bounds;
        [theView.layer insertSublayer:theGradient atIndex:0];
    }
}

//TV 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160; //TODO size for text
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

    Day *day = [[ChoreController sharedInstance].days objectAtIndex:indexPath.section];
    Chore *chore = [day.chores objectAtIndex:indexPath.row];
    
    cell.textLabel.text = chore.title;
    cell.textLabel.font = [UIFont fontWithName:arialHebrew size:22];
    cell.textLabel.font = [UIFont systemFontOfSize:22];
    
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = chore.detail;
    cell.detailTextLabel.font = [UIFont fontWithName:arialHebrew size:18];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
    
    cell.detailTextLabel.numberOfLines = 0;
    
    UIColor *topColorSpace = [UIColor colorWithRed:14.0f/255.0f green:125.0f/255.0f blue:227.0f/255.0f alpha:1.0];
    UIColor *topColorColor = [UIColor colorWithRed:11.0f/255.0f green:241.0f/255.0f blue:223.0f/255.0f alpha:1.0];
    
    //[UIColor colorWithRed:2.0f/255.0f green:34.0f/255.0f blue:20.0f/255.0f alpha:1.0]
    switch (self.scheme) {
        case Space:
            [self addTwoColorsToMakeGradient:topColorSpace colorTwo:[UIColor blackColor] andView:cell];
            cell.imageView.image = [UIImage imageNamed:@"cellDetailImageChore"];
            cell.textLabel.textColor = [UIColor cyanColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            break;
        case Color:
            [self addTwoColorsToMakeGradient:topColorColor colorTwo:[UIColor colorWithRed:11.0f/255.0f green:67.0f/255.0f blue:241.0f/255.0f alpha:1.0] andView:cell];
            cell.imageView.image = [UIImage imageNamed:@"CellImageTwo"];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            break;
    }
    return cell;
}

- (void)addImageToCell:(NSString *)imageName andCell:(UITableViewCell *)cell {
    CGRect imageFrame = CGRectMake(0, 0, self.tableView.contentSize.width, 160);
    UIImageView *cellImageView = [[UIImageView alloc]initWithFrame:imageFrame];
    cellImageView.image = [UIImage imageNamed:imageName];
    [cell.contentView insertSubview:cellImageView atIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Day *day = [[ChoreController sharedInstance].days objectAtIndex:section];
    return day.chores != nil ? day.chores.count : 0;
}

#pragma cell header delegate

- (void)popAddChoreView:(Day *)day {
    AddChoreViewController *addChoreVC = [AddChoreViewController new];
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
    [pickerVC updateWithChore:chore andDay:day];
    [self.navigationController presentViewController:pickerVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
