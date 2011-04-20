
//  AppendFileViewController.h
//  NOW!!
//  Created by Keith Fernandes on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>


@interface AppendFileViewController : UIViewController {
	UISegmentedControl *segmentedControl;
	UITableViewController *myfilesTableViewController;	
	UITableView *myfiles;
}


@property (nonatomic, retain) IBOutlet UITableView *myfiles;

@property (nonatomic, retain) IBOutlet UITableViewController *myfilesTableViewController;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentedControlAction:(id)sender;



@end
