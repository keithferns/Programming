//
//  ArchiveViewController.m
//  iDoit
//
//  Created by Keith Fernandes on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "iDoitAppDelegate.h"
#import "ArchiveViewController.h"

#import "FoldersDetailTableViewController.h"//testing
#import "Contants.h"
#import "UINavigationController+NavControllerCategory.h"



@implementation ArchiveViewController

@synthesize actionsPopover;
@synthesize saving;
@synthesize theItem;
@synthesize foldersTableViewController, filesTableViewController;

@synthesize managedObjectContext;

- (void) dealloc{
    [super dealloc];
    [actionsPopover release];
    [theItem release];
    [foldersTableViewController release];
    [filesTableViewController release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    saving = NO;
    actionsPopover = nil;
    theItem = nil;    
    foldersTableViewController = nil;
    filesTableViewController = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad

{
    [super viewDidLoad];
        
    //Navigation Bar SetUP
    NSArray *items = [NSArray arrayWithObjects:@"Folders", @"Documents", nil];
    UISegmentedControl *archivingControl = [[UISegmentedControl alloc] initWithItems:items];
    [archivingControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [archivingControl setWidth:90 forSegmentAtIndex:0];
    [archivingControl setWidth:90 forSegmentAtIndex:1];
    [archivingControl setSelectedSegmentIndex:0];
    [archivingControl addTarget:self
                         action:@selector(toggleFoldersFilesView:)
               forControlEvents:UIControlEventValueChanged];
    
     self.navigationItem.titleView = archivingControl;
    [archivingControl release];
    
    if (saving){
        self.managedObjectContext = theItem.addingContext;
        NSLog(@"Archive VIEWCONTROLLER: passed managedObjectContext: %@",  managedObjectContext);
        
        self.navigationItem.leftBarButtonItem = [self.navigationController addCancelButton];
        self.navigationItem.leftBarButtonItem.target = self;
        self.navigationItem.leftBarButtonItem.action = @selector(cancelSaving:);
        
        self.navigationItem.rightBarButtonItem =[self.navigationController addDoneButton];
        [self.navigationItem.rightBarButtonItem setTarget:self];
        //FIXME:
        [self.navigationItem.rightBarButtonItem setAction:@selector(saveFolderFile:)];
        
    }else if (managedObjectContext == nil){
        
        /*-- Point current instance of the MOC to the main managedObjectContext --*/
        managedObjectContext = [(iDoitAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"Archive VIEWCONTROLLER: new managedObjectContext: %@",  managedObjectContext);

    } 
    
    
    if (!saving){
        
        UIBarButtonItem *rightNavButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(presentActionsPopover:)];
        rightNavButton.tag = 2;
        self.navigationItem.rightBarButtonItem = rightNavButton;    
        [rightNavButton release];
        UIBarButtonItem *leftNavButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentActionsPopover:)];
        leftNavButton.tag = 1;
        self.navigationItem.leftBarButtonItem = leftNavButton;
        [leftNavButton release];
    } else {
    
    }
    
    //Table View Controllers
     foldersTableViewController = [[FoldersTableViewController alloc] init];
    foldersTableViewController.saving = YES;
    foldersTableViewController.managedObjectContext = self.managedObjectContext;
    foldersTableViewController.theItem = self.theItem;
    filesTableViewController =  [[FilesTableViewController alloc] init];
    //
    [self.view addSubview:foldersTableViewController.tableView];
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTableRowSelection:) name:@"TableCellSelected" object:nil];

    
    UIBarButtonItem *firstItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentActionsPopover:)];
    //firstItem.title = @"Do Something";
    [firstItem setTag:1];
    
    UIBarButtonItem *secondItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(presentActionsPopover:)];
    
    [secondItem setTag:2];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabBarHeight, kScreenWidth, kTabBarHeight)];
    [toolbar setItems:[NSArray arrayWithObjects:flexSpace, firstItem,flexSpace,secondItem,flexSpace, nil]];
    toolbar.tintColor = [UIColor clearColor];
    [firstItem release];
    [secondItem release];
    [flexSpace release];
    [self.view addSubview:toolbar];
    [toolbar release];
}

- (void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:nil name: UITableViewSelectionDidChangeNotification object:nil];
    
    if([actionsPopover isPopoverVisible]) {
        [actionsPopover dismissPopoverAnimated:YES];
        [actionsPopover setDelegate:nil];
        [actionsPopover autorelease];
        actionsPopover = nil;
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) toggleFoldersFilesView:(id) sender{
    
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    NSLog(@"ArchiveViewController:toggleFoldersViewController -> Segment %d touched", segControl.selectedSegmentIndex);

	switch (segControl.selectedSegmentIndex) {
		case 0:
            NSLog(@"ArchiveViewController:toggleFoldersViewController -> Switching to Folder View");
            [filesTableViewController.tableView removeFromSuperview];
            [self.view addSubview:foldersTableViewController.tableView];
			break;
				case 1:
            NSLog(@"ArchiveViewController:toggleFoldersViewController -> Switching to File View");	
            
            [foldersTableViewController.tableView removeFromSuperview];
            [self.view addSubview:filesTableViewController.tableView];
            break;
	}
}

- (void) editFoldersFiles{
//    
}



#pragma mark - Popover Management

- (void) presentActionsPopover:(id) sender{
  
    if([actionsPopover isPopoverVisible]) {
        [actionsPopover dismissPopoverAnimated:YES];
        [actionsPopover setDelegate:nil];
        [actionsPopover autorelease];
        actionsPopover = nil;
        return;
    }
    if(!actionsPopover ) {
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        
            switch ([sender tag]) {
            case 1://ADDING NEW FOLDERS OR FILES
                {
                NSLog(@"Saving");        
                
                CGSize size = CGSizeMake(140, 160);
                viewCon.contentSizeForViewInPopover = size;
                    
               viewCon.view =  [self addItemsView:CGRectMake(0, 0, size.width, size.height)];
                actionsPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
                    [actionsPopover setDelegate:self];
                    
                if (saving){
                
                    [actionsPopover presentPopoverFromRect:CGRectMake(80, kScreenHeight-kTabBarHeight, 50, 40)
                                                inView:self.view    
                              permittedArrowDirections:UIPopoverArrowDirectionDown
                                              animated:YES name:@"Save"];  
                }
                    else if (!saving) {
                        [actionsPopover presentPopoverFromRect:CGRectMake(10, 0, 50, 40)
                                                        inView:self.view    
                                      permittedArrowDirections:UIPopoverArrowDirectionUp
                                                      animated:YES name:@"Save"];     
                    }
                    
                [viewCon release];
                }
                break;
                
            case 2:
                {
                NSLog(@"Organizing");
                
                CGSize size = CGSizeMake(140, 260);
                viewCon.contentSizeForViewInPopover = size;
                viewCon.view = [self organizerView: CGRectMake(0, 0, size.width, size.height)];
                
                actionsPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
                    [actionsPopover setDelegate:self];
                
            if (saving) {
                                
            [actionsPopover presentPopoverFromRect:CGRectMake(190, kScreenHeight-kTabBarHeight, 50, 40)
                                                inView:self.view
                              permittedArrowDirections: UIPopoverArrowDirectionDown
                                              animated:YES name:@"Plan"];
                }
            else if (!saving) {
                [actionsPopover presentPopoverFromRect:CGRectMake(280,0, 50, 40) inView:self.view
                    permittedArrowDirections: UIPopoverArrowDirectionUp
                    animated:YES name:@"Organize"];
                        }
             
                [viewCon release];
                }
                break;
                
                
            default:
                break;
        }    

    }

}
- (void) cancelPopover:(id)sender {
    NSLog(@"CANCELLING POPOVER");
    return;
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Did dismiss");
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Should dismiss");
    return YES;
}


- (void) showTextBox:(id) sender {
    
    //Check for visisble instance of actionsPopover. if yes dismiss.
    if([actionsPopover isPopoverVisible]) {
        [actionsPopover dismissPopoverAnimated:YES];
        [actionsPopover setDelegate:nil];
        [actionsPopover autorelease];
        actionsPopover = nil;
    }
    
    UIAlertView *textBox = [[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil] autorelease];
    [textBox setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    if ([sender tag] == 1){
        
        textBox.title = @"New Folder:";
        
    }else if ([sender tag] == 2){
        
        textBox.title = @"New Document:";
    }
    
    [textBox show];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    NSString *string = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([string isEqualToString:@"Save"]){
        
        UITextField *theTextField = [alertView textFieldAtIndex:0];
        
        NSLog(@"New Folder/File Name is %@", theTextField.text);

                if ([alertView.title isEqualToString:@"New Folder:"]){
    
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Folder" inManagedObjectContext:managedObjectContext];
        
        Folder *theFolder = [[Folder alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        theFolder.name = theTextField.text;
            
            if (saving) {
                theItem.theNote.folder = theFolder;
            }
                    
            NSLog(@"Created new folder called %@", theFolder.name);
                    [theFolder release];
                    //CHECKME: is it ok to release theFolder here. Also why not just create a folder in theItem and then link this folder to the note. 
            }
        else if ([alertView.title isEqualToString:@"New Document:"]){
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:managedObjectContext];
            
            Document *theDocument = [[Document alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
            theDocument.aTitle = theTextField.text;
            
            if (saving){
                
                NSString *tempString = [NSString stringWithFormat:@"%@%@%@", theDocument.aText, @"\n", theItem.theNote.text];
                
                //tempString = [myFile.fileText stringByAppendingString:newMemoText.memoText];
                
                theDocument.aText = tempString;
                            
            NSLog(@"Created new document called %@", theDocument.aTitle);
                [theDocument release]; 
                //CHECKME: same issue as theFolder above
                    }
        
        /*--Save the MOC--*/
        NSError *error;
        if(![managedObjectContext save:&error]){ 
            NSLog(@"ArchiveViewController ADDING MOC: DID NOT SAVE");
            } 
        
        }
    }
}



- (void) pushingDetail {
    FoldersDetailTableViewController *detailViewController = [[FoldersDetailTableViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (void) handleTableRowSelection:(NSNotification *)notification{
    
    NSLog(@"ArchiveViewController:handleTableRowSelection - notification received");
    
    if (![[notification object] isKindOfClass:[Folder class]]){
        NSLog(@"NOT A FOLDER");
        return;
    }
    
    if (saving){
        Folder *thefolder = [notification object];
        theItem.theNote.folder = thefolder;
        
        NSLog(@"the folder name for the current note is %@", theItem.theNote.folder.name);
        return;
    }
}

-(void)saveFolderFile:(id) sender{
    saving = NO;
    NSError *error;
    if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) cancelSaving:(id) sender{
    saving = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

 
- (UIView *) addItemsView: (CGRect) frame{
    UIView *oView = [[[UIView alloc] initWithFrame:frame] autorelease];
    //FIXME: Potential Memory Leak for oView
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 39)];
    [addLabel setText:@"ADD NEW:"];
    [addLabel setBackgroundColor:[UIColor clearColor]];
    addLabel.textColor = [UIColor lightTextColor];
    addLabel.font = [UIFont boldSystemFontOfSize:18];
    addLabel.layer.borderWidth = 2;
    addLabel.layer.borderColor = [UIColor clearColor].CGColor;
    
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 40, 120, 39)];
    [b1 setTitle:@"Folder" forState:UIControlStateNormal];
    b1.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    b1.backgroundColor = [UIColor darkGrayColor];
    b1.alpha = 0.4;
    [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b1.layer.cornerRadius = 6.0;
    b1.layer.borderWidth = 1.0;
    [b1 addTarget:self action:@selector(showTextBox:) forControlEvents:UIControlEventTouchUpInside];
    [b1 setTag:1];
    
    UIButton *b2 = [[UIButton alloc] initWithFrame:CGRectMake(5, 80, 120, 39)];
    b2.backgroundColor = [UIColor darkGrayColor];
    b2.alpha = 0.4;
    [b2 setTitle:@"Document" forState:UIControlStateNormal];
    b2.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [b2 addTarget:self action:@selector(showTextBox:) forControlEvents:UIControlEventTouchUpInside];
    b2.layer.cornerRadius = 6.0;
    b2.layer.borderWidth = 1.0;
    [b2 setTag:2];
    //b2.layer.borderWidth = 2;
    //b2.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    UIButton *b3 = [[UIButton alloc] initWithFrame:CGRectMake(5, 120, 120, 39)];
    [b3 setTitle:@"Note" forState:UIControlStateNormal];
    b3.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [b3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b3 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b3.backgroundColor = [UIColor darkGrayColor];
    b3.alpha = 0.4;
    [b3 addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    b3.layer.cornerRadius = 6.0;
    b3.layer.borderWidth = 1.0;

    
    [oView addSubview:addLabel];
    [oView addSubview:b1];
    [oView addSubview:b2];
    [oView addSubview:b3];
    
    
    [b1 release];
    [b2 release];
    [b3 release];
    [addLabel release];
    
    return oView;
    
}


- (UIView *)organizerView: (CGRect)frame {
    UIView *oView = [[[UIView alloc] initWithFrame:frame] autorelease];
    //FIXME: Potential Memory Leak for oView
    UILabel *sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 29)];
    [sortLabel setText:@"Sort By"];
    [sortLabel setBackgroundColor:[UIColor clearColor]];
    sortLabel.textColor = [UIColor lightTextColor];
    sortLabel.font = [UIFont boldSystemFontOfSize:18];
    sortLabel.layer.borderWidth = 2;
    sortLabel.layer.borderColor = [UIColor clearColor].CGColor;
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 120, 39)];
    [b1 setTitle:@"Name" forState:UIControlStateNormal];
    b1.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    b1.backgroundColor = [UIColor darkGrayColor];
    b1.alpha = 0.4;
    [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b1.layer.cornerRadius = 6.0;
    b1.layer.borderWidth = 1.0;
    [b1 addTarget:self action:@selector(pushingDetail) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *b2 = [[UIButton alloc] initWithFrame:CGRectMake(5, 70, 120, 39)];
    b2.backgroundColor = [UIColor darkGrayColor];
    b2.alpha = 0.4;
    [b2 setTitle:@"Date Created" forState:UIControlStateNormal];
    b2.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b2.layer.cornerRadius = 6.0;
    b2.layer.borderWidth = 1.0;
    
    UIButton *b3 = [[UIButton alloc] initWithFrame:CGRectMake(5, 110, 120, 39)];
    [b3 setTitle:@"Date Modified" forState:UIControlStateNormal];
    b3.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [b3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b3 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b3.backgroundColor = [UIColor darkGrayColor];
    b3.alpha = 0.4;
    b3.layer.cornerRadius = 6.0;
    b3.layer.borderWidth = 1.0;

    UIButton *b4 = [[UIButton alloc] initWithFrame:CGRectMake(5, 150, 120, 39)];
    [b4 setTitle:@"Other" forState:UIControlStateNormal];
    b4.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    b4.backgroundColor = [UIColor darkGrayColor];
    [b4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b4 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b4.alpha = 0.4;
    b4.layer.cornerRadius = 6.0;
    b4.layer.borderWidth = 1.0;

    UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 140, 29)];
    deleteLabel.backgroundColor = [UIColor clearColor];
    deleteLabel.textColor = [UIColor lightTextColor];
    [deleteLabel setText:@"Delete"];
    deleteLabel.font = [UIFont boldSystemFontOfSize:18];

    UIButton *b5 = [[UIButton alloc] initWithFrame:CGRectMake(5, 220, 120, 39)];
    [b5 setTitle:@"Delete" forState:UIControlStateNormal];
    b5.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    b5.alpha = 0.4;
    b5.backgroundColor = [UIColor darkGrayColor];
    [b5 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [b5 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b5.layer.cornerRadius = 6.0;
    b5.layer.borderWidth = 1.0;
    
    [oView addSubview:sortLabel];
    [oView addSubview:b1];
    [oView addSubview:b2];
    [oView addSubview:b3];
    [oView addSubview:b4];
    [oView addSubview:deleteLabel];
    [oView addSubview:b5];
    
    
    [b1 release];
    [b2 release];
    [b3 release];
    [b4 release];
    [b5 release];
    [sortLabel release];
    [deleteLabel release];
    
    return oView;
}

@end


