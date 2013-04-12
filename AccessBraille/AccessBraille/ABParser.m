//
//  ABParser.m
//  AccessBraille
//
//  Created by Michael Timbrook on 4/12/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "ABParser.h"

@implementation ABParser

/**
 * Parses a sentance into an array
 */
+ (NSArray *)arrayOfWordsFromSentance:(NSString *)sentance {
    // Checks to see if the string is empty
    if ([sentance isEqualToString:@""]){
        return false;
    }
    // regex to check for punctuation
    NSRegularExpression *punct = [[NSRegularExpression alloc] initWithPattern:@"[.,:;]" options:NSRegularExpressionSearch error:nil];
    
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    NSString *nextWord = @"";
    // Cycles through sentance to check each character for spaces or punctuation
    for(int index = 0; index <=[sentance length] - 1; index++){
        if ([sentance characterAtIndex:index] == ' '){
            [chars addObject:nextWord];
            nextWord = @"";
        } else {
            NSString *nextChar = [NSString stringWithFormat:@"%c", [sentance characterAtIndex:index]];
            NSArray *match = [punct matchesInString:nextChar options:NSMatchingCompleted range:NSMakeRange(0, nextChar.length)];
            if (match.count > 0) {
                continue;
            }
            nextWord = [nextWord stringByAppendingString:nextChar];
        }
    }
    [chars addObject:nextWord];
    nextWord = @"";
    return chars;
}

@end
