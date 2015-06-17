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
#import "AddView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, AddDelegate, DismissDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SectionHeader *sectionHeader;
@property (nonatomic, strong) AddView *addView;
@property (nonatomic, strong) Day *currentDay;

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self registerTableView:self.tableView];
    
    [self.view addSubview:self.tableView];
    
    [self setUpAddView];
    
}

- (void)setUpAddView {
    
    self.addView = [[AddView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    self.addView.delegate = self;
    [self.view addSubview:self.addView];
    
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
    
    self.currentDay = [ChoreController sharedInstance].days[section];
    
    [self.sectionHeader updateWithDay:self.currentDay];
    
    return self.sectionHeader;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    Day *day = [[ChoreController sharedInstance].days objectAtIndex:indexPath.section];
    Chore *chore = [day.chores objectAtIndex:indexPath.row];
    
    cell.textLabel.text = chore.title;
    cell.detailTextLabel.text = chore.detail;
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightParchment"]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //configure
    
    Day *day = [[ChoreController sharedInstance].days objectAtIndex:section];
    
    return day.chores.count;
    
}


- (void)addChore {
    
    [self popUpAddView:self.addView distance:self.addView.frame.size.height];

}

- (void)popUpAddView:(UIView *)view distance:(float)distance {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        view.center = CGPointMake(view.center.x, view.center.y - distance);
        
    }];
    
}

- (void)dismissView {
    
    [self popDownAddView:self.addView distance:self.addView.frame.size.height];
    
}

- (void)popDownAddView:(UIView *)view distance:(float)distance {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        view.center = CGPointMake(view.center.x, view.center.y + distance);
        
    }];
    
}

- (void)saveChoreToDay:(Day *)day {
    
    [self.addView updateWithDay:self.currentDay];
    
    [self dismissView];
    
    [[ChoreController sharedInstance]addChoreWithTitle:self.addView.textField.text andDescription:self.addView.textView.text toDay:day];
    
    [self.tableView reloadData];
    
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
        
    }]];
     
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
