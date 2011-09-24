//  NewTaskViewController.h
//  Memo
//  Created by Keith Fernandes on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import "ToDo.h"
#import "MemoText.h"


@interface NewTaskViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate> {
    
    NSManagedObjectContext *managedObjectContext;
    MemoText *newMemoText;
    ToDo *newTask;
    NSString *taskDate;
    BOOL swappingViews;
	UIDatePicker *datePicker, *timePicker;
    UIActionSheet *goActionSheet;
    UITextView *textView;
    UIToolbar *taskToolbar;
    UITextField *timeTextField, *dateTextField;   
    NSString *newTextInput;
    //UIView *monthView, *datetimeView;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) MemoText *newMemoText;
@property (nonatomic, retain) ToDo *newTask;

@property (nonatomic, retain) NSString *taskDate;
@property (nonatomic, retain) UIDatePicker *datePicker, *timePicker;
@property (nonatomic, retain) UIActionSheet *goActionSheet;
@property (nonatomic, retain) UIToolbar *taskToolbar;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *dateTextField, *timeTextField;
@property (nonatomic, retain) NSString *newTextInput;

//@property (nonatomic, retain) IBOutlet UIView *monthView, *datetimeView;

- (void) swapViews;
- (void) backAction;
- (void) setTaskDate;
- (void) makeToolbar;

//- (IBAction)monthAction:(id)sender;

@end
