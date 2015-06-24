//
//  LabelScoreDisplay.m
//  CIRC
//
//  Created by Jacky on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Util.h"
#import "LabelScoreDisplay.h"

@interface LabelScoreDisplay (private)

- (UIImage *)gradientImageWithStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor withGlossy:(BOOL)isGlossy;

@end

@implementation LabelScoreDisplay

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        //do initialization and custom font
        
        UIFont *font = [UIFont fontWithName:@"BadaBoom BB" size:self.font.pointSize];
        [self setFont:font];
        
        //blueish gradient
        UIColor *startGradientColor = [UIColor colorWithRed:105.0f/255.0f green:179.0f/255.0f blue:216.0f/255.0f alpha:1.0];
        UIColor *endGradientColor = [UIColor colorWithRed:21.0/255.0 green:92.0/255.0 blue:136.0/255.0 alpha:1.0];      
        
        //== set gradient
        /*
        UIImage *gradientImage = [self gradientImageWithStartColor:startGradientColor andEndColor:endGradientColor withGlossy:YES];
        UIColor *gradientColor = [UIColor colorWithPatternImage:gradientImage];
        
        self.textColor = gradientColor;*/
        
        [self updateTitleColorGradientWithStartColor:startGradientColor andEndColor:endGradientColor withGlossy:NO];
    }
    
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    //self.textColor = [UIColor colorWithPatternImage:[self gradientImage]];
    
    //must be called after the customization
    [super drawTextInRect:rect];
}

- (void)updateTitleColorGradientWithStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor withGlossy:(BOOL)isGlossy
{
    UIImage *gradientImage = [self gradientImageWithStartColor:startColor andEndColor:endColor withGlossy:isGlossy];
    UIColor *gradientColor = [UIColor colorWithPatternImage:gradientImage];
    
    self.textColor = gradientColor;    
    
    //CGRect rect = self.bounds;
    //[super drawTextInRect:rect];
}

#pragma mark - private methods implementation


- (UIImage *)gradientImageWithStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor withGlossy:(BOOL)isGlossy
{
    CGSize textSize = [self.text sizeWithFont:self.font];
    CGFloat width = textSize.width;         // max 1024 due to Core Graphics limitations
    CGFloat height = textSize.height;       // max 1024 due to Core Graphics limitations
    
    // create a new bitmap image context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    
    //=== start current graphics context
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // push context to make it current (need to do this manually because we are not drawing in a UIView)
    UIGraphicsPushContext(context);   
    
    
    CGColorRef startColorCG = startColor.CGColor;
    CGColorRef endColorCG = endColor.CGColor;
    
    
    // drawLinearGradient(context, self.bounds, startColor, endColor);
    
    [[Util sharedInstance] drawLinearGradientWithContext:context inRect:self.bounds withStartColor:startColorCG andEndColor:endColorCG];
    
    
    if(isGlossy)
    {
        CGColorRef glossColor1 = [UIColor colorWithRed:1.0 green:1.0 
                                                  blue:1.0 alpha:0.35].CGColor;
        CGColorRef glossColor2 = [UIColor colorWithRed:1.0 green:1.0 
                                                  blue:1.0 alpha:0.1].CGColor;
        
        
        CGRect rect = self.bounds;
        CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, 
                                    rect.size.width, rect.size.height/2);
        
        // drawLinearGradient(context, topHalf, glossColor1, glossColor2);   
        
        [[Util sharedInstance] drawLinearGradientWithContext:context inRect:topHalf withStartColor:glossColor1 andEndColor:glossColor2];
    }    
    
    
    // pop context 
    UIGraphicsPopContext();    
    
    //=== end current graphics context
    
    
    // get a UIImage from the image context
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    return  gradientImage;    
}


@end
