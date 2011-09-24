//  MemoDetailViewController.h
//  Memo
//  Created by Keith Fernandes on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Memo.h"
#import "MemoText.h"
#import "Appointment.h"
#import "ToDo.h"

@interface MemoDetailViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate, UITextFieldDelegate> {
    
    UITextView *textView;
	NSManagedObjectContext *managedObjectContext;
	MemoText *selectedMemoText;
}

@property (nonatomic, retain) MemoText *selectedMemoText;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UITextField *dateTextField; 
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIActionSheet *goActionSheet, *saveActionSheet;
@property (nonatomic, retain) UIToolbar *toolbar;

- (void) saveSelectedMemo;
- (void) startNew;
- (void) makeToolbar;
- (IBAction) navigationAction:(id)sender;

@end
