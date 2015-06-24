//
//  Util.m
//  Gradient
//
//  Created by Jacky on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Util.h"

static Util *_instance;

@implementation Util

+ (Util*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];
            
            // Allocate/initialize any member variables of the singleton class here
            // example
			//_instance.member = @"";
            
        }
    }
    return _instance;
}

- (void)dealloc
{
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}

- (void)drawLinearGradientWithContext:(CGContextRef)context inRect:(CGRect)rect withStartColor:(CGColorRef)startColor andEndColor:(CGColorRef)endColor
{
    //there's corresponding 'release' (CGColorSpaceRelease) for each 'create' (CGColorSpaceCreateDeviceRGB)
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
    
    //there's corresponding 'release' (CGGradientRelease) for each 'create' (CGGradientCreateWithColors)
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    //there's a corresponding CGContextRestoreGState to the CGContextSaveGState
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);    
}

- (float)calcDistanceWithPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2
{
    float dist = 0.0;
    
    float x2Minx1 = point2.x - point1.x;
    float y2Miny1 = point2.y - point1.y;
    
    dist = sqrtf(x2Minx1 * x2Minx1 + y2Miny1 * y2Miny1);
    
    return dist;    
}

@end
