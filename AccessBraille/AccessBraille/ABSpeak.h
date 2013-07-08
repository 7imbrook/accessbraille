//
//  ABSpeak.h
//  AccessBraille
//
//  Created by Michael Timbrook on 4/19/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

// TODO add documentation

@interface ABSpeak : NSObject {
    FliteController *fliteController;
    Slt *slt;
}

@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;

- (void)speakString:(NSString *)string;

@end
