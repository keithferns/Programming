//  FoldersFilesViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "FoldersFilesViewController.h"
#import "FoldersTableViewController.h"
#import "FilesTableViewController.h"
#import "WriteNowAppDelegate.h"

#import "CustomTextView.h"
#import "CustomTextField.h"
#import "CustomToolBar.h"
#import "MyDataObject.h"

@implementation FoldersFilesViewController

@synthesize tableViewController, managedObjectContext;

@synthesize sender, theText;
@synthesize textView, nameField;
@synthesize toolBar, saveNewFolderButton;
@synthesize navPopover;
@synthesize flipIndicatorButton, flipperView;
@synthesize frontViewIsVisible;

#define screenRect [[UIScreen mainScreen] applicationFrame]
#define statusBarRect [[UIApplication sharedApplication] statusBarFrame];
#define tabBarHeight self.tabBarController.tabBar.frame.size.height
#define navBarHeight self.navigationController.navigationBar.frame.size.height
#define toolBarRect CGRectMake(screenRect.size.width, 0, screenRect.size.width, 40)
#define textViewRect CGRectMake(5, navBarHeight+10, screenRect.size.width-10, 140)
#define bottomViewRect CGRectMake(0, textViewRect.origin.y+textViewRect.size.height+10, screenRect.size.width, screenRect.size.height-textViewRect.origin.y-textViewRect.size.height-10)
#define mainFrame CGRectMake(screenRect.origin.x, self.navigationController.navigationBar.frame.origin.y+navBarHeight, screenRect.size.width, screenRect.size.height-navBarHeight)

- (MyDataObject *) myDataObject {
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	MyDataObject* myDataObject;
	myDataObject = (MyDataObject*) theDelegate.myDataObject;
	return myDataObject;
}


//FIXME: Add ability to change/edit the name of a folder. 
- (void)makeFolderFile:(id)sender {
	NSLog(@"Folder/File-> Button Pressed");
    
    if(!navPopover) {
        //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 120, 30)];
        //[label setTextAlignment:UITextAlignmentCenter];
        //[label setBackgroundColor:[UIColor clearColor]];
        //[label setTextColor:[UIColor whiteColor]];
        //[label setText:@"Create"];
        
        nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
        [nameField setEnabled:YES];
        [nameField setBorderStyle:UITextBorderStyleRoundedRect];
        [nameField setTextAlignment:UITextAlignmentCenter];
        [nameField setPlaceholder:@" Name"];
        [nameField setInputAccessoryView:toolBar];        
        [nameField setFont:[UIFont systemFontOfSize:16.0]];
        [nameField setTag:0];
        [nameField setDelegate:self];
        [nameField setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
        
        UIButton *folderButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 60, 50, 50)];
        
        [folderButton setBackgroundImage:[UIImage imageNamed:@"folder_button"] forState:UIControlStateNormal];
        [folderButton setTag:1];
        [folderButton addTarget:self action:@selector(makeFolder) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *fileButton = [[UIButton alloc] initWithFrame:CGRectMake(folderButton.frame.origin.x+folderButton.frame.size.width+40, folderButton.frame.origin.y, 50, 50)];
        
        [fileButton setBackgroundImage:[UIImage imageNamed:@"files_button"] forState:UIControlStateNormal];
        [fileButton setTag:1];
        [fileButton addTarget:self action:@selector(makeFile) forControlEvents:UIControlEventTouchUpInside];
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        viewCon.contentSizeForViewInPopover = CGSizeMake(200, textViewRect.size.height-10);
        [viewCon.view addSubview:fileButton];
        [viewCon.view addSubview:folderButton];
        [viewCon.view addSubview:nameField];
        [nameField becomeFirstResponder];

        //[viewCon.view addSubview:label];
        
        [folderButton release];
        [fileButton release];
        //[label release];
        navPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [navPopover setDelegate:self];
        [viewCon release];
    } 
    
    if([navPopover isPopoverVisible]) {
        [navPopover dismissPopoverAnimated:YES];
        [navPopover setDelegate:nil];
        [navPopover autorelease];
        navPopover = nil;
    } else {
        //CGRect screenBounds = [UIScreen mainScreen].bounds;
        [navPopover presentPopoverFromRect:CGRectMake(10, 0, 50, tabBarHeight-7)
                                    inView:self.view 
                  permittedArrowDirections:UIPopoverArrowDirectionUp
                                  animated:YES name:@"Archive"];
    }
}


- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Did dismiss");
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Should dismiss");
    return YES;
}


-(id)init {
	[super init];
	//----- SETUP TAB BAR -----
	UITabBarItem *tabBarItem = [self tabBarItem];
	[tabBarItem setTitle:@"Archive"];									
	UIImage *archiveImage = [UIImage imageNamed:@"storage_24.png"];	
	[tabBarItem setImage:archiveImage];
    
	return self;
}

- (void)dealloc{
    [super dealloc];
    [sender release];
    [theText release];
    [nameField release];
    [tableViewController release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning at MyFoldersFilesViewController");
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];    

    [self.view setFrame:[[UIScreen mainScreen] applicationFrame]];

    if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After MOC in Folders: %@",  managedObjectContext);
	}
 
    /*-- VIEWS:BASE: setup and initialize --*/
    //[self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    UIImage *background = [UIImage imageNamed:@"wallpaper.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:background]];
    
  }

- (void) viewWillAppear:(BOOL)animated{
    /*-NOTIFICATIONS: --*/    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchkeyboardWasShown) name:@"StartedSearching_Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchkeyboardWasHidden) name:@"EndedSearching_Notification" object:nil];
    
    //Observe notifications sent by the TableView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedFolderOrFile:) name:UITableViewSelectionDidChangeNotification   object:nil];

    /*--NAVIGATION ITEMS --*/
        //Set Navigation Bar Visible
    if (self.navigationController.navigationBarHidden == YES){
        self.navigationController.navigationBarHidden = NO;
    }
        //Initialize the TOOLBAR
    toolBar = [[CustomToolBar alloc] initWithFrame:CGRectMake(0, 195, 320, 40)];
    [toolBar.firstButton setTarget:self];
    [toolBar.firstButton setAction:@selector(makeActionSheet:)];
    
    [toolBar.secondButton setImage:[UIImage imageNamed:@"folder_24.png"]];
    [toolBar.secondButton setTitle:@"Store"];
    [toolBar.secondButton setTarget:self];
    [toolBar.secondButton setAction:@selector(saveMemo)];
    
    [toolBar.thirdButton setImage:[UIImage imageNamed:@"save.png"]];
    [toolBar.thirdButton setTitle:@"Save"];//NOTE: flip with new note button
    [toolBar.thirdButton setTarget:self];
    [toolBar.thirdButton setAction:@selector(addEntity:)];
    
    [toolBar.fourthButton setImage:[UIImage imageNamed:@"save_document.png"]];
    [toolBar.fourthButton setTitle:@"Append"];
    [toolBar.fourthButton setTarget:self];
    [toolBar.fourthButton setAction:@selector(addEntity:)];
    
    [toolBar.dismissKeyboard setTarget:self];
    [toolBar.dismissKeyboard setAction:@selector(dismissKeyboard)];
    
    /*-ADD FLIPPER VIEW -*/
    flipperView = [[UIView alloc] initWithFrame:mainFrame];
    [flipperView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view   addSubview:flipperView];
    
    MyDataObject *myData = [self myDataObject]; //Create instance of Shared Data Object (SDO)- autoreleases.
    if (tableViewController == nil){
        if ([myData.saveType intValue] == 2) {//TODO: Add code here relevant to appending to a File
        NSLog(@"Appending to File"); 
        self.title = @"Append to File";
            tableViewController = [[FilesTableViewController alloc] init];
        }
        else if ([myData.saveType intValue] == 1){//TODO: Add code here relevant to saving to Folders.
            NSLog(@"Saving to Folder");
            self.title = @"Save to Folder";
            tableViewController = [[FoldersTableViewController alloc]init];
        }
        else {//when tab is selected, folderFiles table view. TODO: TABLEVIEW with folder sections and contents in rows.
            self.title = @"Folders";
            tableViewController = [[FoldersTableViewController alloc] init];
        }
    }
    if (tableViewController.tableView.superview == nil) {
        tableViewController.tableView.frame = CGRectMake(0, mainFrame.size.height, mainFrame.size.width, mainFrame.size.height);
        [self.flipperView addSubview:tableViewController.tableView];
        [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
        tableViewController.tableView.rowHeight = 30.0;
        //[tableViewController.tableView setTableHeaderView:tableLabel];
    }

    if ([myData.isEditing intValue] == 1 && textView == nil){
        //TEXTVIEW: setup and add to self.view
        textView = [[CustomTextView alloc] initWithFrame:CGRectMake(screenRect.origin.x, textViewRect.origin.y, textViewRect.size.width, textViewRect.size.height)];
        textView.delegate = self;    
        textView.inputAccessoryView = toolBar;
        [self.view addSubview:textView];
        [textView setText:myData.myText];
        [textView setUserInteractionEnabled:YES];
        [textView becomeFirstResponder];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    if (textView.superview == nil && textView != nil) {
        textView.frame = textViewRect;
        // tableViewController.tableView.frame = bottomViewRect;
    }else{
        tableViewController.tableView.frame = CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height);
    }
    
    UIImage *menuLeftButtonImage = [UIImage imageNamed:@"add_item_white_on_blue_button.png"];
    UIButton *menuLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuLeftButton setImage:menuLeftButtonImage forState:UIControlStateNormal];
    menuLeftButton.frame = CGRectMake(0, 0, menuLeftButtonImage.size.width, menuLeftButtonImage.size.height);
    UIBarButtonItem *menuLeftBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuLeftButton];
    self.navigationItem.leftBarButtonItem = menuLeftBarButton;
    [menuLeftBarButton release];
    [menuLeftButton addTarget:self action:@selector(makeFolderFile:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *menuRightButtonImage = [UIImage imageNamed:@"file_white_on_blue_button.png"];
	UIButton *localFlipIndicator=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, menuRightButtonImage.size.width, menuRightButtonImage.size.height)];
    self.flipIndicatorButton=localFlipIndicator;
	[localFlipIndicator release];
    [flipIndicatorButton setBackgroundImage:menuRightButtonImage forState:UIControlStateNormal];	
	UIBarButtonItem *flipButtonBarItem;
	flipButtonBarItem=[[UIBarButtonItem alloc] initWithCustomView:flipIndicatorButton];	
	[self.navigationItem setRightBarButtonItem:flipButtonBarItem animated:YES];
	[flipButtonBarItem release];
	[flipIndicatorButton addTarget:self action:@selector(toggleFolderFileView:) forControlEvents:(UIControlEventTouchDown)];
    [UIView commitAnimations];  
    frontViewIsVisible = YES;
    
    NSLog(@"Subviews of the Folders main View are, %@",[self.view subviews]);

}

- (void) viewWillDisappear:(BOOL)animated{
    self.title = @"Archive";
    /*-NOTIFICATIONS: --*/
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StartedSearching_Notification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EndedSearching_Notification" object:nil];
    
    //Observe notifications sent by the TableView
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FolderSelectedInTableViewControllerNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FileSelectedInTableViewControllerNotification" object:nil];
    [tableViewController.tableView removeFromSuperview];
    [tableViewController release];
    tableViewController = nil;
    
}

- (void)toggleFolderFileView:(id)sender {
    // disable user interaction during the flip
    flipperView.userInteractionEnabled = NO;
	flipIndicatorButton.userInteractionEnabled = NO;
    
    // setup the animation group
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];
	
	// swap the views and transition
    if (frontViewIsVisible==YES) {
        self.title = @"Add To File";

        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipperView cache:YES];
        [tableViewController.tableView removeFromSuperview];
        tableViewController = nil;

        tableViewController = [[FilesTableViewController alloc]init];

        tableViewController.tableView.frame = CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height);
        [self.flipperView addSubview:tableViewController.tableView];        
    } else {
        self.title = @"Save To Folder";

        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:flipperView cache:YES];
        [tableViewController.tableView removeFromSuperview];
        tableViewController = nil;
        tableViewController = [[FoldersTableViewController alloc]init];
        tableViewController.tableView.frame = CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height);
        [self.flipperView addSubview:tableViewController.tableView];
    }
	[UIView commitAnimations];
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];
    
	if (frontViewIsVisible==YES) {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:flipIndicatorButton cache:YES];
		[flipIndicatorButton setBackgroundImage:[UIImage imageNamed:@"folder_white_on_blue_button.png"] forState:UIControlStateNormal];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"HasToggledToFoldersViewNotification" object:nil];
        //[self makeFolder];
        //[tableViewController.tableView reloadData];
	} 
	else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipIndicatorButton cache:YES];
        [flipIndicatorButton setBackgroundImage:[UIImage imageNamed:@"file_white_on_blue_button.png"] forState:UIControlStateNormal];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"HasToggledToFilesViewNotification" object:nil];
        //[self makeFile];
        //[tableViewController.tableView reloadData];
	}
	[UIView commitAnimations];
	frontViewIsVisible=!frontViewIsVisible;
}

- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	// re-enable user interaction when the flip is completed.
    flipperView.userInteractionEnabled = YES;
	flipIndicatorButton.userInteractionEnabled = YES;
}


#pragma -
#pragma Navigation Controls and Actions


- (void) textViewDidEndEditing:(UITextView *)textView{
    [self.textView resignFirstResponder];
}

- (void) dismissKeyboard{
    [self.textView resignFirstResponder];
    [self.nameField resignFirstResponder];
}


#pragma mark RESPONDING TO NOTIFICATIONS

- (void) getSelectedFolderOrFile:(NSNotification *)notification{
    if ([[notification object] isKindOfClass:[Folder class]]){
        Folder *selectedFolder = [notification object];
        NSLog(@"Selected Folder Name is %@", selectedFolder.name);
        if (![textView hasText]) {
        FoldersTableViewController *detailViewController = [[FoldersTableViewController alloc] init];
        detailViewController.tableView.rowHeight = 30;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        }
        else{
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Memo"
                                       inManagedObjectContext:managedObjectContext];
        
        Memo *newMemo = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newMemo setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newMemo setCreationDate:[NSDate date]];
        [newMemo setType:0];
        [newMemo setEditDate:[NSDate date]];
        newMemo.folder = selectedFolder;
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"FolderViewController MOC: DID NOT SAVE");
        }

        NSLog(@"NEW MEMO is saved in %@", newMemo.folder.name);
        [newMemo release];
        }
        return;
    }
    
    else if ([[notification object] isKindOfClass:[File class]]){
        File *selectedFile = [notification object];
        NSLog(@"Selected File Name is %@", selectedFile.name);
  
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Memo"
                                       inManagedObjectContext:managedObjectContext];
        
        Memo *newMemo = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newMemo setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newMemo setCreationDate:[NSDate date]];
        [newMemo setType:0];
        [newMemo setEditDate:[NSDate date]];
        newMemo.file = selectedFile;
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"FolderViewController MOC: DID NOT SAVE");
        }
        
        NSLog(@"NEW MEMO is saved in %@", newMemo.file.name);
        [newMemo release];
        return;
    }
}
- (void)searchkeyboardWasShown{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)searchkeyboardWasHidden{
    [self.navigationController.navigationBar setHidden:NO];

}


- (void) makeFolder{
    NSLog(@"CREATING A NEW FOLDER");
    if (nameField.text == nil) {
        return;
    }
    //else if (!isSelected){ 
    //FIXME: check to see if a folder with the specified name exists, if yes, put up an alert view 
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Folder"
                                   inManagedObjectContext:managedObjectContext];
    Folder *newFolder = [[Folder alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext]; 
    
    newFolder.name = nameField.text;
    /*--Save the MOC--*/	
    NSError *error;
    if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
    }
    nameField.text = @"";
    [nameField resignFirstResponder];
   // if (!swappingViews) {
   //     [self swapViews];
   // }
    [navPopover dismissPopoverAnimated:YES];
    [newFolder release];
}
- (void) makeFile{
    NSLog(@"CREATING A NEW FILE");
    if (nameField.text == nil) {
        return;
    }
    //else if (!isSelected){ 
    //FIXME: check to see if a folder with the specified name exists, if yes, put up an alert view 
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"File"
                                   inManagedObjectContext:managedObjectContext];
    File *newFile = [[File alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext]; 
    
    newFile.name = nameField.text;
  
    /*--Save the MOC--*/	
    NSError *error;
    if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
    }
    nameField.text = @"";
    [nameField resignFirstResponder];
    // if (!swappingViews) {
    //     [self swapViews];
    // }
    [navPopover dismissPopoverAnimated:YES];
    [newFile release];
}

@end

/*  NOTE: THESE CONTROL ELEMENTS MOVED TO THE POPOVER VIEW
 //TEXTFIELDS
 textField = [[CustomTextField alloc] initWithFrame:CGRectMake(135, textView.frame.origin.y+textView.frame.size.height+10, 180, 30)];
 [textField setBorderStyle:UITextBorderStyleRoundedRect];
 [textField setFont:[UIFont systemFontOfSize:16.0]];
 [textField setTag:0];
 [textField setDelegate:self];
 [textField setTextAlignment:UITextAlignmentCenter];
 textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
 [self.view addSubview:textField];
 [textField setPlaceholder:@"Create a new Folder"];
 textField.inputAccessoryView = toolBar;
 
 //BUTTON
 saveNewFolderButton = [UIButton buttonWithType:UIButtonTypeCustom];
 [saveNewFolderButton setBackgroundImage:[UIImage imageNamed:@"bluebutton.png"] forState:UIControlStateNormal];
 [saveNewFolderButton setFrame:CGRectMake(5, textField.frame.origin.y, 120, 32)];
 saveNewFolderButton.titleLabel.font = [UIFont systemFontOfSize:14];
 [saveNewFolderButton.layer setCornerRadius:20.0];
 [saveNewFolderButton setTitle:@"Save To Folder" forState:UIControlStateNormal];
 [saveNewFolderButton addTarget:self action:@selector(makeFolder) forControlEvents:UIControlEventTouchUpInside];
 [self.view  addSubview:saveNewFolderButton];
 */  



/*
 NSArray *segControlI = [NSArray arrayWithObjects:[UIImage imageNamed:@"addFolder_nav.png"], [UIImage imageNamed:@"addDoc_nav.png"], nil];
 UISegmentedControl *lButton = [[UISegmentedControl alloc] initWithItems:segControlI];
 lButton.segmentedControlStyle = UISegmentedControlStyleBordered;
 [lButton setTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
 [lButton setWidth:40.0 forSegmentAtIndex:0];
 [lButton setWidth:40.0 forSegmentAtIndex:1];
 lButton.momentary = NO;
 
 UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:lButton];
 self.navigationItem.leftBarButtonItem = left;
 
 
 segControlI = [NSArray arrayWithObjects:[UIImage imageNamed:@"viewFolders_nav.png"], [UIImage imageNamed:@"classic_folder_documents.png"], nil];
 UISegmentedControl *rButton = [[UISegmentedControl alloc] initWithItems:segControlI];
 rButton.segmentedControlStyle = UISegmentedControlStylePlain;
 [rButton setTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
 [rButton setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
 [rButton setWidth:40.0 forSegmentAtIndex:0];
 [rButton setWidth:40.0 forSegmentAtIndex:1];
 rButton.momentary = NO;
 
 UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rButton];
 self.navigationItem.rightBarButtonItem = right;    
 
 [lButton addTarget:self 
 action:@selector(addFolderFile:) 
 forControlEvents:UIControlEventValueChanged];
 
 [rightButton addTarget:self 
 action:@selector(changeView:) 
 forControlEvents:UIControlEventValueChanged];
 */
