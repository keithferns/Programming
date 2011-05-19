
//  AppendFileViewController.h
//  NOW!!
//  Created by Keith Fernandes on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>


@interface AppendFileViewController : UIViewController <UISearchBarDelegate> {
	UITableViewController *tableViewController;	
	UIView *bottomView, *topView; 
	UISearchBar *searchBar;
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *memoArray;
}



@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSMutableArray *memoArray;

@property (nonatomic, retain) IBOutlet UIView *bottomView, *topView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;


- (IBAction) navigationAction:(id)sender;
-(void) fetchMemoRecords;


@end
