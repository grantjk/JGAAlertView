//
//  JGAAlertView.m
//  HMS
//
//  Created by John Grant on 12-07-25.
//  Copyright (c) 2012 Healthcare Made Simple. All rights reserved.
//

#import "JGAAlertView.h"

@interface JGAAlertView () <UIAlertViewDelegate>

@end

@implementation JGAAlertView
{
    NSMutableDictionary *_actionsPerIndex;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _actionsPerIndex = [[NSMutableDictionary alloc] init];
        [super setDelegate:self];
    }

    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message
{
    return [self initWithTitle:title message:message defaultCancelButton:YES];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultCancelButton:(BOOL)cancelButton
{
    self = [self init];
    if (self) {
        self.title = title;
        self.message = message;

        if (cancelButton) {
            [self addCancelButtonWithTitle:@"Cancel"];
        }
    }
    return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title block:(JGAAlertViewBlock)block
{
    NSInteger retIndex = [self addButtonWithTitle:title];
    if (block) {
        NSNumber *key = [NSNumber numberWithInt:retIndex];
        [_actionsPerIndex setObject:[block copy] forKey:key];
    }
    return retIndex;
}

- (NSInteger)addCancelButtonWithTitle:(NSString *)title
{
    NSInteger retIndex = [self addButtonWithTitle:title];
    [self setCancelButtonIndex:retIndex];
    return retIndex;
}

- (NSInteger)addCancelButtonWithTitle:(NSString *)title block:(JGAAlertViewBlock)block
{
    NSInteger retIndex = [self addButtonWithTitle:title];
    if (block) {
        NSNumber *key = [NSNumber numberWithInt:retIndex];
        [_actionsPerIndex setObject:[block copy] forKey:key];
    }
    [self setCancelButtonIndex:retIndex];
    return retIndex;
}

#pragma mark - UIAlertViewDelegate (forwarded)
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSNumber *key = [NSNumber numberWithInt:buttonIndex];
    JGAAlertViewBlock block = [_actionsPerIndex objectForKey:key];
    if (block) {
        block();
    }
}

@end
