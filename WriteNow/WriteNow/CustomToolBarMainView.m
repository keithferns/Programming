//
//  CustomToolBarMainView.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomToolBarMainView.h"


@implementation CustomToolBarMainView
@synthesize firstButton, secondButton, fourthButton, thirdButton, dismissKeyboard;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Creating tool bar");
        [self setBarStyle:UIBarStyleDefault];
        [self setTintColor:[UIColor colorWithRed:0.34 green:0.36 blue:0.42 alpha:0.3]];
        [self setTag:0];
        
        
        firstButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.firstButton setTitle:@"Save"];
        [self.firstButton setWidth:60.0];
        [self.firstButton setTag:1];
        [firstButton setAction:@selector(presentActionsPopover:)];

        
        secondButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clock_running.png"]style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.secondButton setTitle:@"Plan"];
        [self.secondButton setTag:2];
        [self.secondButton setWidth:60.0];
        [secondButton setAction: @selector(presentActionsPopover:)];

        
        thirdButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"12-eye.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        self.thirdButton.title = @"View";
        [self.thirdButton setWidth:60.0];
        [self.thirdButton setTag:3];
        [thirdButton setAction:@selector(presentActionsPopover:)];

        fourthButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"email.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.fourthButton setTitle:@"Send"];
        [self.fourthButton setWidth:60.0];
        [self.fourthButton setTag:4];
        [fourthButton setAction:@selector(presentActionsPopover:)];

        dismissKeyboard = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"keyboard_down.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.dismissKeyboard setTitle:@"Drop"];
        [self.fourthButton setWidth:60.0];
        [self.fourthButton setTag:5];
        [dismissKeyboard setAction:@selector(dismissKeyboard)];

        
        //UIBarButtonItem *folderButton = [[UIBarButtonItem alloc] initWithTitle:@"Folder" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewMemo)];
        
        //UIBarButtonItem *folderButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(addNewFolder)];
        //[folderButton setTitle:@"Folder"];
        //[folderButton setTag:0];
        //[folderButton setWidth:50.0];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
        
        NSArray *items = [NSArray arrayWithObjects:flexSpace, firstButton, flexSpace, secondButton, flexSpace, thirdButton, flexSpace, fourthButton,flexSpace, dismissKeyboard, flexSpace, nil];
        [self setItems:items];
        
        [flexSpace release];    
        
        // After setting the accessory view for the text view, we no longer need a reference to the accessory view.
        //self.myToolBar = nil; //kjf NOTE: this line actually causes a crash.        
    }
    return self;
}

- (void) toggleSaveAndSetDate {//Toggle  Save --> Schedule AND NOT Save --> Save
    if (firstButton.title == @"Save") {//Change from Save to Schedule
        firstButton.image = [UIImage imageNamed:@"calendar_24.png"];
        firstButton.title = @"Set Date";
        firstButton.action = @selector(setAppointmentDate:);

        }
    else {//Change back to Save
        firstButton.image = [UIImage imageNamed:@"save.png"];
        firstButton.title = @"Save";
        firstButton.action = @selector(saveMemo:);
        }
}

- (void) toggleSetDateAndSetStart{
    [firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
    [firstButton setAction:@selector(setStartTime:)];
    [firstButton setTitle:@"Start Time"];   
}

- (void) toggleSetStartAndSetEnd{
    [firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
    [firstButton setAction:@selector(setEndTime:)];
    [firstButton setTitle:@"End Time"];   
}
- (void)dealloc
{
    [super dealloc];
    
    [dismissKeyboard release];
    [secondButton release];
    [thirdButton release];
    [firstButton release];
    [fourthButton release];
}

@end
