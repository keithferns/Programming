//
//  EnterTextViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EditTextView.h"
#import "NavButton.h"
#import "Memo.h"


@interface EnterTextViewController : UIViewController {
	UISegmentedControl *segmentedControl;

	NavButton *saveButton, *wallButton, *newButton;
	UITextView *editmemoTextView, *lastMemoView, *urgentMemoView; 
	UILabel *memoTitleLabel;
	UIView *topView, *bottomView;
		//UITableView *tableView;
	
	UIAlertView *saveAlert, *wallAlert;
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *memoArray;
	
}

/*.....Data ....*/
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSMutableArray *memoArray;
-(void) fetchMemoRecords;

-(void) addTimeStamp;
	
/*....Views and Navigation ....*/
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UIView *topView, *bottomView;
	//@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *memoTitleLabel; 
@property (nonatomic, retain) IBOutlet UITextView *editmemoTextView, *lastMemoView, *urgentMemoView; 
@property (nonatomic, retain) UIAlertView *saveAlert, *wallAlert;
	
-(IBAction) segmentedControlAction:(id)sender;


	///////NAMING AND ARCHIVING ACTIONS

/*XX The following action consolidated with other name and save actions. some of the design choices are discussed below. See also the file saveMemoViewController for more of the context and most of the text below. 
 
	- (IBAction)makeNewFolderAction:(id)sender;
		//On Done, this action will create a folder with the User given name and save the file to that folder.  
//NOTE:  maybe conjoin the above two actions - have a alert window popup up with the query - save to new folder or save to existing folder - two paths from the same button. Which is less costly to the user? Probably less crowded and more efficient to have a single button path to the MyFolders page where there will be option to create NEW. On the other hand, it may be distracting to go to the MyFolder page. Maybe have option to type in name of folder, and autofill from existing folders list or override for new folder. Autoname the file to match the folder name with the date added to the name.   

 - (IBAction)saveToFolderAction:(id)sender;
		//On TouchUP, this action will save the memo to an existing folder.
 //NOTE: Can be conjoined with the Name Folder routine?? Maybe Berk will benifit from thinking about the folder heirarchy as rooms in a house. House=Complete DB -> Rooms = Folders at Domain Level (School, Work, Play, Home etc) --> Cabinets and drawers  Maybe the app can suggest an organizational schema or create one eventually based on content/keywords.
 //NOTE: IDEALLY: the app should do most of the organizing work behind the scenes. Create a schema, get user feedback and proceed. 
 - (IBAction)nameListAction:(id)sender;
		// saves file as a list. note same issues as pertain to the file and folder naming exist. 

 */



	/*........UTILITY ACTIONS...... */
/*
- (IBAction)appendToFileAction:(id)sender; 
	//Adds memo txt to an existing file.  Should bring up an Alert window which queries whether the txt should be added to the beginning or the end of the file. Alert window should allow search function or go to Myfolders button. 
- (IBAction)callCalenderAction:(id)sender;
	//Call up the calender to schedule an appointment

- (IBAction)callReminderAction:(id)sender;
	//calls up the simplified scheduler for a todo memo. Do Today, Tomorrow, This Week

- (IBAction)nameFileAction:(id)sender;
	//names file and saves to a folder or orphans. 

/* 
 VERY IMPORTANT TO FIND THE MOST EFFICIENT and EFFECTIVE NAMING ROUTINE. Efficient in terms ofthe effort to name is minimal and the name itself is part of the organizational solution. Effective entails that the named entities are kept minimal or are sufficiently informative so as not to overload the user's memory. Would names like 
 "vacation@myhome@mylife" be more informative to the user after a few months than just a name like "vacation". TODO: research on naming and organizational efficiency. what do highly organized people do for naming. 
 */ 



@end


