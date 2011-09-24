//
//  NavButton.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SegmentedControl.h"


@implementation SegmentedControl

@synthesize momentary, segmentedControlStyle, tintColor;


-(IBAction) segmentedControlAction:(id)sender{
	switch (self.segmentedControl.selectedSegmentIndex) {
		case 0:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		case 1:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		case 2:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		default:
			break;
	}
}



- (id) init
{
    if ( self = [super init] )
    {
		[self setSegmentedControlStyle:UISegmentedControlStyleBezeled];
		[self isMomentary:YES];
		[self setTintColor:[UIColor blueColor];
	
    }
		 
    return self;
}


- (void)dealloc {
	
    [super dealloc];
}

@end



/* ATTEMPTED adding custom buttons
 self = [UIButton buttonWithType:UIButtonTypeCustom];
 [self addTarget:self 
 action:@selector(aMethod:)
 forControlEvents:UIControlEventTouchDown];
 [self setUserInteractionEnabled:YES];
 [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
 [self setHighlighted:YES];
 */