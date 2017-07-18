//
//  ViewController.m
//  AnylineCoreMLSample
//
//  Created by Daniel Albertini on 05/07/2017.
//  Copyright © 2017 Daniel Albertini. All rights reserved.
//

#import "ViewController.h"
#import "ALVideoView.h"
#import "Inceptionv3.h"

@interface ViewController ()<ALVideoViewImageBufferDelegate>

@property (nonatomic, strong) ALVideoView *videoView;

@property (nonatomic, strong) UILabel *predictionLabel;

@property (nonatomic, strong) Inceptionv3 *inceptionV3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoView = [[ALVideoView alloc] initWithFrame:self.view.bounds];
    self.videoView.delegate = self;
    [self.view addSubview:self.videoView];
    
    NSInteger kLabelHeight = 100;
    self.predictionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kLabelHeight)];
    self.predictionLabel.backgroundColor = UIColor.whiteColor;
    self.predictionLabel.textColor = UIColor.yellowColor;
    self.predictionLabel.font = [UIFont systemFontOfSize:30];
    self.predictionLabel.textAlignment = NSTextAlignmentCenter;
    self.predictionLabel.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.predictionLabel];
    
    // Initialize the Inception Model
    // That's all you have to do.
    // See how XCode is auto creating a helper class for you to use your model.
    self.inceptionV3 = [[Inceptionv3 alloc] init];
}

- (void)videoView:(ALVideoView *)videoView didOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    // Run our inception model with the pixelBuffer
    NSError *error = nil;
    Inceptionv3Output *inceptionOutput = [self.inceptionV3 predictionFromImage:pixelBuffer error:&error];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([inceptionOutput.classLabel rangeOfString:@"hotdog"].location != NSNotFound) {
            self.predictionLabel.text = @"Hotdog!";
            self.predictionLabel.backgroundColor = UIColor.greenColor;
        } else {
            self.predictionLabel.text = @"Not Hotdog!";
            self.predictionLabel.backgroundColor = UIColor.redColor;
        }
    });
}

@end
