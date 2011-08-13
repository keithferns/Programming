//
//  AddTaskViewController.m
//  miMemo
//
//  Created by Keith Fernandes on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddTaskViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "miMemoAppDelegate.h"
#import "NSManagedObjectContext-insert.h"
#import "TaskCustomCell.h"

@implementation AddTaskViewController

@synthesize managedObjectContext, managedObjectContextTV;
@synthesize datePicker;
@synthesize newMemoText, newTask;
@synthesize goActionSheet;
@synthesize taskToolbar;
@synthesize dateTextField, timeTextField, textView, newTextInput;
@synthesize taskDate;
//@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize tableView;
@synthesize memoArray;
@synthesize selectedDate;
@synthesize tableLabel;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*Setting Up the Views*/
    NSLog(@"In NewTaskViewController");
    
    newTask = [managedObjectContext insertNewObjectForEntityForName:@"ToDo"];
        
    [self makeToolbar];
    [self.view addSubview:taskToolbar];
    
    /*--Adding the Text View */
    /*--The Text View --*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 35, 300, 60)];
    [self.view addSubview:textView];
    [textView setFont:[UIFont systemFontOfSize:15]];
    textView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    textView.layer.cornerRadius = 7.0;
    textView.layer.frame = CGRectInset(textView.layer.frame, 5, 10);
    //textView.layer.contents = (id) [UIImage imageNamed:@"lined_paper_320x200.png"].CGImage;    
    [textView setText:[NSString stringWithFormat:@"%@", newTextInput]];
    [self.view addSubview:textView];
    [textView setDelegate:self];
    /*--Adding the Date and Time Fields--*/
    
    dateTextField = [[UITextField alloc] init];
    [dateTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [dateTextField setFont:[UIFont systemFontOfSize:15]];
    [dateTextField setFrame:CGRectMake(12, 10, 292, 31)];
    [dateTextField setPlaceholder:@"Set Task Date"];
    [self.view addSubview:dateTextField];
   
    
    tableLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 20)];
    [tableLabel setBackgroundColor:[UIColor blackColor]];
    [tableLabel setTextColor:[UIColor whiteColor]];
    [tableLabel setTextAlignment:UITextAlignmentCenter];
    [tableLabel setText:@"All Tasks"];
    [self.view addSubview:tableLabel];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 90, 290, 100)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setTableHeaderView:tableLabel];
    [self.view addSubview:tableView];

    /*-- Initializing the managedObjectContext--*/
	if (managedObjectContextTV == nil) { 
		managedObjectContextTV = [(miMemoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContextTV);
    }
    /*--Done Initializing the managedObjectContext--*/
    
    /*
     NSError *error;
     if (![[self fetchedResultsController] performFetch:&error]) {
     }
     */
    
    /*Add a new instance of MemoText -- will be linked to the new Task */
    newMemoText = [managedObjectContext insertNewObjectForEntityForName:@"MemoText"];
    [newMemoText setMemoText:textView.text];
    [newMemoText setNoteType:[NSNumber numberWithInt:2]];
    [newMemoText setCreationDate:[NSDate date]];
    
    swappingViews = NO;
    
    /*-- Add and Initialize date and time pickers --*/
    //datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 245, 320, 215)];
    //[datePicker setDatePickerMode:UIDatePickerModeDate];
    datePicker.minimumDate = [NSDate date];		//Now
	datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)];
	datePicker.date = [NSDate date];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    //datePicker.hidden = NO;
    
    [self fetchSelectedTasks];
}
    
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	datePicker = nil;
}

- (void)dealloc {
    [super dealloc];
	[datePicker release];
    [goActionSheet release];
    [taskToolbar release];
    [taskDate release];
    [dateTextField release];
    [timeTextField release];
    [textView release];
    
    
    //[monthView release];
    //[datetimeView release];
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	swappingViews = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)datePickerChanged:(id)sender {
    NSLog(@"DatePicker Changed Value");
    memoArray = nil;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ToDo" inManagedObjectContext:managedObjectContextTV];
	
    //setting up the fetch request
	NSFetchRequest *request	= [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
    //defines how to sort the records
    NSDate *tempDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:tempDate];
    NSPredicate *checkDate = [NSPredicate predicateWithFormat:@"doDate == %@", dateString];
    [dateFormatter release];
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContextTV executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {// ??
	}
    //save fetched data to an array
	[self setMemoArray:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
    
    [request setPredicate:checkDate];

    [tableLabel setText:dateString];
    if (memoArray == NULL) {
        NSString *noTask = [NSString stringWithFormat:@"No Tasks Due on %@", dateString];
        tableLabel.text = noTask;
        }   
    [self.tableView reloadData];   

}

-(void) fetchSelectedTasks{
	NSLog(@"Going to fetch Tasks records now");
    //defining table to use
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ToDo" inManagedObjectContext:managedObjectContextTV];
	
    //setting up the fetch request
	NSFetchRequest *request	= [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
    //defines how to sort the records
	NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"doDate" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];//note: if adding other sortdescriptors, then use  method -arraywithObjects. If the fetch request must meet some conditions, then use the NSPredicate class 
	[request setSortDescriptors:sortDescriptors];
	[sortByDate release];
    
    NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContextTV executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {// ??
	}
    //save fetched data to an array
	[self setMemoArray:mutableFetchResults];
	
	[mutableFetchResults release];
	[request release];
}


/*
 #pragma mark - Fetched Results Controller
 
 - (NSFetchedResultsController *) fetchedResultsController {
 if (_fetchedResultsController!=nil) {
 return _fetchedResultsController;
 }
 
 NSFetchRequest *request = [[NSFetchRequest alloc] init];
 
 [request setEntity:[NSEntityDescription entityForName:@"ToDo" inManagedObjectContext:managedObjectContextTV]];
 
 NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"doDate" ascending:YES];
 NSSortDescriptor *timeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"doDate" ascending:NO];// just here to test the sections and row calls
 
 [request setSortDescriptors:[NSArray arrayWithObjects:dateDescriptor,timeDescriptor, nil]];
 [dateDescriptor release];
 [timeDescriptor release];
 
 NSString *testProperty = @"doDate";
 
 NSPredicate *checkDate = [NSPredicate predicateWithFormat:@"%K == %@",testProperty,taskDate];
 
 [request setPredicate:checkDate];
 
 
 [request setFetchBatchSize:10];
 
 
 NSFetchedResultsController *newController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContextTV sectionNameKeyPath:@"doDate" cacheName:@"Root"];
 
 newController.delegate = self;
 self.fetchedResultsController = newController;
 [newController release];
 [request release];
 
 return _fetchedResultsController;
 }
 
 */


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	//return [[_fetchedResultsController sections] count];
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    //return [sectionInfo numberOfObjects];
    return [memoArray count];
}

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"dd MMMM yyyy h:mm a"];
        //[dateFormatter setDateFormat:@"EEEE, dd MMMM yyyy h:mm a"]; //This format gives the Day of Week, followed by date and time
        
	}
	
	TaskCustomCell *mycell;
	if([cell isKindOfClass:[UITableViewCell class]]){
        
		mycell = (TaskCustomCell *) cell;
	}
    //ToDo *aTask = [_fetchedResultsController objectAtIndexPath:indexPath];	
    ToDo *aTask = [memoArray objectAtIndex:[indexPath row]];
    
    [mycell.memoTextLabel setText:[NSString stringWithFormat:@"%@", aTask.memoText.memoText]];	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TaskCustomCell";
	
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"dd MMMM yyyy h:mm a"];
	}
	TaskCustomCell *cell = (TaskCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle]
									loadNibNamed:@"TaskCustomCell"
									owner:nil options:nil];
		
		for (id currentObject in topLevelObjects){
			if([currentObject isKindOfClass:[UITableViewCell class]]){
				cell = (TaskCustomCell *) currentObject;
				break;
			}
		}
	}
    
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}





#pragma mark -
#pragma mark Class Methods

- (void) backAction{
	[self dismissModalViewControllerAnimated:YES];		
}

- (void) setTaskDate{    
    newTask.selectedDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    taskDate = [dateFormatter stringFromDate:newTask.selectedDate];
    
    newTask.doDate = taskDate;
    newTask.memoText = newMemoText;
    
    dateTextField.text = taskDate;
    [dateFormatter release];
        
    NSError *myerror;
	if(![managedObjectContext save:&myerror]){ 
        NSLog(@"DID NOT SAVE");
	}
    //TODO: Add a fetchRequest here to get existing Task for the date selected.  display a table with existing Task for that date in the top View. This ideally should happen in sync with the change of datePicker to timePicker. 
    
    if (!swappingViews) {
        [self swapViews];
    }
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"NEW" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [doneButton setTag:3];
    [doneButton setWidth:90];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:taskToolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 1) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    taskToolbar.items = toolbarItems;
    [doneButton release];
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
	//monthView.hidden = YES;
	//datetimeView.hidden = NO;	
}



#pragma mark -
#pragma mark Navigation
- (void) makeToolbar {
    /*Setting up the Toolbar */
    CGRect buttonBarFrame = CGRectMake(0, 208, 320, 37);
    taskToolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [taskToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [taskToolbar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *saveAsButton = [[UIBarButtonItem alloc] initWithTitle:@"BACK" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [saveAsButton setTag:0];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [newButton setTag:1];
    UIBarButtonItem *gotoButton = [[UIBarButtonItem alloc] initWithTitle:@"GO TO.." style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [gotoButton setTag:2];
    
    [saveAsButton setWidth:90];
    [newButton setWidth:90];
    [gotoButton setWidth:90];
    
    //UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //Possible to use this with the initWithCustomView method of  UIBarButtonItems
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects:flexSpace, saveAsButton, flexSpace, newButton, flexSpace, gotoButton, flexSpace,nil];
    [taskToolbar setItems:toolbarItems];
    [saveAsButton release];
    [newButton release];
    [gotoButton release];
    [flexSpace release];
    /*--End Setting up the Toolbar */
}

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 0:
            [self backAction];
            break;            
		case 1:
            [self setTaskDate];
			break;
		case 2:
			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To" delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil otherButtonTitles:@"Memos, Files and Folders", @"Task", @"Tasks", nil];
			[goActionSheet showInView:self.view];            
			break;
        case 3:
            [self dismissModalViewControllerAnimated:YES];
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

