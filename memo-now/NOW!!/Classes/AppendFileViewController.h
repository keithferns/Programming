
//  AppendFileViewController.h
//  NOW!!
//  Created by Keith Fernandes on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>


@interface AppendFileViewController : UIViewController {
	UITableViewController *myfilesTableViewController;	
	UITableView *myfiles;
}


@property (nonatomic, retain) IBOutlet UITableView *myfiles;

@property (nonatomic, retain) IBOutlet UITableViewController *myfilesTableViewController;

-(IBAction) navigationAction:(id)sender;



@end
