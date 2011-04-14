//
//  NavButton.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NavButton.h"


@implementation NavButton


- (id) init
{
    if ( self = [super init] )
    {
		self = [UIButton buttonWithType:UIButtonTypeCustom];
		[self addTarget:self 
				   action:@selector(aMethod:)
		 forControlEvents:UIControlEventTouchDown];
		[self setUserInteractionEnabled:YES];
		[self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		[self setHighlighted:YES];
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


@end
