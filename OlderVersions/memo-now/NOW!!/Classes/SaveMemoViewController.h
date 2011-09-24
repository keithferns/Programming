//
//  SaveMemoViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavButton.h"

@interface SaveMemoViewController : UIViewController {

		NavButton *backButton, *newButton, *wallButton;
		
		UIButton *saveToFolderButton, *appendToFileButton, *callCalenderButton, *callReminderButton, *makeFolderButton, *nameMemoButton, *nameListButton;
	
		
		//FIX:  reusing some of the buttons.  make separate classes for each. 

}

@property(nonatomic, retain) IBOutlet NavButton *backButton;
@property(nonatomic, retain) IBOutlet NavButton *newButton;
@property(nonatomic, retain) IBOutlet NavButton *wallButton;
@property(nonatomic, retain) IBOutlet UIButton *saveToFolderButton, *appendToFileButton, *callCalenderButton, *callReminderButton, *makeFolderButton, *nameListButton, *nameMemoButton;

	///////NAVIGATION ACTIONS

- (IBAction)gotowallAction:(id)sender;
- (IBAction)newmemoAction:(id)sender;
- (IBAction)backAction:(id)sender;
	
	///////NAMING AND ARCHIVING ACTIONS

	//On Done, this action will create a folder with the User given name and save the file to that folder.  
- (IBAction)makeNewFolderAction:(id)sender;
	//On TouchUP, this action will save the memo to an existing folder.
	//KF??? maybe conjoin the above two actions - have a alert window popup up with the query - save to new folder or save to existing folder - two paths from the same button. Which is less costly to the user? Probably less crowded and more efficient to have a single button path to the MyFolders page where there will be option to create NEW. On the other hand, it may be distracting to go to the MyFolder page. Maybe have option to type in name of folder, and autofill from existing folders list or override for new folder. Autoname the file to match the folder name with the date added to the name.   

- (IBAction)saveToFolderAction:(id)sender;
	/*	names file and saves to a folder or orphans. Can be conjoined with the Name Folder routine?? Maybe Berk will benifit from thinking about the folder heirarchy as rooms in a house. House=Complete DB -> Rooms = Folders at Domain Level (School, Work, Play, Home etc) --> Cabinets and drawers  Maybe the app can suggest an organizational schema or create one eventually based on content/keywords.
		IDEALLY: the app should do most of the organizing work behind the scenes. Create a schema, get user feedback and proceed. 
	*/
- (IBAction)nameFileAction:(id)sender;
	// saves file as a list. note same issues as pertain to the file and folder naming exist. 
- (IBAction)nameListAction:(id)sender;

/* 
 VERY IMPORTANT TO FIND THE MOST EFFICIENT and EFFECTIVE NAMING ROUTINE. Efficient in terms ofthe effort to name is minimal and the name itself is part of the organizational solution. Effective entails that the named entities are kept minimal or are sufficiently informative so as not to overload the user's memory. Would names like 
 "vacation@myhome@mylife" be more informative to the user after a few months than just a name like "vacation". TODO: research on naming and organizational efficiency. what do highly organized people do for naming. 
 */ 

	///////UTILITY ACTIONS. 

	//Adds memo txt to an existing file.  Should bring up an Alert window which queries whether the txt should be added to the beginning or the end of the file. Alert window should allow search function or go to Myfolders button. 
- (IBAction)appendToFileAction:(id)sender; 
	//Call up the calender to schedule an appointment
- (IBAction)callCalenderAction:(id)sender;
	//calls up the simplified scheduler for a todo memo. Do Today, Tomorrow, This Week
- (IBAction)callReminderAction:(id)sender;





   



@end
