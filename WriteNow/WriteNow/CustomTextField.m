//
//  CustomTextField.m
//  WriteNow
//
//  Created by Keith Fernandes on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTextField.h"


@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBorderStyle:UITextBorderStyleRoundedRect];
        [self setPlaceholder:@"Tap to Type:"];
        [self setInputView:nil];
        [self setInputAccessoryView:nil];
        [self setDelegate:nil];
        [self setFont:[UIFont systemFontOfSize:13.0]];
        [self setTag:0];
        [self setTextAlignment:UITextAlignmentCenter];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self setEnabled:YES];
        [self setHidden:NO];
        //[self setBounds:CGRectMake(self.frame.origin.x+2, self.frame.origin.y+2, self.frame.size.width-4,self.frame.size.height-4)];
        
    }
    return self;

}

- (void)dealloc
{
    [super dealloc];
}

@end
