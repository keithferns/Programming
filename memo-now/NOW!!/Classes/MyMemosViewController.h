//
//  MyMemosViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMemosViewController : UIViewController {
	
	UISegmentedControl *segmentedControl;
	UITableViewController *tableViewController;
	UIView *bottomView, *topView; 
	UILabel *myTestLabel;
	UITextView *viewSelectedMemo;
	BOOL isSearching;

}

@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UIView *bottomView, *topView;
@property (nonatomic,retain) IBOutlet UILabel *myTestLabel;
@property (nonatomic, retain) IBOutlet UITextView *viewSelectedMemo;


- (IBAction)segmentedControlAction:(id)sender;



@end





