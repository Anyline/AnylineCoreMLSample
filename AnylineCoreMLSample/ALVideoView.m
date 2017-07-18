//
//  ALVideoView.m
//  AnylineCoreMLSample
//
//  Created by Daniel Albertini on 05/07/2017.
//  Copyright © 2017 Daniel Albertini. All rights reserved.
//

#import "ALVideoView.h"
#import <AVFoundation/AVFoundation.h>

@interface ALVideoView()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation ALVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initCamera];
    }
    return self;
}

- (void)initCamera {
    // Initialize a capture session and set the present to 1080.
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
    
    // Create a capture device and capture device input and add it to the session
    // Uses the default camera for video which is normally the back camera
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    [self.session addInput:input];
    
    // Creates a video output and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [self.session addOutput:output];
    
    // Create a dispatch_queue on which the frame sample buffer will call the delegate methods
    dispatch_queue_t queue = dispatch_queue_create("ALVideoQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    // Set the pixel format to BGRA which is needed by the inception model
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                               forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [output setVideoSettings:outputSettings];
    
    // Discards frames which are ready while we use the queue
    output.alwaysDiscardsLateVideoFrames = YES;
    
    // Setup of preview layer which presents a preview from the camera.
    CALayer *viewLayer = self.layer;
    AVCaptureVideoPreviewLayer * avLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    avLayer.bounds = viewLayer.bounds;
    avLayer.frame = viewLayer.frame;
    avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    avLayer.position = CGPointMake(CGRectGetMidX(avLayer.bounds),
                                   CGRectGetMidY(avLayer.bounds));
    [viewLayer addSublayer:avLayer];
    
    // Set the video orientation to portait, because our App is only designed for portrait
    [self.session beginConfiguration];
    for (AVCaptureConnection *connection in [output connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                break;
            }
        }
    }
    [self.session commitConfiguration];
    // Run it
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)output
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Transform the frame to 299x299, because that's what inception expects as input
    CGFloat imageSide = 299;
    CIImage *ciImage = [[CIImage alloc] initWithCVImageBuffer:imageBuffer];
    CGAffineTransform transform = CGAffineTransformMakeScale(imageSide / CVPixelBufferGetWidth(imageBuffer), imageSide / CVPixelBufferGetHeight(imageBuffer));
    ciImage = [ciImage imageByApplyingTransform:transform];
    
    // Create a PixelBufferRef out of the ciImage
    CIContext *ciContext = [[CIContext alloc] init];
    CVPixelBufferRef pixelBuffer;
    CVPixelBufferCreate(kCFAllocatorDefault, imageSide, imageSide, CVPixelBufferGetPixelFormatType(imageBuffer), nil, &pixelBuffer);
    [ciContext render:ciImage toCVPixelBuffer:pixelBuffer];
    
    [self.delegate videoView:self didOutputPixelBuffer:pixelBuffer];
}

@end
