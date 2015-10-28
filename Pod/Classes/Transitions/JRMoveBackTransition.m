//
//  TestTransition.m
//  TransistionTests
//
//  Created by Johan Rydenstam on 28/10/15.
//  Copyright © 2015 Johan Rydenstam. All rights reserved.
//

#import "JRMoveBackTransition.h"

@implementation JRMoveBackTransition

- (id)init {
    if (self = [super init]) {
        self.duration = 0.8f;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    [self animateTransition:transitionContext fromViewController:fromVC toViewController:toVC fromView:fromView toView:toView];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    if(self.reverse){
        [self executeReverseAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    } else {
        [self executeForwardsAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
    
}

-(void)executeForwardsAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    UIView *containerView = [transitionContext containerView];

    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    CGRect offScreenFrame = frame;
    offScreenFrame.origin.y = offScreenFrame.size.height;
    toView.frame = offScreenFrame;
    
    [containerView insertSubview:toView aboveSubview:fromView];
    CATransform3D t2 = [self secondTransformWithView:fromView];
    
    [UIView animateKeyframesWithDuration:self.duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.8f animations:^{
            fromView.alpha = 0.6;
            
            fromView.layer.transform = t2;
            toView.frame = CGRectOffset(toView.frame, 0.0, -30.0);
            toView.frame = frame;
        }];
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
    
}

-(void)executeReverseAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    
    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    toView.frame = frame;
    CATransform3D scale = CATransform3DIdentity;
    toView.layer.transform = CATransform3DScale(scale, 0.9, 0.9, 1);
    
    toView.alpha = 0.6;
    
    CGRect frameOffScreen = frame;
    frameOffScreen.origin.y = frame.size.height;

    
    [UIView animateKeyframesWithDuration:self.duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        // push the from- view off the bottom of the screen
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5f animations:^{
            fromView.frame = frameOffScreen;
        }];
        
        // animate the to- view into place
        [UIView addKeyframeWithRelativeStartTime:0.15f relativeDuration:0.35f animations:^{
            toView.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.15f relativeDuration:0.25f animations:^{
            toView.layer.transform = CATransform3DIdentity;
        }];
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            toView.layer.transform = CATransform3DIdentity;
            toView.alpha = 1.0;
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

-(CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    return t1;
    
}

-(CATransform3D)secondTransformWithView:(UIView*)view{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    t2 = CATransform3DScale(t2, 0.90, 0.93, 1);
    
    return t2;
}

@end