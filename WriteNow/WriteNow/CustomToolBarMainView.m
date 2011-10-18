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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Creating tool bar");
        [self setBarStyle:UIBarStyleDefault];
        [self setTintColor:[UIColor colorWithRed:0.34 green:0.36 blue:0.42 alpha:0.3]];
        [self setTag:0];
        
        
        //firstButton = [[UIBarButtonItem alloc] initWithTitle:@"Save ^" style:UIBarButtonItemStyleBordered target:nil action:nil];
        firstButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.firstButton setTitle:@"Save"];
        [self.firstButton setWidth:60.0];
        [self.firstButton setTag:1];
        
        //secondButton = [[UIBarButtonItem alloc] initWithTitle:@"Plan ^" style:UIBarButtonItemStyleBordered target:nil action:nil];
        secondButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clock_running.png"]style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.secondButton setTitle:@"Plan"];
        [self.secondButton setTag:2];
        [self.secondButton setWidth:60.0];
        
        
        //thirdButton  = [[UIBarButtonItem alloc] initWithTitle:@"View" style:UIBarButtonItemStyleBordered target:nil action:nil];
        thirdButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"12-eye.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        self.thirdButton.title = @"View";
        [self.thirdButton setWidth:60.0];
        [self.thirdButton setTag:3];
        
        //fourthButton = [[UIBarButtonItem alloc] initWithTitle:@"Send ^" style:UIBarButtonItemStyleBordered target:nil action:nil];
        fourthButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"email.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.fourthButton setTitle:@"Send"];
        [self.fourthButton setWidth:60.0];
        [self.fourthButton setTag:4];
        
        dismissKeyboard = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"keyboard_down.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.dismissKeyboard setTitle:@"Drop"];
        [self.fourthButton setWidth:60.0];
        [self.fourthButton setTag:5];
        
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
