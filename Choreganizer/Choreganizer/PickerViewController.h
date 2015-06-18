//
//  PickerViewController.h
//  Choreganizer
//
//  Created by Ethan Hess on 6/18/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chore.h"
#import "Day.h"

@interface PickerViewController : UIViewController

- (void)updateWithChore:(Chore *)chore andDay:(Day *)day;

@end
