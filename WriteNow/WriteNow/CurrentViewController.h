//
//  CurrentViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolBarMainView.h"
#import "CustomToolBar.h"


@interface CurrentViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    
    NSManagedObjectContext *managedObjectContext;
    UITableViewController *tableViewController;
    UITextView *textView;
    BOOL swappingViews, isSelected;

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UITableViewController *tableViewController;
@property (nonatomic, retain) Memo *newMemo;
@property (nonatomic, retain) NSString *previousTextInput;

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UILabel *leftLabel,*rightLabel, *rightLabel_1, *rightLabel_2;
@property (nonatomic, retain) CustomToolBarMainView *toolBar;
@property (nonatomic, retain) CustomToolBar *dateToolBar;
@property (nonatomic, retain) UIDatePicker *datePicker, *timePicker;
@property (nonatomic, retain) NSDateFormatter *dateFormatter, *timeFormatter;

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSArray *recurring;

@property (nonatomic, retain) UIView *midView, *bottomView;

- (void) swapViews;

- (void) setAppointmentDate;
- (void) setAppointmentTime;
- (void) doneAction;

- (void) addPickerResizeViews:(UIView *)picker1 removePicker:(UIView *)picker2;

- (void) dismissKeyboard;
- (void) saveMemo;
- (void) addNewAppointment;
- (void) addNewTask;
- (void) addNewFolder;
- (void) addEntity:(id)sender;
- (void) makeActionSheet:(id) sender;
- (void) selectFunction:(id)sender;
- (void) animateViews:(UIView *)view startFrom:(CGRect)fromFrame endAt:(CGRect)toFrame;


@end
