//
//  Chore.h
//  Choreganizer
//
//  Created by Ethan Hess on 6/16/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day;

@interface Chore : NSManagedObject

@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Day *day;

@end
