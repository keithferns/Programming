//
//  AppointmentsViewController.h
//  Memo
//
//  Created by Keith Fernandes on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Appointment.h"
#import "MemoText.h"


@interface AppointmentsViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate> {
    
    NSManagedObjectContext *managedObjectContext;
    BOOL swappingViews;
	//UIDatePicker *datePicker;
    UIActionSheet *goActionSheet;
    //UITextView *textView;
    UIToolbar *appointmentsToolbar;
    //UITextField *timeTextField, *dateTextField;   
    NSString *newTextInput;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) UIActionSheet *goActionSheet;
@property (nonatomic, retain) UIToolbar *appointmentsToolbar;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *dateTextField, *timeTextField;
@property (nonatomic, retain) NSString *newTextInput;
@property (nonatomic, retain) NSDate *selectedDate;
- (void) swapViews;

- (void) backAction;

- (void) setAppointmentDate;

- (void) makeToolbar;


@end
