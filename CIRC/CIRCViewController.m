//
//  CIRCViewController.m
//  CIRC
//
//  Created by Jacky on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CIRCViewController.h"
#import "Util.h"

#define SCORE_VALUE 10
#define kUpdateFrequency	60.0

@implementation CIRCViewController
@synthesize theShipView;
@synthesize steerWheelImgView;
@synthesize ropeImgView;
@synthesize fishContainerView;
@synthesize scoreDisplayLbl;
@synthesize scoreValueLbl;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // gesture
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.steerWheelImgView addGestureRecognizer:panRecognizer];
    [panRecognizer release];
    
    // set alpha
    int i=0;
    for(UIView *fishView in self.fishContainerView.subviews)
    {
        fishView.alpha = 0.5;
        fishView.tag = i;//tag the fish
        
        i++;
    }
    
    // configure score value
    self.scoreValueLbl.text = [NSString stringWithFormat:@"+%d", SCORE_VALUE];
    self.scoreValueLbl.alpha = 0.0;
    
    // configure accelerometer
  	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / kUpdateFrequency];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];  
    
    //set variable
    CURRENT_SCORE = 0;
}


- (void)viewDidUnload
{
    [self setTheShipView:nil];
    [self setSteerWheelImgView:nil];
    [self setRopeImgView:nil];
    [self setFishContainerView:nil];
    [self setScoreDisplayLbl:nil];
    [self setScoreValueLbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)dealloc {
    [theShipView release];
    [steerWheelImgView release];
    [ropeImgView release];
    [fishContainerView release];
    [scoreDisplayLbl release];
    [scoreValueLbl release];
    [super dealloc];
}

#pragma mark - gesture handlers

CGPoint lastTouchPoint;

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    CGPoint STEER_WHEEL_CENTER_POINT = self.steerWheelImgView.center;
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        lastTouchPoint = touchPoint;
    }
    
    float distance = [[Util sharedInstance] calcDistanceWithPoint1:STEER_WHEEL_CENTER_POINT andPoint2:touchPoint];
    
    if(distance <= self.steerWheelImgView.frame.size.width * 0.5)
    {
        float fromAngle = atan2f(lastTouchPoint.y - STEER_WHEEL_CENTER_POINT.y, 
                                 lastTouchPoint.x - STEER_WHEEL_CENTER_POINT.x);
        
        float toAngle = atan2f(touchPoint.y - STEER_WHEEL_CENTER_POINT.y, 
                               touchPoint.x - STEER_WHEEL_CENTER_POINT.x);
        
        float newAngle = toAngle - fromAngle;
        
        float ropeIncrementFactor = 0.0;
        
        if(newAngle < 0)
        {
            //rotating left
            ropeIncrementFactor = 2.5;
        }
        else if(newAngle > 0)
        {
            ropeIncrementFactor = -2.5;
        }
    
        //update rope
        if(self.ropeImgView.frame.size.height >= 5)
        {
            self.ropeImgView.frame = CGRectMake(self.ropeImgView.frame.origin.x, 
                                                self.ropeImgView.frame.origin.y, 
                                                self.ropeImgView.frame.size.width, 
                                                self.ropeImgView.frame.size.height + ropeIncrementFactor);
        }
        else if(self.ropeImgView.frame.size.height < 5)
        {
            self.ropeImgView.frame = CGRectMake(self.ropeImgView.frame.origin.x, 
                                                self.ropeImgView.frame.origin.y, 
                                                self.ropeImgView.frame.size.width, 
                                                5);        
        }
        
        
        CGPoint ropeEndPoint = CGPointMake(self.ropeImgView.frame.origin.x, 
                                           self.ropeImgView.frame.origin.y + self.ropeImgView.frame.size.height);
        
        CGPoint convertedRopeEnd = [self.view convertPoint:ropeEndPoint toView:self.fishContainerView];
        
        //check intersection with fishes
        for(UIView *fishView in self.fishContainerView.subviews)
        {
            if(CGRectContainsPoint(fishView.frame, convertedRopeEnd))
            {
                fishView.alpha = 1.0;
                fishView.center = convertedRopeEnd;
                
                if(self.ropeImgView.frame.size.height < 5)
                {
                    self.scoreValueLbl.alpha = 1.0;
                    self.scoreValueLbl.center = CGPointMake(self.theShipView.frame.origin.x - 20, 
                                                            self.theShipView.frame.origin.y + self.theShipView.frame.size.height * 0.5);
                    
                    CURRENT_SCORE += SCORE_VALUE;
                    self.scoreDisplayLbl.text = [NSString stringWithFormat:@"%@: %d", 
                                                 NSLocalizedString(@"SCORE", @""),
                                                 CURRENT_SCORE];
                    
                    
                    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^(void) {
                        
                        fishView.alpha = 0.0;
                        
                        self.scoreValueLbl.alpha = 0.0;
                        self.scoreValueLbl.frame = CGRectOffset(self.scoreValueLbl.frame, 0.0, -20.0);
                        
                    } completion:^(BOOL finished) {
                        
                        [fishView removeFromSuperview];
                        
                    }];
                }
            }
            else
            {
                fishView.alpha = 0.5;
            }
        }
        
        
        //rotate the wheel
        self.steerWheelImgView.transform = CGAffineTransformRotate(self.steerWheelImgView.transform, newAngle);
    }
    
    lastTouchPoint = touchPoint;
}


#pragma mark - UIAccelerometer delegate

float movementOffset = 3.0;

// UIAccelerometerDelegate method, called when the device accelerates.
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    NSLog(@"accel: (%f, %f, %f)", acceleration.x, acceleration.y, acceleration.z);
    
    if(acceleration.y > 0.15)
    {
        //positive: moving to the left
        
        float newOriginX = self.theShipView.frame.origin.x + movementOffset * movementOffset * acceleration.y;
        
        //NSLog(@"product: %f", movementOffset * acceleration.y);
        
        if(newOriginX + self.theShipView.frame.size.width < 1024)
        {
            self.theShipView.frame = CGRectMake(newOriginX, 
                                                self.theShipView.frame.origin.y, 
                                                self.theShipView.frame.size.width, 
                                                self.theShipView.frame.size.height);    
            
            self.ropeImgView.frame = CGRectMake(self.theShipView.frame.origin.x + 46.0, 
                                                self.theShipView.frame.origin.y + 118.0, 
                                                self.ropeImgView.frame.size.width, 
                                                self.ropeImgView.frame.size.height);
        }
        
        /*
        if(newOriginX > 0)
        {
            self.theShipView.frame = CGRectMake(newOriginX, 
                                                self.theShipView.frame.origin.y, 
                                                self.theShipView.frame.size.width, 
                                                self.theShipView.frame.size.height);
                        
            self.ropeImgView.frame = CGRectMake(self.theShipView.frame.origin.x + 46.0, 
                                                self.theShipView.frame.origin.y + 118.0, 
                                                self.ropeImgView.frame.size.width, 
                                                self.ropeImgView.frame.size.height);
        }
         */
    }
    else if(acceleration.y < -0.15)
    {
        float newOriginX = self.theShipView.frame.origin.x + movementOffset * movementOffset * acceleration.y;
        
        if(newOriginX > 0)
        {
            self.theShipView.frame = CGRectMake(newOriginX, 
                                                self.theShipView.frame.origin.y, 
                                                self.theShipView.frame.size.width, 
                                                self.theShipView.frame.size.height);
            
            self.ropeImgView.frame = CGRectMake(self.theShipView.frame.origin.x + 46.0, 
                                                self.theShipView.frame.origin.y + 118.0, 
                                                self.ropeImgView.frame.size.width, 
                                                self.ropeImgView.frame.size.height);
        }  
        
        /*
        if(newOriginX + self.theShipView.frame.size.width < 1024)
        {
            self.theShipView.frame = CGRectMake(newOriginX, 
                                                self.theShipView.frame.origin.y, 
                                                self.theShipView.frame.size.width, 
                                                self.theShipView.frame.size.height);    
            
            self.ropeImgView.frame = CGRectMake(self.theShipView.frame.origin.x + 46.0, 
                                                self.theShipView.frame.origin.y + 118.0, 
                                                self.ropeImgView.frame.size.width, 
                                                self.ropeImgView.frame.size.height);
        }
         */
    }
}


@end
