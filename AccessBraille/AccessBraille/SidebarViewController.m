//
//  SidebarViewController.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/23/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "SidebarViewController.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController {
    SystemSoundID openNavSound;
}

@synthesize menuOpen = _menuOpen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setFrame:CGRectMake(-100, 0, 100, [UIScreen mainScreen].bounds.size.height)];
        [self.view setBackgroundColor:[UIColor blueColor]];
        // Set image as background
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"slideOutMenu.png"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        
        [self setMenuOpen:NO];
        openNavSound = [self createSoundID:@"navClick.aiff"];
    }
    return self;
}

- (NSArray *)loadMenuItems {
    
    
    return nil;
}


- (void)updateMenuPosition:(float)position {
    if (position <= 100) {
        [self.view setFrame:CGRectMake(position-100, 0, 100, [UIScreen mainScreen].bounds.size.height)];
        [self.view setNeedsDisplay];
    } else {
        if (!_menuOpen) {
            [self setMenuOpen:YES];
            AudioServicesPlaySystemSound(openNavSound);
        }
    }
}

- (void)setMenuOpen:(BOOL)menuOpen {
    if (menuOpen) {
        [self.view setFrame:CGRectMake(0, 0, 100, [UIScreen mainScreen].bounds.size.height)];
        [self.view setNeedsDisplay];
    } else {
        [UIView animateWithDuration:.3 animations:^{
            [self.view setFrame:CGRectMake(-100, 0, 100, [UIScreen mainScreen].bounds.size.height)];
            [self.view setNeedsDisplay];
        }];
    }
    _menuOpen = menuOpen;
}

- (void)tapToClose:(UITapGestureRecognizer *)reg {
    if ([reg locationInView:self.view].x > 100) {
        [self setMenuOpen:NO];
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