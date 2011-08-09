//
//  AddTaskViewController.h
//  miMemo
//
//  Created by Keith Fernandes on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDo.h"
#import "MemoText.h"



@interface AddTaskViewController : UIViewController  <UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    
    NSManagedObjectContext *managedObjectContext, *managedObjectContextTV;
    NSString *taskDate;
    BOOL swappingViews;
	//UIDatePicker *datePicker;
    UIToolbar *taskToolbar;
    NSString *newTextInput;
    NSMutableArray *memoArray;
    //NSFetchedResultsController *_fetchedResultsController;
    UITableView *tableView;
    
    //UIView *monthView, *datetimeView;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext, *managedObjectContextTV;
@property (nonatomic, retain) MemoText *newMemoText;
@property (nonatomic, retain) ToDo *newTask;
@property (nonatomic, retain) UILabel *tableLabel;
@property (nonatomic, retain) NSString *taskDate;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) UIActionSheet *goActionSheet;
@property (nonatomic, retain) UIToolbar *taskToolbar;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *dateTextField, *timeTextField;
@property (nonatomic, retain) NSString *newTextInput;
@property (nonatomic, retain) NSMutableArray *memoArray;
@property (nonatomic, retain) NSDate *selectedDate;

//@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;


//@property (nonatomic, retain) IBOutlet UIView *monthView, *datetimeView;
- (IBAction)datePickerChanged:(id)sender;

- (void) swapViews;
- (void) backAction;
- (void) setTaskDate;
- (void) makeToolbar;
- (void) fetchSelectedTasks;

//- (IBAction)monthAction:(id)sender;

@end
