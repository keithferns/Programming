//
//  MyFoldersTableViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Folder.h"

@interface MyFoldersTableViewController : UITableViewController {
	
	NSManagedObjectContext *managedObjectContext;	
	NSMutableArray *folderArray;
	UITableView	*tableView;
	UISearchBar *searchBar;
}

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSMutableArray *folderArray;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar; 

- (void) fetchFolderRecords; 


@end
