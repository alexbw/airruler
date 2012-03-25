//
//  AWAppDelegate.h
//  Air Ruler
//
//  Created by Alex Wiltschko on 3/25/12.
//  Copyright (c) 2012 Datta Lab, Harvard University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AWViewController;

@interface AWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AWViewController *viewController;

@end
