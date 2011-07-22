//
//  RootViewController.h
//  Memo
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Memo.h"
#import "File.h"
#import "Appointment.h"
#import "MemoText.h"
#import "ToDo.h"

@interface RootViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {

	NSManagedObjectContext *managedObjectContext;
	UITextView *newText;
	UITableViewController *tableViewController;
    NSString *previousTextInput;
    UIActionSheet *goActionSheet, *saveActionSheet;
    UIToolbar *toolbar;
    MemoText *newMemoText;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) MemoText *newMemoText;
@property (nonatomic, retain) IBOutlet UITextView *newText;
@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;
@property (nonatomic, retain) NSString *previousTextInput;
@property (nonatomic, retain) UIActionSheet *goActionSheet, *saveActionSheet;
@property (nonatomic, retain) UIToolbar *toolbar;

- (void) addNewMemoText;
- (void) addNewMemo;
- (void) addNewAppointment;

- (void) makeToolbar;
- (IBAction) navigationAction:(id)sender;

@end

/*
*/