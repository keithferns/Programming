//
//  TasksViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
    
@interface TasksViewController : UIViewController  <UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
        
        Task *newTask;
        NSManagedObjectContext *managedObjectContext, *managedObjectContextTV;
        NSFetchedResultsController *_fetchedResultsController;
        UITableView *tableView;
        BOOL swappingViews;
    }
    
    @property (nonatomic, retain) Task *newTask;
    @property (nonatomic, retain) NSManagedObjectContext *managedObjectContext, *managedObjectContextTV;
    @property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
    @property (nonatomic, retain) UITableView *tableView;
    @property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
    @property (nonatomic, retain) UIToolbar *taskToolbar;
    @property (nonatomic, retain) UITextView *textView;
    @property (nonatomic, retain) UITextField *dateField;
    @property (nonatomic, retain) UILabel *tableLabel;
    @property (nonatomic, retain) NSDateFormatter *dateFormatter;
    @property (nonatomic, retain) UIView *containerView;

    - (void) swapViews;
    - (void) setTaskDate;
    - (void) makeToolbar;

    - (IBAction)datePickerChanged:(id)sender;
    - (void) doneAction;

    - (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 
@end