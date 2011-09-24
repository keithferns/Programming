//
//  CustomBaseView.m
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomBaseView.h"


@implementation CustomBaseView


- (id)initWithFrame:(CGRect)frame {
    
	CGRect myframe = CGRectMake(0, 0, 320, 460);
    self = [super initWithFrame:myframe];
    if (self) {
		
		
		[self setBackgroundColor:[UIColor blueColor]];
		
			//initialize the topView and add it to the main view
		CGRect topFrame = CGRectMake(0, 0, 320, 204);
		UIView	*topView = [[[UIView alloc] initWithFrame:topFrame] autorelease];
		UIImageView *linedBackground = [[UIImageView alloc] initWithFrame:topFrame];
		[linedBackground setImage:[UIImage imageNamed:@"lined_paper_320x200.png"]];
		[self setUserInteractionEnabled:YES];
		[self addSubview:topView];
		[topView addSubview:linedBackground];
			//add a textView to the top view
		CGRect textViewFrame = CGRectMake(0, 30, 320, 170);
		UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
		[topView addSubview:textView];
		[textView setOpaque:YES];
		[textView setAlpha:0];
		[textView setEditable:YES];
		[textView setText:@"is this working"];
		
		CGRect bottomFrame = CGRectMake(0, 220, 320, 220);
		UIView *bottomView = [[[UIView	alloc] initWithFrame:bottomFrame]autorelease];
		[self addSubview:bottomView];
		CGRect textFieldFrame = CGRectMake(0, 40, 320, 180);
		UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
		[textField setBorderStyle:UITextBorderStyleRoundedRect];
		[bottomView addSubview:textField];
			

	}
    return self;
}
									   
							   

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
