//
//  MyFoldersTableViewController.h
//  miMemo
//
//  Created by Keith Fernandes on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "File.h"
#import "Folder.h"


@interface MyFoldersTableViewController : UITableViewController  <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *_fetchedResultsController;
	UITableView *tableView;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
