//
//  ChoreController.m
//  Choreganizer
//
//  Created by Ethan Hess on 6/5/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "ChoreController.h"
#import "Stack.h"


@implementation ChoreController

+ (ChoreController *)sharedInstance {
    static ChoreController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ChoreController new];
    });
    
    return sharedInstance;
}

- (void)addChoreWithTitle:(NSString *)title andDescription:(NSString *)detail toDay:(Day *)day {
    Chore *chore = [NSEntityDescription insertNewObjectForEntityForName:@"Chore" inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    chore.title = title;
    chore.detail = detail;
    chore.day = day;
    [self synchronize];
}

- (void)addDayWithName:(NSString *)name {
    Day *day = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    day.name = name;
    [self synchronize];
}

- (void)removeChore:(Chore *)chore {
    [chore.managedObjectContext deleteObject:chore];
    [self synchronize];
}

- (NSArray *)days {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Day"];
    NSArray *objects = [[Stack sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return objects;
}

- (NSArray *)chores {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Chore"];
    NSArray *objects = [[Stack sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return objects;
}

- (void)synchronize {
    [[Stack sharedInstance].managedObjectContext save:NULL];
}

@end
