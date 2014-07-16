//
//  WSQAppDelegate.m
//  OpenGL_Test
//
//  Created by Shouqiang Wei on 14-7-14.
//  Copyright (c) 2014年 Shouqiang Wei. All rights reserved.
//

#import "WSQAppDelegate.h"
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation WSQAppDelegate
{
    float _curRed;
    BOOL _increasing;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    /*
    _increasing = YES;
    _curRed = 0.0f;

    CGRect bounds = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc]initWithFrame:bounds];
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView* gView = [[GLKView alloc] initWithFrame:bounds context:context];
    gView.delegate =self;
     */

    /*
    gView.enableSetNeedsDisplay = false;//取消默认的needsDisPlay;
    CADisplayLink* link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.window addSubview:gView];
     */

    /*
    GLKViewController* controller = [[GLKViewController alloc] init];
    controller.view = gView;
    controller.delegate = self;
    controller.preferredFramesPerSecond = 60;
    self.window.rootViewController = controller;

    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.

    */
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)update:(id)sender
{
    GLKView* v =self.window.subviews[0];
    [v display];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{

    /*
    if (_increasing) {
        _curRed +=0.01f;
       // _increasing = NO;
    }
    else
    {
        _curRed -= 0.01f;
       // _increasing = YES;
    }

    if (_curRed >= 1.0) {
        _curRed = 1.0;
        _increasing = NO;
    }
    if (_curRed <= 0.0) {
        _curRed = 0.0;
        _increasing = YES;
    }

     */

    glClearColor(_curRed, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glClearDepthf(0.1);
    glCompressedTexImage2D(1, 0.2, .2, 300, 3000, 5, 82222, nil);
    [[UIColor grayColor] setFill];

}

-(void)glkViewControllerUpdate:(GLKViewController *)controller
{

    if (_increasing) {
        _curRed +=1.0*controller.timeSinceLastUpdate;
        // _increasing = NO;
    }
    else
    {
        _curRed -= 1.0*controller.timeSinceLastUpdate;
        // _increasing = YES;
    }

    if (_curRed >= 1.0) {
        _curRed = 1.0;
        _increasing = NO;
    }
    if (_curRed <= 0.0) {
        _curRed = 0.0;
        _increasing = YES;
    }
}
@end
