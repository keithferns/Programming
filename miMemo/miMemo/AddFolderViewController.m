//
//  AddFolderViewController.m
//  Memo
//
//  Created by Keith Fernandes on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddFolderViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "miMemoAppDelegate.h"
#import "NSManagedObjectContext-insert.h"
#import "Memo.h"

@implementation AddFolderViewController

@synthesize managedObjectContext;
@synthesize newMemoText, newFile, newFolder;
@synthesize goActionSheet;
@synthesize folderToolbar;
@synthesize folderTextField, fileTextField, tagTextField, textView, newTextInput;


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"In AddFolderViewController");
    /*Setting Up the main view */
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [myView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    myView.hidden = NO;
    self.view = myView;
        
    [self makeToolbar];
    [self.view addSubview:appointmentsToolbar];
    
    /*--The Text View --*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 45, 300, 160)];
    [self.view addSubview:textView];
    [textView setFont:[UIFont systemFontOfSize:18]];
    textView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    textView.layer.cornerRadius = 7.0;
    textView.layer.frame = CGRectInset(textView.layer.frame, 5, 10);
    textView.layer.contents = (id) [UIImage imageNamed:@"lined_paper_320x200.png"].CGImage;    
    [textView setText:[NSString stringWithFormat:@"%@", newTextInput]];
    [self.view addSubview:textView];
    [textView setDelegate:self];
    /*--Adding the Date and Time Fields--*/
    
    folderTextField = [[UITextField alloc] init];
    [folderTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [folderTextField setFont:[UIFont systemFontOfSize:15]];
    [folderTextField setFrame:CGRectMake(12, 20, 145, 31)];
    [folderTextField setPlaceholder:@"Folder"];
    [self.view addSubview:folderTextField];
    
    fileTextField = [[UITextField alloc] init];
    [fileTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [fileTextField setFont:[UIFont systemFontOfSize:15]];
    [fileTextField setFrame:CGRectMake(160, 20, 145, 31)];
    [fileTextField setPlaceholder:@"File Name"];
    [self.view addSubview:fileTextField];
    
    //TODO: add textField for Tags    
    /*--Done Setting Up the Views--*/
    
    /*-- Initializing the managedObjectContext--*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(miMemoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }
    
    /*--Done Initializing the managedObjectContext--*/
    NSLog(@"After managedObjectContext: %@",  managedObjectContext);

    newMemoText = [managedObjectContext insertNewObjectForEntityForName:@"MemoText"];
    [newMemoText setMemoText:newTextInput];
    [newMemoText setCreationDate:[NSDate date]]; 
   
    Memo *newMemo = [managedObjectContext insertNewObjectForEntityForName:@"Memo"];
    newMemo.memoText = newMemoText; 
    newMemo.doDate = newMemoText.creationDate ;

    //Insert a new File Object into the MOC
    newFile = [managedObjectContext insertNewObjectForEntityForName:@"File"]; 
    int temp = arc4random();
    NSString *tempString = [NSString stringWithFormat:@"%d", temp];

    [newFile setFileName:tempString];
   newMemo.appendToFile = newFile;

    //Insert a new Folder object into the MOC. 
    newFolder = [managedObjectContext insertNewObjectForEntityForName:@"Folder"]; 
    int tempF = abs(arc4random());
    NSString *tempStringF = [NSString stringWithFormat:@"Folder%d", tempF];
    
    [newFolder setFolderName:tempString];
    newFile.savedIn = newFolder;
    
    NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
	}
    
    swappingViews = NO;        
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	swappingViews = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc {
    [super dealloc];
    [goActionSheet release];
    [appointmentsToolbar release];
    [fileTextField release];
    [folderTextField release];
    [tagTextField release];
    [textView release];
}

#pragma mark -
#pragma mark Class Methods

- (void) backAction{
	[self dismissModalViewControllerAnimated:YES];		
}

- (void) makeFolder{
    if (folderTextField.text == nil) {
        return;
    }
    //newFolder = [managedObjectContext insertNewObjectForEntityForName:@"Folder"];    
    newFolder.folderName = folderTextField.text;
    /*--Save the MOC--*/	
	NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
	}
    if (!swappingViews) {
        [self swapViews];
    }
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [doneButton setTag:3];
    [doneButton setWidth:90];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:appointmentsToolbar.items] retain];
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 1) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    appointmentsToolbar.items = toolbarItems;
}

- (void) makeFile{
    if (folderTextField.text == nil) {
        return;
    }
    newFile.fileName = fileTextField.text;
    /*--Save the MOC--*/	
	NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"makeFile DID NOT SAVE");
	}
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [newButton setTag:4];
    [newButton setWidth:90];
    NSUInteger newButtonIndex = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:appointmentsToolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 3) {
            newButtonIndex = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButtonIndex withObject:newButton];
    appointmentsToolbar.items = toolbarItems;
}

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

#pragma mark -
#pragma mark Navigation
- (void) makeToolbar {
    /*Setting up the Toolbar */
    CGRect buttonBarFrame = CGRectMake(0, 208, 320, 37);
    appointmentsToolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [appointmentsToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [appointmentsToolbar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *saveAsButton = [[UIBarButtonItem alloc] initWithTitle:@"BACK" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [saveAsButton setTag:0];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [newButton setTag:1];
    UIBarButtonItem *gotoButton = [[UIBarButtonItem alloc] initWithTitle:@"GO TO.." style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [gotoButton setTag:2];
    
    [saveAsButton setWidth:90];
    [newButton setWidth:90];
    [gotoButton setWidth:90];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects:flexSpace, saveAsButton, flexSpace, newButton, flexSpace, gotoButton, flexSpace,nil];
    [appointmentsToolbar setItems:toolbarItems];
    /*--End Setting up the Toolbar */
}

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 0:
            [self backAction];
            break;            
		case 1:
            [self makeFolder];
			break;
		case 2:
			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To" delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil otherButtonTitles:@"Memos, Files and Folders", @"Appointments", @"Tasks", nil];
			[goActionSheet showInView:self.view];            
			break;
        case 3:
            [self dismissModalViewControllerAnimated:YES];
            break;
        case 4:
            break;     
		default:
			break;
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex){
        case 3:
        default:
            break;
        case 2:			
            break;
        case 1:			
            break;
        case 0:
            break;				
    }
}

@end