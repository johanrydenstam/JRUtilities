//
//  TestTransition.h
//  TransistionTests
//
//  Created by Johan Rydenstam on 28/10/15.
//  Copyright © 2015 Johan Rydenstam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRMoveBackTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL reverse;

/**
 The animation duration.
 */
@property (nonatomic, assign) NSTimeInterval duration;


@end
