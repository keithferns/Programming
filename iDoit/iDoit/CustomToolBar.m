//
//  CustomToolBar.m
//  iDoit
//
//  Created by Keith Fernandes on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomToolBar.h"
#import "Contants.h"
@implementation CustomToolBar

@synthesize firstButton, secondButton, fourthButton, thirdButton, fifthButton;

- (void)dealloc
{
    [super dealloc];
    
    [fifthButton release];
    [secondButton release];
    [thirdButton release];
    [firstButton release];
    [fourthButton release];
}


- (id)init{
    self = [super init];
    if (self) {
        NSLog(@"Creating tool bar");
        self.frame = CGRectMake(0, 0, kScreenWidth, 50);
        [self setBarStyle:UIBarStyleBlackTranslucent];
        //[self setTintColor:[UIColor colorWithRed:0.34 green:0.36 blue:0.42 alpha:0.3]];
        [self setTag:0];
        
        firstButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.firstButton setTitle:@"Save"];
        [self.firstButton setWidth:40.0];
        [self.firstButton setTag:1];
        [self.firstButton setEnabled:NO];
        [firstButton setAction:@selector(presentActionsPopover:)];
        
        secondButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clock_running.png"]style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.secondButton setTitle:@"Plan"];
        [self.secondButton setTag:2];
        [self.secondButton setWidth:40.0];
        [secondButton setAction:@selector(presentActionsPopover:)];
        
        thirdButton = [[UIBarButtonItem alloc] initWithImage:self.flipperImageForDateNavigationItem style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.thirdButton setTitle:@"Calendar"];
        [self.thirdButton setTag:3];
        [self.thirdButton setWidth:40.0];
        [thirdButton setAction:@selector(toggleCalendar:)];
        
        fourthButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"email_white.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.fourthButton setTitle:@"Send"];
        [self.fourthButton setWidth:40.0];
        [self.fourthButton setTag:4];
        [fourthButton setAction:@selector(presentActionsPopover:)];
        [self.fourthButton setEnabled:NO];

        
        fifthButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"keyboard_down.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.fifthButton setTitle:@"Drop"];
        [self.fifthButton setWidth:40.0];
        [self.fifthButton setTag:5];
        [fifthButton setAction:@selector(dismissKeyboard)];        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
        
        NSArray *items = [NSArray arrayWithObjects:flexSpace, firstButton, flexSpace, secondButton, flexSpace, thirdButton, flexSpace, fourthButton,flexSpace, fifthButton, flexSpace, nil];
        [self setItems:items];
        [flexSpace release];    
    }
    return self;
}

- (void) changeToSchedulingButtons{
    firstButton.image = [UIImage imageNamed:@"arrow_left_24.png"];
    firstButton.title = @"";
    firstButton.action = @selector(moveToPreviousField);
    
    secondButton.image = [UIImage imageNamed:@"arrow_right_24.png"];
    secondButton.title = @"";
    secondButton.action = @selector(moveToNextField);
    
    fourthButton.image = [UIImage imageNamed:@"alarm_24.png"];
    fourthButton.title = @"Remind";
    fourthButton.action = @selector(addReminders);
    
    fifthButton.image = [UIImage imageNamed:@"tag_24.png"];
    fifthButton.title = @"Tag";
    fifthButton.action = @selector(addTags);
}

- (void) changeToEditingButtons{
    firstButton.image = [UIImage imageNamed:@"save.png"];
    [self.firstButton setTitle:@"Save"];
    [self.firstButton setTag:1];
    [firstButton setAction:@selector(presentActionsPopover:)];
    
    secondButton.image = [UIImage imageNamed:@"clock_running.png"];
    [self.secondButton setTitle:@"Plan"];
    [self.secondButton setTag:2];
    [secondButton setAction:@selector(presentActionsPopover:)];
    [secondButton setEnabled:YES];
    
    fourthButton.image = [UIImage imageNamed:@"email_white.png"];
    [self.fourthButton setTitle:@"Send"];
    [self.fourthButton setTag:4];
    [fourthButton setAction:@selector(presentActionsPopover:)];
    
    fifthButton.image = [UIImage imageNamed:@"keyboard_down.png"];
    [self.fifthButton setTitle:@"Drop"];
    [self.fifthButton setTag:5];
    [fifthButton setAction:@selector(dismissKeyboard)];
}

- (UIImage *)flipperImageForDateNavigationItem {
	// returns a 30 x 30 image to display the flipper button in the navigation bar
	CGSize itemSize=CGSizeMake(30.0,30.0);
	UIGraphicsBeginImageContext(itemSize);
	UIImage *backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"calendar_date_background.png"]];
	CGRect calendarRectangle = CGRectMake(0,0, itemSize.width, itemSize.height);
	[backgroundImage drawInRect:calendarRectangle];
    // draw the element name
	[[UIColor whiteColor] set];
    // draw the date 
    NSDateFormatter *imageDateFormatter = [[NSDateFormatter alloc] init];
    [imageDateFormatter setDateFormat:@"d"];
    UIFont *font = [UIFont boldSystemFontOfSize:7];
	//CGPoint point = CGPointMake(1,1);
    CGSize stringSize = [[imageDateFormatter stringFromDate:[NSDate date]] sizeWithFont:font];
    CGPoint point = CGPointMake((calendarRectangle.size.width-stringSize.width)/2+5,16);    
	[[imageDateFormatter stringFromDate:[NSDate date]] drawAtPoint:point withFont:font];
    // draw the month    
    [imageDateFormatter setDateFormat:@"MMM"];
	font = [UIFont boldSystemFontOfSize:8];
    stringSize = [[imageDateFormatter stringFromDate:[NSDate date]] sizeWithFont:font];
    point = CGPointMake((calendarRectangle.size.width-stringSize.width)/2,9);
    NSLog(@"date is %@",[imageDateFormatter stringFromDate:[NSDate date]]);
	[[imageDateFormatter stringFromDate:[NSDate date]] drawAtPoint:point withFont:font];
    [imageDateFormatter release];
	UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}


@end

/*
 - (void) toggleDateButton:(id)sender {//Toggle  Save --> Schedule AND NOT Save --> Save
 if (firstButton.title == @"Save" && [sender tag] == 16) {//Change from Save to Schedule
 firstButton.image = [UIImage imageNamed:@"calendar_24.png"];
 firstButton.title = @"Set Date";
 firstButton.action = @selector(setAppointmentDate:);
 firstButton.tag = 11;
 
 secondButton.title = @"Remind";
 secondButton.image = [UIImage imageNamed:@"alarm_24.png"];
 secondButton.action = @selector(setRecurring);
 }
 else {//Change back to Save
 firstButton.image = [UIImage imageNamed:@"save.png"];
 firstButton.title = @"Save";
 firstButton.action = @selector(saveMemo:);
 firstButton.tag = 1;
 
 secondButton.image = [UIImage imageNamed:@"clock_running.png"];
 secondButton.title = @"Plan";
 secondButton.action = @selector(presentActionsPopover:);
 secondButton.tag = 2;
 }
 }
 
 - (void) toggleStartButton:(id)sender {
 [firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
 [firstButton setAction:@selector(setStartTime:)];
 [firstButton setTitle:@"Start Time"];
 firstButton.tag = 12;
 }
 
 - (void)toggleEndButton:(id)sender  {
 [firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
 [firstButton setAction:@selector(setEndTime:)];
 [firstButton setTitle:@"End Time"];   
 firstButton.tag = 13;
 
 }
 - (void) toggleRecurButton:(id)sender {
 [firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
 [firstButton setAction:@selector(setRecurrance:)];
 [firstButton setTitle:@"Recurring"];   
 [firstButton setTag:4];
 }
 */
