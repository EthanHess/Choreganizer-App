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

- (void)updateChore:(Chore *)chore newTitle:(NSString *)newTitle andNewText:(NSString *)newText {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Chore" inManagedObjectContext:[Stack sharedInstance].managedObjectContext]];
    
    //Timestamp could be better? 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", chore.title];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [[Stack sharedInstance].managedObjectContext executeFetchRequest:request error:&error];
    
    Chore *toMutate = [results objectAtIndex:0];
    toMutate.title = newTitle;
    toMutate.detail = newText;
    
    [self synchronize];
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
