//
//  AppointmentsTableViewController.h
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Appointment.h"
#import "MemoText.h"


@interface AppointmentsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextViewDelegate> {
	
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *_fetchedResultsController;
	UITableView *tableView;
	
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;


@end
