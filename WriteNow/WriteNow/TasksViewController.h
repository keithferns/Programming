//
//  TasksViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TasksTableViewController.h"    
@interface TasksViewController : UIViewController  <UITextViewDelegate, UITextFieldDelegate> {
        
        Task *newTask;
        NSManagedObjectContext *managedObjectContext;
        BOOL swappingViews;
    }
    
    @property (nonatomic, retain) Task *newTask;
    @property (nonatomic, retain) NSDate *selectedDate;

    @property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
    @property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;


    @property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
    @property (nonatomic, retain) UIToolbar *taskToolbar;
    @property (nonatomic, retain) UITextView *textView;
    @property (nonatomic, retain) UITextField *dateField;
    @property (nonatomic, retain) NSDateFormatter *dateFormatter;
    @property (nonatomic, retain) UIView *containerView;
    @property (nonatomic, retain) NSString *newText;


    - (void) swapViews;
    - (void) setTaskDate;
    - (void) makeToolbar;

    - (IBAction)datePickerChanged:(id)sender;
    - (void) doneAction;

@end