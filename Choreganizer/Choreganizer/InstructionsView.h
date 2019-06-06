//
//  InstructionsView.h
//  Choreganizer
//
//  Created by Ethan Hess on 6/6/19.
//  Copyright © 2019 Ethan Hess. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InstructionsDelegate <NSObject>

@required
- (void)hideTapped;
@end

@interface InstructionsView : UIView

@property (nonatomic, weak) id <InstructionsDelegate> delegate;

- (void)expandedInit;

@end

NS_ASSUME_NONNULL_END
