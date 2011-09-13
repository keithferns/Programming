//
//  CurrentViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolBarMainView.h"


@interface CurrentViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate> {
    
    NSManagedObjectContext *managedObjectContext;
    UITableViewController *tableViewController;
    UITextView *textView;
    BOOL swappingViews;

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UITableViewController *tableViewController;
@property (nonatomic, retain) Note  *newNote;
@property (nonatomic, retain) NSString *previousTextInput;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) CustomToolBarMainView *toolBar;
@property (nonatomic, retain) UIView *bottomView;

- (void) createNewNote;
- (void) swapViews;
- (void) dismissKeyboard;
- (void) saveMemo;
- (void) addNewAppointment;
- (void) addNewTask;
- (void) addNewFolder;
- (void) addEntity:(id)sender;
- (void) makeActionSheet:(id) sender;
- (void) animateViews:(UIView *)view startFrom:(CGRect)fromFrame endAt:(CGRect)toFrame;


@end
