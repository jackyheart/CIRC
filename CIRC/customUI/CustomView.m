//
//  CustomView.m
//  Gradient
//
//  Created by Jacky on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomView.h"
#import "Util.h"

@implementation CustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    
    if (self == [super initWithCoder: decoder]) {
        
        //do initialization and custom font
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *startColor = [UIColor colorWithRed:105.0f/255.0f green:179.0f/255.0f blue:216.0f/255.0f alpha:1.0];
    UIColor *endColor = [UIColor colorWithRed:21.0/255.0 green:92.0/255.0 blue:136.0/255.0 alpha:1.0];  
    
    [[Util sharedInstance] drawLinearGradientWithContext:context inRect:self.bounds withStartColor:startColor.CGColor andEndColor:endColor.CGColor];
    
    BOOL IS_GLOSSY = NO;
    
    if(IS_GLOSSY)
    {
        CGColorRef glossColor1 = [UIColor colorWithRed:1.0 green:1.0 
                                                  blue:1.0 alpha:0.35].CGColor;
        CGColorRef glossColor2 = [UIColor colorWithRed:1.0 green:1.0 
                                                  blue:1.0 alpha:0.1].CGColor;
        
        CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, 
                                    rect.size.width, rect.size.height/2);
        
        [[Util sharedInstance] drawLinearGradientWithContext:context inRect:topHalf withStartColor:glossColor1 andEndColor:glossColor2];  
    }
}

- (void)dealloc
{
    [super dealloc];
}


- (void)updateView
{
    [self setNeedsDisplay];
}

@end
