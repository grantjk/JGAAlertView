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
    id <UIAlertViewDelegate> _externalDelegate;
    NSMutableDictionary *_actionsPerIndex;
    
    struct
    {
        unsigned int delegateSupportsWillDismiss:1;
        unsigned int delegateSupportsDidDismiss:1;
        unsigned int delegateSupportsWillPresent:1;
        unsigned int delegateSupportsDidPresent:1;
        unsigned int delegateSupportsAlertViewCancel:1;
        unsigned int delegateSupportsShouldEnableFirstOtherButton:1;
        unsigned int delegateSupportsClickedButtonAtIndex:1;
    }_delegateFlags;
}

- (id)init
{
    self = [super init];
    if (self) {
        _actionsPerIndex = [[NSMutableDictionary alloc] init];
        self.delegate = self;
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

#pragma mark - UIAlertViewDelegate (forwarded)
- (void)alertViewCancel:(UIAlertView *)alertView
{
    if (_delegateFlags.delegateSupportsAlertViewCancel) {
        [_externalDelegate alertViewCancel:alertView];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_delegateFlags.delegateSupportsClickedButtonAtIndex) {
        [_externalDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSNumber *key = [NSNumber numberWithInt:buttonIndex];
    JGAAlertViewBlock block = [_actionsPerIndex objectForKey:key];
    if (block) {
        block();
    }
    
    if (_delegateFlags.delegateSupportsDidDismiss) {
        [_externalDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_delegateFlags.delegateSupportsWillDismiss) {
        [_externalDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
    }
}
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if (_delegateFlags.delegateSupportsWillPresent) {
        [_externalDelegate willPresentAlertView:alertView];
    }
}
- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (_delegateFlags.delegateSupportsDidPresent) {
        [_externalDelegate didPresentAlertView:alertView];
    }
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (_delegateFlags.delegateSupportsShouldEnableFirstOtherButton) {
        return [_externalDelegate alertViewShouldEnableFirstOtherButton:alertView];
    }
    return YES;
}

#pragma mark - Properties
- (id <UIAlertViewDelegate>)delegate
{
    return _externalDelegate;
}
- (void)setDelegate:(id <UIAlertViewDelegate>)delegate
{
    if (delegate == self) {
        [super setDelegate:self];
    }
    else if (delegate == nil) {
        [super setDelegate:nil];
        _externalDelegate = nil;
    }else {
        _externalDelegate = delegate;
    }
    
    // wipe
    memset(&_delegateFlags, 0, sizeof(_delegateFlags));
    
    // set flags according to available methods in delegate
    if ([_externalDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        _delegateFlags.delegateSupportsClickedButtonAtIndex = YES;
    }
    if ([_externalDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex::)]) {
        _delegateFlags.delegateSupportsWillDismiss= YES;
    }
    if ([_externalDelegate respondsToSelector:@selector(willPresentAlertView:)]) {
        _delegateFlags.delegateSupportsWillPresent = YES;
    }
    if ([_externalDelegate respondsToSelector:@selector(didPresentAlertView:)]) {
        _delegateFlags.delegateSupportsDidPresent = YES;
    }
    if ([_externalDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        _delegateFlags.delegateSupportsDidDismiss = YES;
    }
    if ([_externalDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]) {
        _delegateFlags.delegateSupportsShouldEnableFirstOtherButton = YES;
    }
    if ([_externalDelegate respondsToSelector:@selector(alertViewCancel:)]) {
        _delegateFlags.delegateSupportsAlertViewCancel = YES;
    }
    
}
@end
