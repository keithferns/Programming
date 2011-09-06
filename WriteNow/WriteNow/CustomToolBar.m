//
//  CustomToolBar.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomToolBar.h"


@implementation CustomToolBar
@synthesize firstButton, secondButton, thirdButton, fourthButton, dismissKeyboard;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Creating tool bar");
        [self setBarStyle:UIBarStyleDefault];
        [self setTintColor:[UIColor colorWithRed:0.34 green:0.36 blue:0.42 alpha:0.3]];
        [self setTag:0];
        
     
        //MOST USED BUTTON AT THE ENDS OF THE TOOLBAR
         firstButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar_24.png"]style:UIBarButtonItemStylePlain target:nil action:nil];
        [firstButton setTitle:@"Set Date"];
        [firstButton setWidth:50.0];
        [firstButton setTag:1];
        
        
        //CONNNECT TO ACTION SHEET WITH REPEAT, REMIND, DEFINE. FOR each have picker wheel with limited options. DEFINE: BILL PAY, ANNUAL (Birthday, Anniversary)
        secondButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"remind_repeat.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setRecurring)];
        [secondButton setTitle:@"Remind"];
        [secondButton setWidth:50.0];
        [secondButton setTag:2];
        
        //LEAST USED BUTTON IN CENTER BUT IS ALSO FOCAL TO PURPOSE OF SCREEN
        thirdButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clock_running.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [thirdButton setTitle:@"Appointment"];
        [thirdButton setWidth:50.0];
        [thirdButton setTag:3];   
        
        
        //THIS BUTTON COULD CONTROL THE TABLE/CALENDAY VIEWS. CHOICES: LIST OF APPOINTMENTS AND TASKS SORTED BY DATE or CALENDAR BY DAY, WEEK OR MONTH
        /* Toggle between 
         (a) See Tasks/Appointments in List. Scenario: if the user is in editing mode and wants to see existing appointments, they can click this. 
         (b) See Calendar Month
         (c) See Calendar Week
         (d) See Calendar Day/List for Day
         (e) See Nothing.
         
         QUESTION: IF NOT IN EDITING MODE, HOW WILL THE USER TOGGLE BETWEEN THESE OPTIONS. REMEMBER THERE IS NO TOOLBAR.
         */
        fourthButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"12-eye"] style:UIBarButtonItemStylePlain target:self action:@selector(setAlarm)];
        [fourthButton setTitle:@"See List"];
        [fourthButton setWidth:50.0];
        [fourthButton setTag:4];
        
        dismissKeyboard = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"keyboard_down.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [dismissKeyboard setTitle:@"Input Down"];

        [dismissKeyboard setWidth:50.0];
        [dismissKeyboard setTag:5];
        
  
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
        
        NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects: firstButton, flexSpace, secondButton, flexSpace,thirdButton, flexSpace, fourthButton,flexSpace,dismissKeyboard, nil];
        [self setItems:toolbarItems];
        [firstButton release];
        [secondButton release];
        [thirdButton release];
        [fourthButton release];
        [dismissKeyboard release];
        [flexSpace release];
        /*--End Setting up the Toolbar */
        
    }
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
