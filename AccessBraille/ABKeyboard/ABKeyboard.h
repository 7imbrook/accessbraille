//
//  ABKeyboard.h
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABActivateKeyboardGestureRecognizer.h"

@protocol ABKeyboard <NSObject>

@optional

/* Presents the last typed character with typing info */
- (void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info;

/* Presents the last typed word with typing info */
- (void)wordTyped:(NSString *)word withInfo:(NSDictionary *)info;

/* keyboard active/deactive calls */
- (void)keyboardDidBecomeActive;
- (void)keyboardDidDismiss;

@end

@interface ABKeyboard : UIView <ABGestureRecognizerDelegate>

@property (strong, nonatomic) UITextView *output;

/* Delegate */
@property (strong, nonatomic) UIViewController<ABKeyboard> *delegate;

/* Access the Gesture */
@property (strong, nonatomic) ABActivateKeyboardGestureRecognizer *keyboardGesture;

/* Is the keyboard active */
@property BOOL keyboardActive;

/* Sets the keyboard active state */
@property BOOL enabled;

/* Set sounds enabled */
@property BOOL sound;

/* Set keyboard grade */
@property (assign) ABGrade grade;

/* Keyboard state properites */
@property (nonatomic) int spaceOffset;

/* Init methods to set up the Keyboard Controller */
- (id)initWithDelegate:(id<ABKeyboard>)delegate;

/* Basic Speaking Method */
// TODO part of ABSpeak rework to singlton instance, use new contructor format
- (void)startSpeakingString:(NSString *)string;

@end
