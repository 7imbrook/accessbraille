//
//  ABTouchLayer.h
//  AccessBraille
//
//  Created by Michael Timbrook on 4/4/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTypes.h"
#import "ABTouchView.h"

@interface ABTouchLayer : UIView <ABTouchColumn>

- (void)resetView;

@end