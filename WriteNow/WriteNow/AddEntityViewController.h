//
//  AddEntityViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolBar.h"
#import "ContainerView.h"

@interface AddEntityViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
    
    UITableViewController *tableViewController;
    NSManagedObjectContext *managedObjectContext;
    
    BOOL swappingViews;
    
    UITextView *textView;
    
    NSString *sender, *newText;
}

@property (nonatomic, retain) UITableViewController *tableViewController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSString *sender, *newText;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *dateField, *startTimeField, *endTimeField, *recurringField;
@property (nonatomic, retain) CustomToolBar *toolbar;

@property (nonatomic, retain) NSDate *selectedDate, *selectedTime;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker, *timePicker;
@property (nonatomic, retain) NSDateFormatter *dateFormatter, *timeFormatter;
@property (nonatomic, retain) ContainerView *bottomView, *topView;


//- (void) swapViews;

- (void) backAction;    
- (void) dismissKeyboard;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)timePickerChanged:(id)sender;
- (void) setAppointmentDate;
- (void) setAppointmentTime;

@end
