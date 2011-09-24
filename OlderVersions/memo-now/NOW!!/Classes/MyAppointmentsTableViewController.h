//
//  MyAppointmentsTableViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyAppointmentsTableViewController : UITableViewController {

	UITableView	*tableView;
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *myArray;
	
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *myArray;


@end

