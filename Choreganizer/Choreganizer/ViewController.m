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
    
    NSString *schemeString = [[NSUserDefaults standardUserDefaults]objectForKey:schemeKey];
    
    if (schemeString) {
        
        if ([schemeString isEqualToString:@"Space"]) {
            
            self.scheme = (Scheme)Space;
            
        } else if ([schemeString isEqualToString:@"Color"]) {
            
            self.scheme = (Scheme)Color;
        }
    }
    
    [self.tableView reloadData];
    
    [self setUpTableView];
    
    [self setUpToolbar];
}

- (void)setUpTableView {
    
    self.navigationController.navigationBarHidden = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 75, self.view.frame.size.width, self.view.frame.size.height - 60)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self registerTableView:self.tableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    switch (self.scheme) {
        case Space:
            
            self.tableView.backgroundColor = [UIColor blackColor];
            
            break;
            
        case Color:
            
            self.tableView.backgroundColor = [UIColor cyanColor];
            
            break;
            
        default:
            
            self.tableView.backgroundColor = [UIColor blackColor];
            
            break;
    }
    
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}

- (void)setUpToolbar {
    
    self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    
    
    switch (self.scheme) {
            
        case Space:
            
            [self.toolbar setBackgroundImage:[UIImage imageNamed:@"toolbarBackground"] forToolbarPosition:
             UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
            
            
            break;
            
        case Color:
            
            [self.toolbar setBackgroundImage:[UIImage imageNamed:@"ColorToolbar"] forToolbarPosition:
             UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
            
            break;
            
        default:
            
            [self.toolbar setBackgroundImage:[UIImage imageNamed:@"toolbarBackground"] forToolbarPosition:
             UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
            
            break;

    }
    
    [self.view addSubview:self.toolbar];
    
    UIImage *question = [UIImage imageNamed:@"ToolbarImage"];
    
    NSMutableArray *navItems = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem *flexItem0 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [navItems addObject:flexItem0];
    
    UIBarButtonItem *questionItem = [[UIBarButtonItem alloc]initWithImage:question style:UIBarButtonItemStylePlain target:self action:@selector(pushToOnboarding)];
    questionItem.tintColor = [UIColor whiteColor]; 
    [navItems addObject:questionItem];
    
    UIBarButtonItem *flexItem1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [navItems addObject:flexItem1];
    
    [self.toolbar setItems:navItems];
    
}

- (void)pushToOnboarding {
    
    QuestionsViewController *questionsView = [QuestionsViewController new];
    
    [self.navigationController pushViewController:questionsView animated:YES]; 
    
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
    
    self.sectionHeader = [[SectionHeader alloc]initWithFrame:frame];
    [self.sectionHeader updateWithTitle:section];
    self.sectionHeader.delegate = self;
    
    Day *day = [ChoreController sharedInstance].days[section];
    
    [self.sectionHeader updateWithDay:day];
    
    switch (self.scheme) {
            
        case Space:
            
            [self.sectionHeader updateWithBackgroundImage:@"SectionHeader"];
            
            break;
            
        case Color:
            
            [self.sectionHeader updateWithBackgroundImage:@"DayCellTwo"];
            
            break;
            
        default:
            
            [self.sectionHeader updateWithBackgroundImage:@"SectionHeader"];
            
            break;
    }
    
    return self.sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 160;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 160);
    
    Day *day = [[ChoreController sharedInstance].days objectAtIndex:indexPath.section];
    Chore *chore = [day.chores objectAtIndex:indexPath.row];
    
    cell.textLabel.text = chore.title;
    cell.textLabel.font = [UIFont fontWithName:arialHebrew size:42];
    
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = chore.detail;
    cell.detailTextLabel.font = [UIFont fontWithName:arialHebrew size:32];
    
    cell.detailTextLabel.numberOfLines = 0;
    
//    UIImageView *cellImageView = [[UIImageView alloc]initWithFrame:cell.bounds];
//
//    cellImageView.image = [UIImage imageNamed:@"ChoreganizerCellBackground"];
//    //    cellImageView.clipsToBounds = YES;
//    [cell sendSubviewToBack:cellImageView];
//    [cell addSubview:cellImageView];
    
    switch (self.scheme) {
            
        case Space:
            
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ChoreganizerCellBackground"]];
            
            cell.imageView.image = [UIImage imageNamed:@"cellDetailImageChore"];
            cell.textLabel.textColor = [UIColor cyanColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            
            break;
            
        case Color:
            
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellTwo"]];
            
            cell.imageView.image = [UIImage imageNamed:@"CellImageTwo"];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
            
            break;
            
        default:
            
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ChoreganizerCellBackground"]];
            
            cell.imageView.image = [UIImage imageNamed:@"cellDetailImageChore"];
            cell.textLabel.textColor = [UIColor cyanColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            
            break;
    }
    
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Day *day = [[ChoreController sharedInstance].days objectAtIndex:section];
    
    return day.chores.count;
    
}

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
