//
//  CIRCViewController.h
//  CIRC
//
//  Created by Jacky on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIRCViewController : UIViewController <UIAccelerometerDelegate> {
    UIView *theShipView;
    UIImageView *steerWheelImgView;
    UIImageView *ropeImgView;
    UIView *fishContainerView;
    UILabel *scoreDisplayLbl;
    UILabel *scoreValueLbl;
    
@private
    int CURRENT_SCORE;
}

@property (nonatomic, retain) IBOutlet UIView *theShipView;
@property (nonatomic, retain) IBOutlet UIImageView *steerWheelImgView;
@property (nonatomic, retain) IBOutlet UIImageView *ropeImgView;
@property (nonatomic, retain) IBOutlet UIView *fishContainerView;
@property (nonatomic, retain) IBOutlet UILabel *scoreDisplayLbl;
@property (nonatomic, retain) IBOutlet UILabel *scoreValueLbl;

@end
