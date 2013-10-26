//
//  AWViewController.m
//  Air Ruler
//
//  Created by Alex Wiltschko on 3/25/12.
//  Copyright (c) 2012 Datta Lab, Harvard University. All rights reserved.
//

#define CALIBRATE_SEC 15.0f
#define USE_RAW FALSE

#import "AWViewController.h"

@interface AWViewController ()
{
    CMMotionManager *motionManager;
    CMDeviceMotionHandler motionHandler;
    CMAccelerometerHandler accelerometerHandler;
    NSOperationQueue *opQueue;
    NSOutputStream *calibrateStream;
    NSOutputStream *recordStream;
    
}

@end


@implementation AWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 0.01;
    motionManager.accelerometerUpdateInterval = 0.01;
    if (USE_RAW) {
            
    }
    else {
        
    }
    
    motionHandler = ^(CMDeviceMotion *deviceMotion, NSError *error)
    {
        CMAcceleration motion = deviceMotion.userAcceleration;
        printf( "%f, %f, %f, %f\n", motion.x, motion.y, motion.z, deviceMotion.timestamp);

    };
    accelerometerHandler = ^(CMAccelerometerData *accelerometerData, NSError *error)
    {
        CMAcceleration motion = accelerometerData.acceleration;
        printf( "%f, %f, %f, %f\n", motion.x, motion.y, motion.z, accelerometerData.timestamp);

    };
    opQueue = [[NSOperationQueue alloc] init];
    
    // Open output file in append mode:
    NSString *calibrateFilePath = [self pathInDocsDir:@"my_file.txt"];
    NSLog(@"Saving calibration file in %@", calibrateFilePath);
    NSString *recordFilePath = [self pathInDocsDir:@"my_file.txt"];
    NSLog(@"Saving recording file in %@", recordFilePath);
    calibrateStream = [[NSOutputStream alloc] initToFileAtPath:calibrateFilePath append:NO];
    recordStream = [[NSOutputStream alloc] initToFileAtPath:recordFilePath append:YES];
    [calibrateStream open];
    [recordStream open];
    

}

- (NSString *)pathInDocsDir:(NSString *)filename
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullFilePath = [docPath stringByAppendingPathComponent:filename];
    return fullFilePath;
}

- (void)testWriteToFile
{
    NSString *string = @"Awesome pants";

    // Make NSData object from string:
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // Write data to output file:
    [recordStream write:data.bytes maxLength:data.length];
}

- (void)startRecording
{
    NSLog(@"\n\n\n\n\n\n\n\n\n");
    NSLog(@"x,y,z,t");
    if (USE_RAW) {
        [motionManager startAccelerometerUpdatesToQueue:opQueue withHandler:accelerometerHandler];
    }
    else {
        [motionManager startDeviceMotionUpdatesToQueue:opQueue withHandler:motionHandler];
    }
    
    self.isRecording = TRUE;
}

- (void)stopRecording
{
    NSLog(@"\n");
    if (USE_RAW) {
        [motionManager stopAccelerometerUpdates];
    }
    else {
        [motionManager stopDeviceMotionUpdates];
    }
    
    self.isRecording = FALSE;
}

- (void)viewDidUnload
{
    [self setMeasureButton:nil];
    [self setCalibrateButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)dealloc {
    [_measureButton release];
    [_calibrateButton release];
    [recordStream close];
    [calibrateStream close];
    [super dealloc];
}



- (IBAction)measureTapped:(id)sender {
    NSLog(@"Clicky clicky");
    [self startRecording];
}

- (IBAction)measureReleased:(id)sender
{
    [self stopRecording];
}

- (IBAction)calibrateClicked:(id)sender {
    NSLog(@"Calibratey calibratey (testing file writing)");
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startRecording) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:CALIBRATE_SEC+1.0 target:self selector:@selector(stopRecording) userInfo:nil repeats:NO];
}
@end
