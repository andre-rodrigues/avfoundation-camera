//
//  Camera.m
//  CameraTest4
//
//  Created by Tagview Tecnologia on 8/19/13.
//  Copyright (c) 2013 Tagview Tecnologia. All rights reserved.
//

#import "Camera.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation Camera

@synthesize videoInput;
@synthesize session;
@synthesize fileUrl;
@synthesize movieFileOutput;

-(id)init
{
    self = [super init];
    self.view = [[UIView alloc] init];
    self.view.frame = [[UIScreen mainScreen] bounds];
    
    self.session = [[AVCaptureSession alloc] init];
    self.camera = [self frontFacingCamera];
    self.microfone = [self audioDevice];
    
    // Exit if camera or microfone are not available
    if(!self.camera || !self.microfone) return self;
    
    // Define output file
    self.fileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"]];
    
    // Define Input and Output
    [self setSessionInput];
    [self setSessionOutput];
    
    // Set preview layer
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: self.previewLayer];
    
    return self;
}

// Find a front facing camera, returning nil if one is not found
- (AVCaptureDevice *) frontFacingCamera
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in videoDevices) {
        if (device.position == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    NSLog(@"Front camera is not available");
    return nil;
}

// Find and return an audio device, returning nil if one is not found
- (AVCaptureDevice *) audioDevice
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    if ([devices count] > 0) {
        return [devices objectAtIndex:0];
    }
    NSLog(@"Microfone is not available");
    return nil;
}

-(void)setSessionInput
{
    // Set session input
    NSError *error = nil;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice: self.camera error: &error];
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice: self.microfone error:nil];

    if(error) NSLog(@"%@", error);
    
    if ([self.session canAddInput: self.videoInput] && [self.session canAddInput: self.audioInput]) {
        [self.session addInput: self.videoInput];
        [self.session addInput: self.audioInput];
    }
    else {
        NSLog(@"Session input could not be added");
    }
}

-(void)setSessionOutput
{
    AVCaptureMovieFileOutput *aMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    // Limit duration in 5 seconds 120/24 = 5 seconds, change to 1440/24 = 60 seconds.
    // aMovieFileOutput.maxRecordedDuration = CMTimeMake(120, 24);
    
    if ([self.session canAddOutput:aMovieFileOutput])
        [self.session addOutput:aMovieFileOutput];
    [self setMovieFileOutput:aMovieFileOutput];
}

-(void)start
{
    [self.session startRunning];

    AVCaptureConnection *videoConnection = [self.movieFileOutput connections][0];
    if ([videoConnection isVideoOrientationSupported])
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    
    NSError *error = nil;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    // Attempt to delete some old temp file
    if ([fileMgr removeItemAtPath: [self.fileUrl path] error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);

    [self.movieFileOutput startRecordingToOutputFileURL: self.fileUrl recordingDelegate: self];
}

-(void)stop
{
    // Stop running
    [self.session stopRunning];
}

- (void)              captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
                    fromConnections:(NSArray *)connections
                              error:(NSError *)error
{
    BOOL recordedSuccessfully = YES;
    if ([error code] != noErr) {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value) {
            recordedSuccessfully = [value boolValue];
        }
    }
    
    if(recordedSuccessfully){
        NSLog(@"Recorded sucessfully");
        [self moveToCameraRoll];
    } else {
        NSLog(@"%@", error);
    }
}

-(void) moveToCameraRoll
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSURL *filePathURL = [NSURL fileURLWithPath: [self.fileUrl path] isDirectory:NO];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum: filePathURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum: self.fileUrl completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
                NSLog(@"Not success");
            } else {
                NSLog(@"success");
            }
        }];
        
    }
}

@end
