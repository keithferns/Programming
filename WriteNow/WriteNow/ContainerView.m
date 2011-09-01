//
//  ContainerView.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContainerView.h"


@implementation ContainerView
@synthesize label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
        
        //[containerView.layer setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor].CGColor];
        
        //LABEL
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        [label  setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setFont:[UIFont fontWithName:@"Georgia-BoldItalic" size:18]];
        [label setTextColor:[UIColor lightTextColor]];
        [self addSubview:label];
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
    [label release];
}

@end
