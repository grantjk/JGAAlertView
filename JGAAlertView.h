//
//  JGAAlertView.h
//  HMS
//
//  Created by John Grant on 12-07-25.
//  Copyright (c) 2012 Healthcare Made Simple. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void (^JGAAlertViewBlock)(void);

@interface JGAAlertView : UIAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
          defaultCancelButton:(BOOL)cancelButton;

- (NSInteger)addButtonWithTitle:(NSString *)title block:(JGAAlertViewBlock)block;
- (NSInteger)addCancelButtonWithTitle:(NSString *)title;
- (NSInteger)addCancelButtonWithTitle:(NSString *)title block:(JGAAlertViewBlock)block;

@end
