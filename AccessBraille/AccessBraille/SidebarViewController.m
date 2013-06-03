//
//  SidebarViewController.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/23/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "SidebarViewController.h"
#import "MainMenuItemImage.h"
#import "UIView+quickRemove.h"
#import "NavigationContainer.h"

// Size formating for menu
#define LEFTMARGIN 5
#define SIZE 85
#define START 340

@interface SidebarViewController ()

@end

@implementation SidebarViewController {
    SystemSoundID openNavSound;
    NSDictionary *menuItemsDict;
    
    __strong UITapGestureRecognizer *tapToClose;
    __strong UIView *tapAreaToClose;
}

@synthesize menuOpen = _menuOpen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGRect frame = self.view.frame;
        frame.origin.x = -100;
        [self.view setFrame:frame];
        [self.view setBackgroundColor:[UIColor blueColor]];
        // Set image as background
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"slideOutMenu.png"] drawInRect:CGRectMake(0, 0, 100, [UIScreen mainScreen].bounds.size.height)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        
        [self setMenuOpen:NO];
        openNavSound = [self createSoundID:@"navClick.aiff"];
        
        // Create TapToClose
        
        tapAreaToClose = [[UIView alloc] initWithFrame:CGRectMake(100, 0, [UIScreen mainScreen].bounds.size.height - 100, [UIScreen mainScreen].bounds.size.width)];
        [tapAreaToClose setBackgroundColor:[UIColor grayColor]];
        [tapAreaToClose setAlpha:0.3];
        [tapAreaToClose setUserInteractionEnabled:YES]; 
        
        tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToClose:)];
        [tapToClose setNumberOfTapsRequired:1];
        [tapToClose setNumberOfTouchesRequired:1];
        [tapToClose setEnabled:YES];
        [tapAreaToClose addGestureRecognizer:tapToClose];
        
    }
    return self;
}

- (void)tapToClose:(UITapGestureRecognizer *)reg {
    [self setMenuOpen:NO];
}

- (void)loadMenuItemsAnimated:(BOOL)animated {
    
    // Load menu info
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"menu.plist"];
    menuItemsDict = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:menuItemsDict.count];
    int startTag = 0;
    
    for (NSString *link in menuItemsDict) {
        
        MainMenuItemImage *menuItem = [[MainMenuItemImage alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"menuItem%dx90.png", startTag]]];
        [menuItem setUserInteractionEnabled:YES];
        [menuItem setFrame:CGRectMake(animated ? -100 : LEFTMARGIN, START + (startTag * (SIZE + 5)), SIZE, SIZE)];
        [menuItem setTag:startTag];
        
        // Add to subview and array
        [self.view addSubview:menuItem];
        menuItems[startTag] = menuItem;
        
        // Attach gestures
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedMenuItem:)];
        tap.cancelsTouchesInView = NO;
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [menuItem addGestureRecognizer:tap];
        
        startTag++;
    }
    
    if (animated) {
        for (UIView *item in menuItems) {
            [UIView animateWithDuration:.2 animations:^{
                CGRect newFrame = item.frame;
                newFrame.origin.x = LEFTMARGIN;
                [item setFrame:newFrame];
            }];
        }
    }
    
}

/**
 * Controls how far the side menu is open
 */
- (void)updateMenuPosition:(float)position {
    if (position <= 100) {
        [self.view setFrame:CGRectMake(position-100, 0, 100, [UIScreen mainScreen].bounds.size.height)];
        [self.view setNeedsDisplay];
    } else {
        if (!_menuOpen) {
            [self setMenuOpen:YES];
        }
    }
}

- (void)setMenuOpen:(BOOL)menuOpen {
    if (menuOpen) {
        [self.view setNeedsDisplay];
        [self loadMenuItemsAnimated:YES];
        [self.view addSubview:tapAreaToClose];
        [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.height)];
        AudioServicesPlaySystemSound(openNavSound);
    } else {
        [UIView animateWithDuration:.3 animations:^{
            [self.view setFrame:CGRectMake(-100, 0, 100, [UIScreen mainScreen].bounds.size.height)];
            [self.view setNeedsDisplay];
            [self.view removeSubviews];
        }];
    }
    _menuOpen = menuOpen;
}

- (void)tappedMenuItem:(UITapGestureRecognizer *)reg {
    NSString *value = menuItemsDict[[NSString stringWithFormat:@"%d", reg.view.tag]];    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    NSLog(@"Switching to %@", value);
    @try {
        [((NavigationContainer *)self.parentViewController) switchToController:[storyboard instantiateViewControllerWithIdentifier:value] animated:YES withMenu:[value isEqualToString:@"menu"] ? NO : YES];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception description]);
    }
        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SystemSoundID) createSoundID: (NSString*)name
{
    NSString *path = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] resourcePath], name];
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    return soundID;
}

@end
