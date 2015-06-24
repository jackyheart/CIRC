//
//  LabelScoreDisplay.h
//  CIRC
//
//  Created by Jacky on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabelScoreDisplay : UILabel

- (void)updateTitleColorGradientWithStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor withGlossy:(BOOL)isGlossy;

@end
