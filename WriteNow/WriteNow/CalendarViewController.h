//  CalendarViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolBar.h"

@interface CalendarViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    
    UITableViewController *tableViewController;
    NSManagedObjectContext *managedObjectContext;
    
    UITextView *textView;
    NSString *sender, *newText;

    CustomToolBar *toolbar;
    BOOL swappingViews, isSelected;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UITableViewController *tableViewController;

@property (nonatomic, retain) NSString *sender, *newText;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *dateField, *startTimeField, *endTimeField, *recurringField;
@property (nonatomic, retain) UIDatePicker *datePicker, *timePicker;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) CustomToolBar *toolbar;
@property (nonatomic, retain) NSDate *selectedDate, *selectedTime;
@property (nonatomic, retain) NSDateFormatter *dateFormatter, *timeFormatter;
@property (nonatomic, retain) NSArray *recurring;

//- (void) swapViews;

- (void) backAction;    
- (void) dismissKeyboard;
- (void)datePickerChanged:(id)sender;
- (IBAction)timePickerChanged:(id)sender;
- (void) setAppointmentDate;
- (void) setAppointmentTime;
- (void) addPlan:(UIBarButtonItem *) barButtonItem;
- (void) changeView:(UIBarButtonItem *)barButtonItem;

@end


