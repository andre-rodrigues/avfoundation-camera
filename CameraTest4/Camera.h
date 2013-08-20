//
//  Camera.h
//  CameraTest4
//
//  Created by Tagview Tecnologia on 8/19/13.
//  Copyright (c) 2013 Tagview Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define degreesToRadians(x) (M_PI * x / 180.0)

@protocol AVCaptureFileOutputRecordingDelegate;

@interface Camera : NSObject <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, retain) AVCaptureDevice *camera;
@property (nonatomic, retain) AVCaptureDevice *microfone;
@property (nonatomic,retain) AVCaptureSession *session;
@property (nonatomic,retain) AVCaptureDeviceInput *videoInput;
@property (nonatomic,retain) AVCaptureDeviceInput *audioInput;
@property (nonatomic,retain) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, strong) NSURL *fileUrl;

@property (nonatomic, strong) UIView* view;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,assign) AVCaptureVideoOrientation orientation;


-(void) setSessionInput;
-(void) setSessionOutput;
-(void) start;
-(void) stop;

@end
