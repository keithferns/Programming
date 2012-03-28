//
//  CalendarViewController.h
//  iDoit
//
//  Created by Keith Fernandes on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "WEPopoverController.h"
#import "NewItemOrEvent.h"
#import "ScheduleView.h"
#import "CustomToolBar.h"
#import "TKCalendarMonthViewController.h"
#import "CalendarTableViewController.h"


@interface CalendarViewController : UIViewController <PopoverControllerDelegate,UITextFieldDelegate,TKCalendarMonthViewDataSource, TKCalendarMonthViewDelegate>{
    NewItemOrEvent *theItem;
    NSManagedObjectContext *managedObjectContext;
    BOOL isSaving;
    
}
@property (nonatomic, retain)CustomToolBar *toolbar;
@property (nonatomic, retain) UIView *topView, *bottomView;
@property (nonatomic, retain) WEPopoverController *actionsPopover;
@property (nonatomic, retain) NewItemOrEvent *theItem;
@property (nonatomic, readwrite) BOOL isScheduling;
@property (nonatomic, retain) ScheduleView *scheduleView;
@property (nonatomic,retain) UIButton *flipIndicatorButton;
@property (assign) BOOL frontViewIsVisible;
@property (nonatomic, retain) TKCalendarMonthView *calendarView;
@property (nonatomic, retain) CalendarTableViewController *tableViewController;
@property (readonly) UIImage *flipperImageForDateNavigationItem;
@property (readonly) UIImage *listImageForFlipperView;
@property (nonatomic, retain) UIView *flipperView;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (UIView *) addItemsView: (CGRect) frame;
- (void) flipScheduleView:(id) sender;

- (UIView *)organizerView: (CGRect)frame;
- (void) presentActionsPopover:(id) sender;



@end
