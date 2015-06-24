//
//  Util.h
//  Gradient
//
//  Created by Jacky on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (Util*) sharedInstance;

- (void)drawLinearGradientWithContext:(CGContextRef)context inRect:(CGRect)rect withStartColor:(CGColorRef)startColor andEndColor:(CGColorRef)endColor;
- (float)calcDistanceWithPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2;

@end