//
//  SchedulePopoverViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SchedulePopoverViewController.h"

@implementation SchedulePopoverViewController

@synthesize dateField, startTimeField, endTimeField, recurringField;
@synthesize button1, button2;
@synthesize tableViewController;

#define screenRect [[UIScreen mainScreen] applicationFrame]
#define toolBarRect CGRectMake(screenRect.size.width, 0, screenRect.size.width, 40)


- (void)dealloc
{
    [super dealloc];

    [dateField release];
    [startTimeField release];
    [endTimeField release];
    [recurringField release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //toolBar = [[CustomToolBar alloc] initWithFrame:toolBarRect];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFields:) name:@"GetDateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFields:) name:@"PopOverShouldUpdateNotification" object:nil];
   
    
    button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //[button1 setTitle:@"Done" forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"red_round.png"] forState:UIControlStateNormal];
    [button1 setTag:1];
    [button1.layer setCornerRadius:10.0];
    [button1 addTarget:self.parentViewController action:@selector(cancelPopover:) forControlEvents:UIControlEventTouchUpInside];
    
    button2 = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 40, 40)];
    //[button2 setTitle:@"Done" forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"blue_round.png"] forState:UIControlStateNormal];
    [button2 setTag:2];
    [button2.layer setCornerRadius:10.0];
    [button2 addTarget:self.parentViewController action:@selector(saveSchedule) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [button1 release];
    [button2 release];
    [tableViewController.tableView setFrame:CGRectMake(145, 43, 145, 140)];
    [self.view  addSubview:tableViewController.tableView];
}

- (void) viewWillAppear:(BOOL)animated{
     
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    

    dateField = nil;
    startTimeField = nil;
    endTimeField = nil;
    recurringField = nil;}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) updateFields:(NSNotification *) notification {
    NSDictionary *inputObjects = [notification userInfo];    
    
    switch ([[inputObjects objectForKey:@"num"] intValue]) {
        case 1:
            NSLog(@"PopOverShoudlUpdate Notification Recieved:Adding DateField");
            if (dateField.superview == nil) {
                NSLog(@"DateField.superView is nil. Adding");
                dateField = [[CustomTextField alloc] init];
                [dateField setFrame:CGRectMake(0, 43, 140, 40)];
                dateField.tag = 12;
                [dateField setPlaceholder:@"Date:"];
                [self.view addSubview:dateField];
                [dateField setInputView:[inputObjects objectForKey:@"picker"]];
                [dateField setInputAccessoryView:[inputObjects objectForKey:@"toolbar"]];
                [dateField becomeFirstResponder];
            }
            Appointment *tempAppointment = [notification object];
            if (tempAppointment.doDate !=nil) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"EEE, MMM d, yyyy"];
                self.dateField.text = [dateFormatter stringFromDate:tempAppointment.doDate];
                [dateFormatter release];
            }
            break;
        
        case 2:
            NSLog(@"GetDateNotification Received: Updating DateField");
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, MMM d, yyyy"];
            NSString *dateString = [dateFormatter stringFromDate:[notification object]];
            [dateField setText:dateString];
            [dateFormatter release];

            break;
        case 3:
            NSLog(@"PopOverShoudlUpdate Notification Recieved:Adding StartTimeField");
            //if (self.startTimeField.superview == nil){
            startTimeField = [[CustomTextField alloc] init];
            [startTimeField setFrame:CGRectMake(0, 95, 68, 40)];
            startTimeField.tag = 13;
            [startTimeField setPlaceholder:@"From:"];
            [self.view addSubview:startTimeField];
            [startTimeField setInputView:[inputObjects objectForKey:@"picker"]];
            [startTimeField setInputAccessoryView:[inputObjects objectForKey:@"toolbar"]];
            [startTimeField becomeFirstResponder];  
            break;
        
        case 4: 
            NSLog(@"PopOverShoudlUpdate Notification Recieved:Updating StartTimeField OR EndTimeField");
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"hh:mm a"];
            if ([startTimeField isFirstResponder]){
                NSString *timeString = [timeFormatter stringFromDate:[notification object]];
                [startTimeField setText:timeString];
            }
            else if ([endTimeField isFirstResponder]){
                NSString *timeString = [timeFormatter stringFromDate:[notification object]];
                [endTimeField setText:timeString];
            }
            [timeFormatter release];
            break;
            
        case 5:
            NSLog(@"PopOverShoudlUpdate Notification Recieved:Adding EndTimeField");
            if (self.endTimeField.superview == nil){
                endTimeField = [[CustomTextField alloc]init];
                [endTimeField setFrame:CGRectMake(72, 95, 68, 40)];
                endTimeField.tag = 14;
                [endTimeField setPlaceholder:@"Till:"];
                [self.view addSubview:endTimeField];
                [endTimeField setInputView:[inputObjects objectForKey:@"picker"]];
                [endTimeField setInputAccessoryView:[inputObjects objectForKey:@"toolbar"]];
                [endTimeField becomeFirstResponder]; 
                }
            break;
        case 6:
            NSLog(@"PopOverShoudlUpdate Notification Recieved:Adding RecurringField");
                recurringField = [[CustomTextField alloc] init];
                [self.view addSubview:recurringField];
                [recurringField setFrame:CGRectMake(0, 140, 140, 40)];
                recurringField.tag = 15;
                [recurringField setPlaceholder:@"Recurring: Never"];
                //[rightField setText:[recurring objectAtIndex:0]];   
                [recurringField setInputView:[inputObjects objectForKey:@"picker"]];
                [recurringField setInputAccessoryView:[inputObjects objectForKey:@"toolbar"]];
                [recurringField becomeFirstResponder];
            break;
        case 7:
            if ([recurringField isFirstResponder]) {
                Appointment *tempAppointment = [notification object]; 
                NSLog(@"TempAppointment.recurring = %@", tempAppointment.recurring);
                self.recurringField.text = tempAppointment.recurring;
                }
            break;    
            
        default:
            break;
 
            }
        }
@end
