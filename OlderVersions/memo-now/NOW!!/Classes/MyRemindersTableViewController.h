//
//  MyRemindersTableViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyRemindersTableViewController : UITableViewController {
	UITableView	*tableView;
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *myArray;
	
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *myArray;

@end
