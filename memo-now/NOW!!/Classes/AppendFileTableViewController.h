//
//  AppendFileTableViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppendFileTableViewController : UITableViewController {

	NSManagedObjectContext *managedObjectContext;	
	NSMutableArray *memoArray;
	UITableView	*tableView;
	UISearchBar *searchBar;
}

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSMutableArray *memoArray;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar; 

- (void) fetchMemoRecords; 
@end
