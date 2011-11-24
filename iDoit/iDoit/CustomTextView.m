//
//  CustomTextView.m
//  iDoit
//
//  Created by Keith Fernandes on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "CustomTextView.h"

@implementation CustomTextView


- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];

    if (self) {
        self.textColor = [UIColor lightTextColor];
        self.font = [UIFont systemFontOfSize:15];
        self.showsVerticalScrollIndicator = YES;
        
        UIImage *patternImage = [UIImage imageNamed:@"textview_background.png"];
        [self.layer setBackgroundColor:[UIColor colorWithPatternImage:patternImage].CGColor];
        self.layer.cornerRadius = 5.0;
        
    }
    
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
