//
//  CustomToolBarMainView.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomToolBarMainView.h"


@implementation CustomToolBarMainView

@synthesize actionButton, memoButton, taskButton, appointmentButton, dismissKeyboard;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Creating tool bar");
        [self setBarStyle:UIBarStyleDefault];
        [self setTintColor:[UIColor colorWithRed:0.34 green:0.36 blue:0.42 alpha:0.3]];
        [self setTag:0];

        
        actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
        [self.actionButton setWidth:50.0];
        [self.actionButton setTag:0];
        self.actionButton.title = @"Do";
        
        memoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save_document.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.memoButton setTitle:@"Note"];
        [self.memoButton setWidth:50.0];
        [self.memoButton setTag:1];
        
        appointmentButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clock_running.png"]style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.appointmentButton setTitle:@"Appointment"];
        [self.appointmentButton setTag:2];
        [self.appointmentButton setWidth:50.0];
        
        taskButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"document_todo.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.taskButton setTitle:@"To Do"];
        [self.taskButton setWidth:50.0];
        [self.taskButton setTag:3];
        
        dismissKeyboard = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"keyboard_down.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.dismissKeyboard setTitle:@"Down Input"];
        [self.taskButton setWidth:50.0];
        [self.taskButton setTag:4];
        
        //UIBarButtonItem *folderButton = [[UIBarButtonItem alloc] initWithTitle:@"Folder" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewMemo)];
        
        //UIBarButtonItem *folderButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(addNewFolder)];
        //[folderButton setTitle:@"Folder"];
        //[folderButton setTag:0];
        //[folderButton setWidth:50.0];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
        
        NSArray *items = [NSArray arrayWithObjects:flexSpace, actionButton, flexSpace, memoButton, flexSpace, appointmentButton, flexSpace, taskButton,flexSpace, dismissKeyboard, flexSpace, nil];
        [self setItems:items];
        

        [flexSpace release];    
        
        // After setting the accessory view for the text view, we no longer need a reference to the accessory view.
        //self.myToolBar = nil; //kjf NOTE: this line actually causes a crash.        
    }
    return self;
}



- (void)dealloc
{
    [super dealloc];
    
    [dismissKeyboard release];
    [memoButton release];
    [appointmentButton release];
    [actionButton release];
    [taskButton release];
}

@end
