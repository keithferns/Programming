//
//  RootViewController.h
//  Memo
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MemoTableViewController.h"
#import "MemoText.h"


@interface RootViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {

	NSManagedObjectContext *managedObjectContext;
	UITextView *newText;
    NSString *previousTextInput;
    //MemoTableViewController *tableViewController;
    UIActionSheet *goActionSheet, *saveActionSheet;
    UIToolbar *toolbar;
    MemoText *newMemoText;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) MemoText *newMemoText;
@property (nonatomic, retain) IBOutlet UITextView *newText;
@property (nonatomic, retain) NSString *previousTextInput;
@property (nonatomic, retain) UIActionSheet *goActionSheet, *saveActionSheet;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) MemoTableViewController *tableViewController;

- (void) addNewMemoText;
- (void) addNewMemo;
- (void) addNewAppointment;
- (void) addNewTask;

- (void) makeToolbar;
- (IBAction) navigationAction:(id)sender;

@end

/*
*/