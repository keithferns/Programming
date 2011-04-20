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
		//UITableView *memoTable;
		//UIView *mymemoView;

}

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@property(nonatomic, retain) NSMutableArray *memoArray;

	//@property(nonatomic, retain) IBOutlet UIView *mymemoView;
	//@property(nonatomic, retain) IBOutlet UITableView *memoTable;

-(void) fetchMemoRecords; 


@end
