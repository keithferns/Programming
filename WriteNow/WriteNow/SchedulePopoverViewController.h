//
//  SchedulePopoverViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@interface SchedulePopoverViewController : UIViewController {
    
    CustomTextField *dateField, *startTimeField, *endTimeField, *recurringField;
    UIButton *button1, *button2;
    UITableViewController *tableViewController;
    
    }
@property (nonatomic, retain) CustomTextField *dateField, *startTimeField, *endTimeField, *recurringField;
@property (nonatomic, retain) UIButton *button1, *button2;
@property (nonatomic, retain) UITableViewController *tableViewController;
@end

