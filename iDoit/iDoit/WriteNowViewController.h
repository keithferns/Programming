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
#import "ScheduleView.h"
#import "ArchiveView.h"


@interface WriteNowViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource, PopoverControllerDelegate> {    
}

@property (nonatomic,retain) UIView *topView, *bottomView;
@property (nonatomic, retain) ScheduleView *scheduleView;
@property (nonatomic, retain) CustomTextView *textView;
@property (nonatomic, retain) TKCalendarMonthView *calendarView;
@property (nonatomic, retain) CustomToolBar *toolbar;
@property (nonatomic, retain) WEPopoverController *actionsPopover;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) ArchiveView *archiveView;

- (void) startNewItem:(id) sender;
- (void) saveMemo:(id) sender;
- (void) editTextView:(id) sender;
- (void) saveToFolderOrFile:(id)sender;
- (void) addNewEvent:(id)sender;
- (void) sendItem:(id)sender;
- (void) toggleTextAndScheduleView:(id) sender;

- (void) dismissKeyboard;

@end
