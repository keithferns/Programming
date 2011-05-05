//
//  MyAppointmentsViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyAppointmentsViewController : UIViewController {
	
	UITableViewController *tableViewController;
	UISegmentedControl *segmentedControl;
	UIView *bottomView, *topView; 
	UILabel *label;
	UITextView *textView;
}


@property (nonatomic,retain) IBOutlet UITableViewController *tableViewController;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UIView *bottomView, *topView;
@property (nonatomic,retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextView *textView;

@end
