//
//  ChoreController.h
//  Choreganizer
//
//  Created by Ethan Hess on 6/5/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Day.h"
#import "Chore.h"

@interface ChoreController : NSObject

@property (nonatomic, strong, readonly) NSArray *chores;
@property (nonatomic, strong, readonly) NSArray *days; 

+ (ChoreController *)sharedInstance; 
- (void)addChoreWithTitle:(NSString *)title andDescription:(NSString *)detail toDay:(Day *)day;
- (void)addDayWithName:(NSString *)name;
- (void)removeChore:(Chore *)chore;

@end
