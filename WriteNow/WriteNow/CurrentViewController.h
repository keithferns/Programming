//
//  CurrentViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolBarMainView.h"
#import "WEPopoverController.h"


@interface CurrentViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, PopoverControllerDelegate> {
    
    NSManagedObjectContext *managedObjectContext;
    UITableViewController *tableViewController;
    UITextView *textView;
    BOOL swappingViews;
    WEPopoverController *navPopover;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UITableViewController *tableViewController;
@property (nonatomic, retain) Note  *newNote;
@property (nonatomic, retain) NSString *previousTextInput;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) CustomToolBarMainView *toolBar;
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, retain) WEPopoverController *navPopover;

- (void)popoverButtonPressed:(id)sender; 
- (void)saveTo:(id)sender;
- (void)schedule:(id)sender;
- (void)send:(id)sender;

- (void) createNewNote;
- (void) swapViews;
- (void) dismissKeyboard;
- (void) saveMemo;
- (void) addNewAppointment;
- (void) addNewTask;
- (void) saveToFolder;

- (void) saveToFile;
- (void) addEntity:(id)sender;
- (void) makeActionSheet:(id) sender;
- (void) animateViews:(UIView *)view startFrom:(CGRect)fromFrame endAt:(CGRect)toFrame;


@end
