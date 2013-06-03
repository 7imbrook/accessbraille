//
//  TextOut.m
//  AccessBraille
//
//  Created by Michael on 1/28/13.
//  Edited by Piper on 3/7/13.
//  Copyright (c) 2013 RIT. All rights reserved.
//

#import "BrailleTyperOutputView.h"

@implementation BrailleTyperOutputView {
    UILabel *textOut;
    UILabel *wpm;
    NSMutableArray *wordList;
    bool loaded;
    
    // WPM count
    NSDate *start;
    UILongPressGestureRecognizer *clearText;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        loaded = NO;
        _buf = @"";
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    
    // Writing Area
    CGRect displayBox = CGRectMake(20,0,self.frame.size.width - 40,240);
    
    textOut = [[UILabel alloc] initWithFrame:CGRectMake(25, (displayBox.size.height / 2.5), self.frame.size.width, 50)];
    wpm = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 140, 10, 100, 50)];
    wordList = [[NSMutableArray alloc] init];
    
    textOut.backgroundColor = [UIColor clearColor];
    wpm.backgroundColor = [UIColor clearColor];
    
    textOut.font = [UIFont fontWithName:@"Helvetica" size:62];
    wpm.text = @"N/A WPM";

    // Adding Subviews
    [self addSubview:textOut];
    [self addSubview:wpm];
    
    [self setWordsToOutput:_buf];
    
    // Clear Text within Display Rectangle
    clearText = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clearText)];
    [clearText setNumberOfTouchesRequired:3];
    [self addGestureRecognizer:clearText];
    
    // Style 
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Colors
    UIColor *fillBox = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    UIColor *fillBoxShadow = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
    
    // Shadow
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 1.0, fillBoxShadow.CGColor);
    CGContextAddRect(context, displayBox);
    CGContextFillPath(context);
    
    // Box
    CGContextSetFillColorWithColor(context, fillBox.CGColor);
    CGContextAddRect(context, displayBox);
    CGContextFillPath(context);
}

/**
 * Accepts a string and converts it to an array.
 * 
 * Cycles through an array to check for '32' as a space, then
 * appends a string to the space as the next word.
 *
 * Returns the array of characters, or the next word.
 */
- (NSMutableArray *)stringToArray:(NSString *)newString {
    
    // Checks to see if the string is empty
    if ([newString isEqualToString:@""]){
        return false;
    }
    
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    NSString *nextWord = @"";
    
    // Cycles through newString to check each character for spaces
    for(int index = 0; index <=[newString length] - 1; index++){
        if ([newString characterAtIndex:index] == 32){
            [chars addObject:nextWord];
            nextWord = @"";
        } else {
            nextWord = [nextWord stringByAppendingString:[NSString stringWithFormat:@"%c", [newString characterAtIndex:index]]];
        }
    }
    
    [chars addObject:nextWord];
    return chars;
}

/**
 * Prepares words to be drawn in Typing Mode
 */
- (void)setWordsToOutput:(NSString *)buf {
    [wordList removeAllObjects];
    if ([self stringToArray:buf]) {
        [wordList addObjectsFromArray:[self stringToArray:buf]];
    }
    [self rewrite];
}

- (void)appendToText:(NSString *)string {
    if ([string isEqualToString:@" "]) {
        NSString *tmp = [textOut.text stringByAppendingString:string];
        [textOut setText:tmp];
        [wordList removeAllObjects];
        [wordList addObjectsFromArray:[self stringToArray:tmp]];
    } else {
        NSString *tmp = [textOut.text stringByAppendingString:string];
        [textOut setText:tmp];
    }
}

-(NSString *)parseLastWordfromString:(NSString *)string {
    const char *charArray = [string UTF8String];
    int charLength = (int)[string length];
    NSString *word = @"";
    int offset = charArray[charLength - 1] == 32 ? 2 : 1;
    for (int i = charLength - offset; i >= 0; i--) {
        if (charArray[i] == 32){
            break;
        }
        word = [NSString stringWithFormat:@"%c%@",charArray[i],word];
    }
    const char *trim = [word UTF8String];
    NSString *returned = @"";
    for (int i = 0; i < [word length]; i++){
        returned = [NSString stringWithFormat:@"%@%c",returned, trim[i]];
    }
    return returned;
}

-(void)typingDidStart {
    start = [[NSDate alloc] init];
}

-(void)typingDidEnd {
    [self updateWordsPerMinute];
    [wordList removeAllObjects];
    [wordList addObjectsFromArray:[self stringToArray:textOut.text]];
    [self rewrite];
}

/**
 * Removes objects identical to an empty string.
 */
- (void)rewrite {
    [wordList removeObjectIdenticalTo:@""];
    textOut.text = @" ";
    for(NSString *word in wordList){
        textOut.text = [textOut.text stringByAppendingString:word];
        textOut.text = [textOut.text stringByAppendingString:@" "];
    }
}

/**
 * Method that divides the number of words in the mutable array.
 */
-(void) updateWordsPerMinute {
    float wpmf = (([wordList count]/([_end timeIntervalSinceDate:start])) * 60.0);
    wpm.text = [NSString stringWithFormat:@"%d WPM",(int)wpmf];
    
}

/**
 * Returns textOut.text.
 */
- (NSString *)getCurrentText{
    return textOut.text;
}


/**
 * Clears text and removes all objects from the WordList array. 
 */
-(void)clearText{
    [textOut setText:@""];
    [wordList removeAllObjects];
    [self rewrite];
}

-(void)removeCharacter{
    if ( textOut.text.length > 0)
        textOut.text = [textOut.text substringToIndex: textOut.text.length - 1];
}

@end