//
//  MyAppointmentsViewController.h
//  Memo
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoText.h"
#import "Appointment.h"

@interface MyAppointmentsViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate, UITextViewDelegate> {

	UITableViewController *tableViewController;
    MemoText *selectedMemoText;
    UITextView *textView;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;
@property (nonatomic, retain) UIActionSheet *goActionSheet, *saveActionSheet;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UITextField *dateTextField; 

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) MemoText *selectedMemoText;

- (void) makeToolbar;

- (IBAction) navigationAction:(id)sender;

@end

/*
*/