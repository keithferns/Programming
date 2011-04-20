//
//  MyMemosTableViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Memo.h"


@interface MyMemosTableViewController : UITableViewController {

	NSManagedObjectContext *managedObjectContext;	
	NSMutableArray *memoArray;
	UITableView *myMemos;
	UITableViewCell *cell;

}

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSMutableArray *memoArray;
@property(nonatomic, retain) IBOutlet UITableView *myMemos;
@property(nonatomic, retain) IBOutlet UITableViewCell *cell;



-(void) fetchMemoRecords; 


@end
