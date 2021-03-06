//
//  ABSpeak.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/19/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//


#import <Availability.h>
#import "ABSpeak.h"
#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVSpeechSynthesis.h>

__strong static ABSpeak *_sharedInstance;
static dispatch_once_t createInstance;

@implementation ABSpeak {
    __strong AVSpeechSynthesizer *speaker;
    dispatch_queue_t speaking;
}

@synthesize fliteController;
@synthesize slt;

+ (instancetype)sharedInstance
{
    dispatch_once(&createInstance, ^{
        _sharedInstance = [[ABSpeak alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        speaker = [AVSpeechSynthesizer new];
        speaking = dispatch_queue_create("edu.rit.abspeak", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)speakString:(NSString *)string {
    dispatch_sync(speaking, ^{
        if(NSClassFromString(@"AVSpeechSynthesizer")) {
            AVSpeechUtterance *currentUtterance = [AVSpeechUtterance speechUtteranceWithString:string];
            [speaker speakUtterance:currentUtterance];
        } else {
            if(NSClassFromString(@"Slt")) {
                [self.fliteController say:string withVoice:self.slt];
            } else {
                [NSException raise:@"Slt.framework not found" format:@""];
            }
        }
    });
}

- (void)stopSpeaking
{
    dispatch_sync(speaking, ^{
        if(NSClassFromString(@"AVSpeechSynthesizer")) {
            [speaker stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        } else {
            self.fliteController = nil;
            self.fliteController = [self fliteController];
        }
    });
}

- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

- (Slt *)slt {
	if (slt == nil) {
		slt = [[Slt alloc] init];
	}
	return slt;
}

@end
