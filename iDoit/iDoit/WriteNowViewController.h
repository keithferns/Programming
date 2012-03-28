//
//  WriteNowViewController.h
//  iDoit
//
//  Created by Keith Fernandes on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextView.h"
#import "CustomToolBar.h"
#import "TKCalendarMonthView.h"
#import "WEPopoverController.h"
#import "NewItemOrEvent.h"



@interface WriteNowViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource, PopoverControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate> {    
    BOOL isScrolling;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UITableViewController *tableViewController;
@property (nonatomic,retain) UIView *topView, *bottomView, *cover;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) TKCalendarMonthView *calendarView;
@property (nonatomic, retain) CustomToolBar *toolbar;
@property (nonatomic, retain) WEPopoverController *actionsPopover;

@property (nonatomic, retain) UITapGestureRecognizer *doubleTapOnTextView, *singleTapOnTextView;
@property (nonatomic, retain) NewItemOrEvent *theItem;

- (void) startNewItem:(id) sender;
- (void) saveItem;
- (void) editTextView:(id) sender;
- (void) sendItem:(id)sender;
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer;

- (void) dismissKeyboard;

@end
