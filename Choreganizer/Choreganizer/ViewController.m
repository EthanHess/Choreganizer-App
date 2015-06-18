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
#import "TableViewCell.h"
#import "AddChoreViewController.h"
#import "PickerViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, AddDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SectionHeader *sectionHeader;
@property (nonatomic, strong) Day *day;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self registerTableView:self.tableView];
    
    [self.view addSubview:self.tableView];
    
}


- (void)registerTableView:(UITableView *)tableView {
    
    [tableView registerClass:[TableViewCell class] forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];
    
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
    
    return self.sectionHeader;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    Day *day = [[ChoreController sharedInstance].days objectAtIndex:indexPath.section];
    Chore *chore = [day.chores objectAtIndex:indexPath.row];
    
    cell.textLabel.text = chore.title;
    cell.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:24];
    cell.textLabel.textColor = [UIColor brownColor];
    cell.detailTextLabel.text = chore.detail;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Chalkduster" size:16];
    cell.detailTextLabel.textColor = [UIColor brownColor];
    cell.imageView.image = [UIImage imageNamed:@"List-50"]; 
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightParchment"]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Send notification?" message:@"Would you like to be sent a reminder to do this chore?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        Chore *chore = [ChoreController sharedInstance].chores[indexPath.row];
        
        [self popPickerViewControllerWithChore:chore andDay:chore.day];
        
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
