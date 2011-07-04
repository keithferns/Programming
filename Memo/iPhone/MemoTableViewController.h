//
//  MemoTableViewController.h
//  Memo
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memo.h"
#import "MemoText.h"


@interface MemoTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextViewDelegate> {

	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
	UITableView *tableView;
	
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;



@end
