//
//  FoldersViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FoldersViewController.h"
#import "FoldersTableViewController.h"
#import "AppointmentsTableViewController.h"
#import "WriteNowAppDelegate.h"

#import "TasksViewController.h"
#import "AddEntityViewController.h"
#import "CustomTextView.h"
#import "CustomTextField.h"
#import "CustomToolBar.h"

#import "DiaryTableViewController.h"

@implementation FoldersViewController

@synthesize tableViewController, managedObjectContext;

@synthesize sender, newText;
@synthesize textView, textField;
@synthesize toolbar, saveNewFolderButton;

#pragma mark - View lifecycle

//FIXME: Add ability to change/edit the name of a folder. 


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
    [newText release];
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
    NSLog(@"Memory Warning at MyFoldersViewController");
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    swappingViews = NO;     
    isSelected = NO;
    

    [self.view setFrame:[[UIScreen mainScreen] applicationFrame]];

    if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After MOC in Folders: %@",  managedObjectContext);
	}
    
    /*-NOTIFICATIONS: --*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchkeyboardWasShown) name:@"StartedSearching_Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchkeyboardWasHidden) name:@"EndedSearching_Notification" object:nil];
    
    
    //Observe notifications sent by the TableView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedFolder:) name:@"FolderSelectedInTableViewControllerNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedFile:) name:@"FileSelectedInTableViewControllerNotification" object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchkeyboardWasShown)  name:UIKeyboardDidShowNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchkeyboardWasHidden)  name:UIKeyboardDidHideNotification object:nil];
    
    /*-- VIEWS:BASE: setup and initialize --*/
    [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    //previousTextInput = @"";    
    
    /*--NAVIGATION ITEMS --*/
    /*-Initialize the TOOLBAR-*/
    toolbar = [[CustomToolBar alloc] initWithFrame:CGRectMake(0, 195, 320, 40)];
    [toolbar.firstButton setTarget:self];
    [toolbar.firstButton setAction:@selector(makeActionSheet:)];
    
    [toolbar.secondButton setImage:[UIImage imageNamed:@"folder_24.png"]];
    [toolbar.secondButton setTitle:@"Store"];
    [toolbar.secondButton setTarget:self];
    [toolbar.secondButton setAction:@selector(saveMemo)];
    
    [toolbar.thirdButton setImage:[UIImage imageNamed:@"save.png"]];
    [toolbar.thirdButton setTitle:@"Save"];//NOTE: flip with new note button
    [toolbar.thirdButton setTarget:self];
    [toolbar.thirdButton setAction:@selector(addEntity:)];
    
    [toolbar.fourthButton setImage:[UIImage imageNamed:@"save_document.png"]];
    [toolbar.fourthButton setTitle:@"Append"];
    [toolbar.fourthButton setTarget:self];
    [toolbar.fourthButton setAction:@selector(addEntity:)];
    
    [toolbar.dismissKeyboard setTarget:self];
    [toolbar.dismissKeyboard setAction:@selector(dismissKeyboard)];
 
    
    UIBarButtonItem *newDoc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pages_nav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addFolderFile:)];
    self.navigationItem.leftBarButtonItem = newDoc;
    self.navigationItem.leftBarButtonItem.tag = 0;
    [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    
    
    /*--VIEWS:CONTROL VIEWS -*/    
    //TEXTVIEW
    
    textView = [[CustomTextView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, 320, 100)];
    textView.delegate = self;
    textView.inputAccessoryView = toolbar;
    [self.view addSubview:textView];

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
    textField.inputAccessoryView = toolbar;
    
    //BUTTON
    saveNewFolderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveNewFolderButton setBackgroundImage:[UIImage imageNamed:@"bluebutton.png"] forState:UIControlStateNormal];
    [saveNewFolderButton setFrame:CGRectMake(5, textField.frame.origin.y, 120, 32)];
    saveNewFolderButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveNewFolderButton.layer setCornerRadius:20.0];
    [saveNewFolderButton setTitle:@"Save To Folder" forState:UIControlStateNormal];
    [saveNewFolderButton addTarget:self action:@selector(makeFolder) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:saveNewFolderButton];
    
    
    //TABLEVIEWCONTROLLER
    tableViewController = [[FoldersTableViewController alloc] init];
    [tableViewController.tableView setFrame:CGRectMake(0, 205, 320, 204)];    
    //[tableViewController.tableView.layer setCornerRadius:10.0];
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    tableViewController.tableView.rowHeight = 30.0;
    //[tableViewController.tableView setTableHeaderView:tableLabel];
    [self.view addSubview:tableViewController.tableView];  
  }

- (void) viewWillAppear:(BOOL)animated{
    self.title = @"Folders";
}

- (void) viewWillDisappear:(BOOL)animated{
    self.title = @"Archive";
}

#pragma -
#pragma Navigation Controls and Actions


- (void) textViewDidEndEditing:(UITextView *)textView{
    [self.textView resignFirstResponder];
}

- (void) dismissKeyboard{
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
}

- (void) addFolderFile:(UIBarButtonItem *)barButtonItem {
    if (textField == nil) {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 155, 310, 30)];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        [textField setInputAccessoryView:toolbar];
        [textField setFont:[UIFont systemFontOfSize:13.0]];
        [textField setTag:0];
        [textField setDelegate:self];
        [textField setTextAlignment:UITextAlignmentCenter];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.view addSubview:textField];
        NSLog(@"CREATING A NEW TEXTFIELD");
    }
    if (self.navigationItem.leftBarButtonItem.tag == 0) {
        [textField setPlaceholder:@"Create a new File"];
        self.navigationItem.leftBarButtonItem.tag = 1;
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"folder_nav.png"]];
        self.title = @"Append To A File";
        [saveNewFolderButton setTitle:@"Save To File" forState:UIControlStateNormal];
        [saveNewFolderButton removeTarget:self action:@selector(makeFolder) forControlEvents:UIControlEventTouchUpInside];
        [saveNewFolderButton addTarget:self action:@selector(makeFile) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HasToggledToFilesViewNotification" object:nil];
        [tableViewController.tableView reloadData];
    }
    else if (self.navigationItem.leftBarButtonItem.tag ==1){
        [textField setPlaceholder:@"Create a new Folder"];
        self.navigationItem.leftBarButtonItem.tag = 0;
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"pages_nav.png"]];
        self.title = @"Save To A Folder";
        [saveNewFolderButton setTitle:@"Save To Folder" forState:UIControlStateNormal];
        [saveNewFolderButton removeTarget:self action:@selector(makeFile) forControlEvents:UIControlEventTouchUpInside];
        [saveNewFolderButton addTarget:self action:@selector(makeFolder) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HasToggledToFoldersViewNotification" object:nil];
        [tableViewController.tableView reloadData];
    }
    //[textField becomeFirstResponder];
}

#pragma mark RESPONDING TO NOTIFICATIONS

- (void) getSelectedFolder:(NSNotification *)notification{
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
    
}


- (void) getSelectedFile:(NSNotification *)notification{
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

- (void)searchkeyboardWasShown{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)searchkeyboardWasHidden{
    [self.navigationController.navigationBar setHidden:NO];

}


- (void) makeFolder{
    NSLog(@"CREATING A NEW FOLDER");
    if (textField.text == nil) {
        return;
    }
    //else if (!isSelected){ 
    //FIXME: check to see if a folder with the specified name exists, if yes, put up an alert view 
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Folder"
                                   inManagedObjectContext:managedObjectContext];
    Folder *newFolder = [[Folder alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext]; 
    
    newFolder.name = textField.text;
    /*--Save the MOC--*/	
    NSError *error;
    if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
    }
    textField.text = @"";
    [textField resignFirstResponder];
   // if (!swappingViews) {
   //     [self swapViews];
   // }
    [newFolder release];
}
- (void) makeFile{
    NSLog(@"CREATING A NEW FILE");
    if (textField.text == nil) {
        return;
    }
    //else if (!isSelected){ 
    //FIXME: check to see if a folder with the specified name exists, if yes, put up an alert view 
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"File"
                                   inManagedObjectContext:managedObjectContext];
    File *newFile = [[File alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext]; 
    
    newFile.name = textField.text;
  
    /*--Save the MOC--*/	
    NSError *error;
    if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
    }
    textField.text = @"";
    [textField resignFirstResponder];
    // if (!swappingViews) {
    //     [self swapViews];
    // }
    [newFile release];
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	//swappingViews = NO;
}

/*
- (void) swapViews {
	CATransition *transition = [CATransition animation];
	transition.duration = 1.0;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[transition setType:@"kCATransitionPush"];	
	[transition setSubtype:@"kCATransitionFromRight"];
	swappingViews = YES;
	transition.delegate = self;
	[self.view.layer addAnimation:transition forKey:nil];
    //set views hidden and not hidden in sequence.
}
*/

#pragma -

@end



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
