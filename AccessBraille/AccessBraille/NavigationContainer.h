//
//  NavigationContainer.h
//  AccessBraille
//
//  Created by Michael on 1/16/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationContainer : UIViewController

- (void)switchToController:(UIViewController*)controller animated:(BOOL)animated withMenu:(BOOL)menu;
- (void)tapToShowMenu:(id)sender;

@end
