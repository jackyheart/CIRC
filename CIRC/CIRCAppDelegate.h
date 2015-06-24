//
//  CIRCAppDelegate.h
//  CIRC
//
//  Created by Jacky on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CIRCViewController;

@interface CIRCAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CIRCViewController *viewController;

@end
