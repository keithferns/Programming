//
//  SaveFileViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>

@interface SaveFileViewController : UIViewController <UITextFieldDelegate, UISearchBarDelegate> {

	UITextField *getFileName, *getFolderName, *getTag;	
	UIView *bottomView, *topView; 
	UISearchBar *searchBar;
	UITableViewController *tableViewController;
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *folderArray;
}

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSMutableArray *folderArray;

@property (nonatomic, retain) IBOutlet UIView *bottomView, *topView;
@property (nonatomic, retain) IBOutlet UITextField *getFileName, *getFolderName, *getTag;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property(nonatomic, retain) IBOutlet UITableViewController *tableViewController;


- (IBAction) navigationAction:(id)sender;
-(void) fetchFolderRecords;


@end
