//
//  AWViewController.h
//  Air Ruler
//
//  Created by Alex Wiltschko on 3/25/12.
//  Copyright (c) 2012 Datta Lab, Harvard University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AWViewController : UIViewController

@property BOOL isRecording;
@property (retain, nonatomic) IBOutlet UIButton *measureButton;
@property (retain, nonatomic) IBOutlet UIButton *calibrateButton;

- (IBAction)measureTapped:(id)sender;
- (IBAction)measureReleased:(id)sender;
- (IBAction)calibrateClicked:(id)sender;

- (void)startRecording;
- (void)stopRecording;

@end
