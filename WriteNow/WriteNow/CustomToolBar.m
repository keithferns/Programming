//
//  CustomToolBar.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomToolBar.h"


@implementation CustomToolBar
@synthesize backButton, dismissKeyboard, datetimeButton, alarmButton, recurrenceButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Creating tool bar");
        [self setBarStyle:UIBarStyleDefault];
        [self setTintColor:[UIColor colorWithRed:0.34 green:0.36 blue:0.42 alpha:0.3]];
        [self setTag:0];
        
        backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left_24.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [backButton setTitle:@"Back"];
        [backButton setWidth:50.0];
        [backButton setTag:0];    
        
         datetimeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar_24.png"]style:UIBarButtonItemStylePlain target:nil action:nil];
        [datetimeButton setTitle:@"Set Date"];
        [datetimeButton setTag:1];
        [datetimeButton setWidth:50.0];
        
        recurrenceButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_circle_left_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setRecurring)];
        [recurrenceButton setTitle:@"Repeat"];
        [recurrenceButton setWidth:50.0];
        [recurrenceButton setTag:3];
        
        alarmButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"alarm_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setAlarm)];
        [alarmButton setTitle:@"Remind"];
        [alarmButton setWidth:50.0];
        [alarmButton setTag:2];
        
        dismissKeyboard = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"keyboard_down.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [dismissKeyboard setTitle:@"Input Down"];

        [dismissKeyboard setWidth:50.0];
        [dismissKeyboard setTag:4];
        
        //UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //Possible to use this with the initWithCustomView method of  UIBarButtonItems
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
        
        NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects: backButton, flexSpace, datetimeButton, flexSpace,alarmButton, flexSpace, recurrenceButton,flexSpace,dismissKeyboard, nil];
        [self setItems:toolbarItems];
        [backButton release];
        [datetimeButton release];
        [alarmButton release];
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
