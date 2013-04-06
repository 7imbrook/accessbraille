//
//  ABKeyboard.h
//  AccessBraille
//
//  Created by Michael Timbrook on 3/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ABActivateKeyboardGestureRecognizer.h"

@protocol ABKeyboard <NSObject>

@optional

/* Presents the last typed character with typing info */
-(void)characterTyped:(NSString *)character withInfo:(NSDictionary *)info;

/* Presents the last typed word with typing info */
-(void)wordTyped:(NSString *)word withInfo:(NSDictionary *)info;

/* Presents the last typed sentance with typing info */
-(void)senctanceCompleted:(NSString *)sentance withInfo:(NSDictionary *)info;

/* Option to recieve status logs from keyboard */
- (void)ABLog:(NSString *)log;

@end

@interface ABKeyboard : UIView <ABGestureRecognizerDelegate>

/* Delegate */
@property (strong, nonatomic) id<ABKeyboard> delegate;

/* Access the Gesture */
@property (strong, nonatomic) ABActivateKeyboardGestureRecognizer *keyboardGesture;

/* Is the keyboard active */
@property BOOL keyboardActive;

/* Init methods to set up the Keyboard Controller */
- (id)initWithDelegate:(id<ABKeyboard>)delegate;

@end