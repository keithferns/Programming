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


@interface WriteNowViewController : UIViewController <UITextViewDelegate, TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource, PopoverControllerDelegate> {
    
}

@property (nonatomic,retain) UIView *topView, *bottomView;
@property (nonatomic, retain) CustomTextView *textView;
@property (nonatomic, retain) TKCalendarMonthView *calendarView;
@property (nonatomic, retain) CustomToolBar *toolbar;
@property (nonatomic, retain) UIButton *leftNavButton, *rightNavButton;
@property (nonatomic, retain) WEPopoverController *actionsPopover;

- (void) saveMemo:(id) sender;
- (void)saveToFolderOrFile:(id)sender;
- (void) addNewEvent:(id)sender;
- (void) sendItem:(id)sender;

@end
