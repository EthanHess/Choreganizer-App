//
//  Day.h
//  Choreganizer
//
//  Created by Ethan Hess on 6/16/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Chore;

@interface Day : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *chores;
@end

@interface Day (CoreDataGeneratedAccessors)

- (void)insertObject:(Chore *)value inChoresAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChoresAtIndex:(NSUInteger)idx;
- (void)insertChores:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChoresAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChoresAtIndex:(NSUInteger)idx withObject:(Chore *)value;
- (void)replaceChoresAtIndexes:(NSIndexSet *)indexes withChores:(NSArray *)values;
- (void)addChoresObject:(Chore *)value;
- (void)removeChoresObject:(Chore *)value;
- (void)addChores:(NSOrderedSet *)values;
- (void)removeChores:(NSOrderedSet *)values;
@end
