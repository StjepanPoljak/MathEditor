//
//  MCMathKeyboardRootView.h
//  MathChat
//
//  Created by MARIO ANDHIKA on 7/16/15.
//  Copyright (c) 2015 MathChat, Inc.
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MTKeyboard.h"
#import "MTEditableMathLabel.h"

@interface MTMathKeyboardRootView : UIView<MTMathKeyboard, MTKeyboardDelegate>

- (IBAction)switchTabs:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *numbersTab;
@property (weak, nonatomic) IBOutlet UIButton *lettersTab;
@property (weak, nonatomic) IBOutlet UIButton *functionsTab;
@property (weak, nonatomic) IBOutlet UIButton *operationsTab;

- (void) switchToDefaultTab;

- (void) setPadding: (CGFloat)x y:(CGFloat)y;
- (void) setMargins: (CGFloat)x y:(CGFloat)y;

+ (MTMathKeyboardRootView *)sharedInstance;

/// The keyboard resources bundle.
+ (NSBundle *)getMathKeyboardResourcesBundle;

#pragma mark - MTMathKeyboardTraits

@property (nonatomic) BOOL equalsAllowed;
@property (nonatomic) BOOL fractionsAllowed;
@property (nonatomic) BOOL variablesAllowed;
@property (nonatomic) BOOL numbersAllowed;
@property (nonatomic) BOOL operatorsAllowed;
@property (nonatomic) BOOL exponentHighlighted;
@property (nonatomic) BOOL squareRootHighlighted;
@property (nonatomic) BOOL radicalHighlighted;

- (void) setBackgroundColors: (UIColor *)background;
- (void) setBorderColors: (UIColor *)border;
- (void) setSpecialBackgroundColors: (UIColor *)background;
- (void) setEnterBackgroundColor: (UIColor *)background;

- (void) selectRAD;
- (void) selectDEG;

@end
