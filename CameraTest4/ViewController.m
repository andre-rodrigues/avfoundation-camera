//
//  ViewController.m
//  CameraTest4
//
//  Created by Tagview Tecnologia on 8/19/13.
//  Copyright (c) 2013 Tagview Tecnologia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.camera = [[Camera alloc] init];
    [self.view addSubview: self.camera.view];
    [self.camera start];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(stopCamera)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)stopCamera
{
    [self.camera stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
