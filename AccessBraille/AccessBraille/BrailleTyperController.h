//
//  ViewController.h
//  AccessBraille
//
//  Created by Michael on 12/5/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drawing.h"
#import "TextOut.h"
#import <CoreData/CoreData.h>
#import <Slt/Slt.h>
#import <Kal/Kal.h>
#import <OpenEars/FliteController.h>

@interface BrailleTyperController : UIViewController <NSFetchedResultsControllerDelegate> {
    
    // Voice Over
    FliteController *fliteController;
    Slt *slt;
    Kal *kal;
}

-(void)saveState;

@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;
@property (strong, nonatomic) Kal *kal;

@property (strong, nonatomic) IBOutlet Drawing *DrawingView;
@property (weak, nonatomic) IBOutlet UILabel *typingStateOutlet;
@property (weak, nonatomic) IBOutlet UILabel *textOutput;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet TextOut *TextDrawing;
@end
