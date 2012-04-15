//
//  CustomTextView.m
//  iDoit
//
//  Created by Keith Fernandes on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "CustomTextView.h"

@implementation CustomTextView

@synthesize isEditing;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];

    if (self) {
      
        self.textColor = [UIColor whiteColor];
        self.showsVerticalScrollIndicator = YES;
        UIImage *patternImage = [UIImage imageNamed:@"54700.png"];
        
        //UIImage *patternImage = [UIImage imageNamed:@"textview_background.png"];
        [self.layer setBackgroundColor:[UIColor colorWithPatternImage:patternImage].CGColor];
        self.layer.cornerRadius = 5.0;
        
        [self setFont:[UIFont systemFontOfSize:18]];
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
    }
    
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
