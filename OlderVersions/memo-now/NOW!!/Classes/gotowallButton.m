//
//  gotowallButton.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

//

#import "gotowallButton.h"


@implementation gotowallButton

/*Sample Customization...
 
UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(54, 15, 24, 24)];
[button addTarget:self action:@selector(prevButtonClick:) forControlEvents:UIControlEventTouchUpInside];
[self addSubview:button];
*/

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:(frame)];
    if (self) {
		[self setFrame:CGRectMake(54, 15, 106, 30)];
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
