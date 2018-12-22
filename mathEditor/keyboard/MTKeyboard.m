//
//  MCKeyboard.m
//
//  Created by Kostub Deshmukh on 8/21/13.
//  Copyright (C) 2013 MathChat
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTKeyboard.h"
#import "MTMathKeyboardRootView.h"
#import "MTFontManager.h"
#import "MTMathAtomFactory.h"

#import "MTEditableMathLabel.h"

@interface MTKeyboard ()

@property BOOL isLowerCase;

@end

@implementation MTKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Get the font Latin Modern Roman - Bold Italic included in
- (NSString*) registerAndGetFontName
{
    static NSString* fontName = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        
        NSBundle *bundle = [MTMathKeyboardRootView getMathKeyboardResourcesBundle];
        NSString* fontPath = [bundle pathForResource:@"lmroman10-bolditalic" ofType:@"otf"];
        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
        CGFontRef myFont = CGFontCreateWithDataProvider(fontDataProvider);
        CFRelease(fontDataProvider);

        fontName = (__bridge_transfer NSString*) CGFontCopyPostScriptName(myFont);
        CFErrorRef error = NULL;
        CTFontManagerRegisterGraphicsFont(myFont, &error);
        if (error) {
            NSString* errorDescription = (__bridge_transfer NSString*)CFErrorCopyDescription(error);
            NSLog(@"Error registering font: %@", errorDescription);
            CFRelease(error);
        }
        CGFontRelease(myFont);
        NSLog(@"Registered fontName: %@", fontName);
    });
    return fontName;
}

- (IBAction)switchButtonTapped:(UIButton *)sender {
    [self.rootView switchTapped];
}

- (IBAction)squareTapped:(UIButton *)sender {
    [self playClickForCustomKeyTap];
    [self.textView insertText:@"^"];
    [self.textView insertText:@"2"];
    [((MTEditableMathLabel *)self.textView) resetIndex];
}

- (IBAction)exponentialTapped:(UIButton *)sender {
    [self playClickForCustomKeyTap];
    [self.textView insertText:@"e"];
    [self.textView insertText:@"^"];
}

- (IBAction)radTapped:(UIButton *)sender {
}

- (IBAction)ansTapped:(UIButton *)sender {
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
//    NSString* fontName = [self registerAndGetFontName];
//    for (UIButton* varButton in self.variables) {
//        varButton.titleLabel.font = [UIFont fontWithName:fontName size:varButton.titleLabel.font.pointSize];
//    }

    for (UIButton *var in self.variables) {
        [var setTitle: var.currentTitle forState: UIControlStateReserved];
        [var setTitle: nil forState: UIControlStateNormal];
    }
    
    for (UIButton *number in self.numbers) {
        [number setTitle: number.currentTitle forState: UIControlStateReserved];
        [number setTitle: nil forState: UIControlStateNormal];
    }
    
    for (UIButton *operator in self.operators) {
        [operator setTitle: operator.currentTitle forState: UIControlStateReserved];
        [operator setTitle: nil forState: UIControlStateNormal];
    }
    
    for (UIButton *relation in self.relations) {
        [relation setTitle: relation.currentTitle forState: UIControlStateReserved];
        [relation setTitle: nil forState: UIControlStateNormal];
    }
    
    for (UIButton *each in self.other) {
        [each setTitle: each.currentTitle forState: UIControlStateReserved];
        [each setTitle: nil forState: UIControlStateNormal];
    }
    
    for (UIButton *operator in self.largeOperators) {
        [operator setTitle: operator.currentTitle forState: UIControlStateReserved];
        [operator setTitle: nil forState: UIControlStateNormal];
    }
    
    self.isLowerCase = true;
}


-(void) setBackgroundColors: (UIColor *)background {
    
    for (UIButton *number in self.numbers) {
        [number setBackgroundColor: background];
    }
    
    for (UIButton *operator in self.largeOperators) {
        [operator setBackgroundColor: background];
    }
    
    for (UIButton *each in self.other) {
        [each setBackgroundColor: background];
    }
    
    for (UIButton *relation in self.relations) {
        [relation setBackgroundColor: background];
    }
    
    for (UIButton *var in self.variables) {
        [var setBackgroundColor: background];
    }
    
    [_switchAdvancedButton setBackgroundColor: background];
    [_squareRootButton setBackgroundColor:background];
    [_radicalButton setBackgroundColor:background];

}

CGFloat borderWidth = 0.25;

- (void) setBorderColors: (UIColor *)border {
    for (UIButton *operator in self.operators) {
        [operator.layer setBorderColor:border.CGColor];
        [operator.layer setBorderWidth:borderWidth];
    }
    for (UIButton *operator in self.largeOperators) {
        [operator.layer setBorderColor:border.CGColor];
        [operator.layer setBorderWidth:borderWidth];
    }
    for (UIButton *number in self.numbers) {
        [number.layer setBorderColor:border.CGColor];
        [number.layer setBorderWidth:borderWidth];
    }
    for (UIButton *var in self.variables) {
        [var.layer setBorderColor:border.CGColor];
        [var.layer setBorderWidth:borderWidth];
    }
    for (UIButton *relation in self.relations) {
        [relation.layer setBorderColor:border.CGColor];
        [relation.layer setBorderWidth:borderWidth];
    }
    
    for (UIButton *each in self.other) {
        [each.layer setBorderColor:border.CGColor];
        [each.layer setBorderWidth:borderWidth];
    }
    
    [_switchButton.layer setBorderColor:border.CGColor];
    [_switchButton.layer setBorderWidth:borderWidth];
    [_switchAdvancedButton.layer setBorderColor:border.CGColor];
    [_switchAdvancedButton.layer setBorderWidth:borderWidth];
    [_enterButton.layer setBorderColor:border.CGColor];
    [_enterButton.layer setBorderWidth:borderWidth];
    [_squareRootButton.layer setBorderColor:border.CGColor];
    [_squareRootButton.layer setBorderWidth:borderWidth];
    [_radicalButton.layer setBorderColor:border.CGColor];
    [_radicalButton.layer setBorderWidth:borderWidth];
}

- (void) setSpecialBackgroundColors: (UIColor *)background {

    [_switchButton setBackgroundColor:background];
    for (UIButton *operator in self.operators) {
        [operator setBackgroundColor: background];
    }
}

-(void) setEnterBackgroundColor: (UIColor *)background {
    [self.enterButton setBackgroundColor:background];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)keyPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    
    UIButton *button = sender;
    NSString* str = [button titleForState: UIControlStateReserved];
    [self.textView insertText:str];
}

- (void)enterPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [self.textView insertText:@"\n"];
}

- (void)backspacePressed:(id)sender
{
    [self playClickForCustomKeyTap];

    [self.textView deleteBackward];
}

- (void)dismissPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [self.textView resignFirstResponder];
}

- (IBAction)absValuePressed:(id)sender
{
    [self.textView insertText:@"||"];
}

- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

- (void) playClickForCustomKeyTap
{
    [[UIDevice currentDevice] playInputClick];
}

- (void)fractionPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [self.textView insertText:MTSymbolFractionSlash];
}

- (IBAction)exponentPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [self.textView insertText:@"^"];
}

- (IBAction)subscriptPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [self.textView insertText:@"_"];
}

- (IBAction)parensPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [self.textView insertText:@"()"];
}

- (IBAction)squareRootPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [self.textView insertText:MTSymbolSquareRoot];
}

- (IBAction)rootWithPowerPressed:(id)sender {
    [self playClickForCustomKeyTap];
    [self.textView insertText:MTSymbolCubeRoot];
}

- (IBAction)logWithBasePressed:(id)sender {
    [self playClickForCustomKeyTap];
    [self.textView insertText:@"log"];
    [self.textView insertText:@"_"];
}

- (IBAction)shiftPressed:(id)sender
{
    // If currently uppercase, shift down
    // else, shift up
    if (_isLowerCase) {
        [self shiftUpKeyboard];
    } else {
        [self shiftDownKeyboard];
    }
}

#pragma mark - Keyboard Context


- (void) shiftDownKeyboard
{
    // Replace button titles to lowercase
    for (UIButton* button in self.letters) {
        NSString* newTitle = [button.titleLabel.text lowercaseString]; // get lowercase version of button title
        [button setTitle:newTitle forState:UIControlStateNormal];
    }
    
    // Replace greek letters
    [_alphaRho setTitle:@"α" forState:UIControlStateNormal];
    [_deltaOmega setTitle:@"Δ" forState:UIControlStateNormal];
    [_sigmaPhi setTitle:@"σ" forState:UIControlStateNormal];
    [_muNu setTitle:@"μ" forState:UIControlStateNormal];
    [_lambdaBeta setTitle:@"λ" forState:UIControlStateNormal];
    
    _isLowerCase = true;
}

- (void) shiftUpKeyboard
{
    // Replace button titles to uppercase
    for (UIButton* button in self.letters) {
        NSString* newTitle = [button.titleLabel.text uppercaseString]; // get uppercase version of button title
        [button setTitle:newTitle forState:UIControlStateNormal];
    }
    
    // Replace greek letters
    [_alphaRho setTitle:@"ρ" forState:UIControlStateNormal];
    [_deltaOmega setTitle:@"ω" forState:UIControlStateNormal];
    [_sigmaPhi setTitle:@"Φ" forState:UIControlStateNormal];
    [_muNu setTitle:@"ν" forState:UIControlStateNormal];
    [_lambdaBeta setTitle:@"β" forState:UIControlStateNormal];
    
    _isLowerCase = false;
}

- (void)setNumbersState:(BOOL)enabled
{
    for (UIButton* button in self.numbers) {
        button.enabled = enabled;
    }
}

- (void) setOperatorState:(BOOL)enabled
{
    for (UIButton* button in self.operators) {
        button.enabled = enabled;
    }
}

- (void)setVariablesState:(BOOL)enabled
{
    for (UIButton* button in self.variables) {
        button.enabled = enabled;
    }
}

- (void)setFractionState:(BOOL)enabled
{
    self.fractionButton.enabled = enabled;
}

- (void) setEqualsState:(BOOL)enabled
{
    self.equalsButton.enabled = enabled;
}

- (void) setExponentState:(BOOL) highlighted
{
    self.exponentButton.selected = highlighted;
}

- (void) setSquareRootState:(BOOL) highlighted
{
    self.squareRootButton.selected = highlighted;
}

- (void) setRadicalState:(BOOL) highlighted
{
    self.radicalButton.selected = highlighted;
}

#pragma mark -

// Prevent touches from being propagated to super view.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
