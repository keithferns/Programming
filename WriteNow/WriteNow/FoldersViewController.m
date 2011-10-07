//  FoldersViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FoldersViewController.h"
#import "FoldersTableViewController.h"
#import "WriteNowAppDelegate.h"

#import "CustomTextView.h"
#import "CustomTextField.h"
#import "CustomToolBar.h"
#import "MyDataObject.h"

@implementation FoldersViewController

@synthesize tableViewController, managedObjectContext;

@synthesize sender, newText;
@synthesize textView, nameField;
@synthesize toolBar, saveNewFolderButton;
@synthesize navPopover;

#define screenRect [[UIScreen mainScreen] applicationFrame]
//CGRect screenBounds = [UIScreen mainScreen].bounds;
#define tabBarHeight self.tabBarController.tabBar.frame.size.height
#define navBarHeight self.navigationController.navigationBar.frame.size.height
#define toolBarRect CGRectMake(screenRect.size.width, 0, screenRect.size.width, 40)
#define textViewRect CGRectMake(5, navBarHeight+10, screenRect.size.width-10, 140)
#define bottomViewRect CGRectMake(0, textViewRect.origin.y+textViewRect.size.height+10, screenRect.size.width, screenRect.size.height-textViewRect.origin.y-textViewRect.size.height-10)

- (MyDataObject *) myDataObject {
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	MyDataObject* myDataObject;
	myDataObject = (MyDataObject*) theDelegate.myDataObject;
	return myDataObject;
}


#pragma mark - View lifecycle

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
        [navPopover presentPopoverFromRect:CGRectMake(300, 0, 50, tabBarHeight-7)
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
    [newText release];
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
    //[self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    UIImage *background = [UIImage imageNamed:@"wallpaper.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:background]];
    //previousTextInput = @"";    
    
    /*--NAVIGATION ITEMS --*/
    /*-Initialize the TOOLBAR-*/
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
 
    
    UIBarButtonItem *newDoc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pages_nav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addFolderFile:)];
    self.navigationItem.leftBarButtonItem = newDoc;
    self.navigationItem.leftBarButtonItem.tag = 0;
    [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    
    
    UIBarButtonItem *makeFileFolder = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add-item_whiteonblack.png"] style:UIBarButtonItemStylePlain target:self action:@selector(makeFolderFile:)];
    self.navigationItem.rightBarButtonItem = makeFileFolder;
    self.navigationItem.rightBarButtonItem.tag = 0;
    [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];

    
    

  }

- (void) viewWillAppear:(BOOL)animated{
    self.title = @"Folders";
    if (tableViewController == nil) {
        tableViewController = [[FoldersTableViewController alloc]init];
    }
    if (tableViewController.tableView.superview == nil) {
        [self.view addSubview:tableViewController.tableView];
        [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
        tableViewController.tableView.rowHeight = 30.0;
        //[tableViewController.tableView setTableHeaderView:tableLabel];
    }

    //[tableViewController.tableView setTableHeaderView:tableLabel];
    //CGRect startFrame = CGRectMake(-screenRect.size.width, bottomViewRect.origin.y, bottomViewRect.size.width, bottomViewRect.size.height);
    
    CGRect startFrame = CGRectMake(bottomViewRect.origin.x, screenRect.size.height, bottomViewRect.size.width, bottomViewRect.size.height);
    tableViewController.tableView.frame = startFrame;   

    MyDataObject *mydata = [self myDataObject];
    if ([mydata.isEditing intValue] == 1 && textView == nil){
        //TEXTVIEW: setup and add to self.view
        textView = [[CustomTextView alloc] initWithFrame:CGRectMake(screenRect.origin.x, textViewRect.origin.y, textViewRect.size.width, textViewRect.size.height)];
        textView.delegate = self;    
        textView.inputAccessoryView = toolBar;
        [self.view addSubview:textView];
        [textView setText:mydata.myText];
        [textView setUserInteractionEnabled:YES];
        [textView becomeFirstResponder];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    if (textView.superview == nil && textView != nil) {
        textView.frame = textViewRect;
        tableViewController.tableView.frame = bottomViewRect;
    }else{
        CGRect frame = screenRect; 
        frame.origin.y = self.navigationController.navigationBar.frame.origin.y+navBarHeight;
        frame.size.height = screenRect.size.height-navBarHeight;
        tableViewController.tableView.frame = frame;
    }
    [UIView commitAnimations];  
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
    [self.nameField resignFirstResponder];
}

- (void) addFolderFile:(UIBarButtonItem *)barButtonItem {

    /*
    if (nameField == nil) {
        nameField = [[UITextField alloc] initWithFrame:CGRectMake(5, 155, 310, 30)];
        [nameField setBorderStyle:UITextBorderStyleRoundedRect];
        [nameField setInputAccessoryView:toolBar];
        [nameField setFont:[UIFont systemFontOfSize:13.0]];
        [nameField setTag:0];
        [nameField setDelegate:self];
        [nameField setTextAlignment:UITextAlignmentCenter];
        nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.view addSubview:nameField];
    }
     */
    if (self.navigationItem.leftBarButtonItem.tag == 0) {
        //[nameField setPlaceholder:@"Create a new File"];
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
        [nameField setPlaceholder:@"Create a new Folder"];
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
