//
//  ALVideoView.h
//  AnylineCoreMLSample
//
//  Created by Daniel Albertini on 05/07/2017.
//  Copyright © 2017 Daniel Albertini. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALVideoViewImageBufferDelegate;

@interface ALVideoView : UIView

@property (nonatomic, weak) id<ALVideoViewImageBufferDelegate> delegate;

@end

@protocol ALVideoViewImageBufferDelegate

- (void)videoView:(ALVideoView *)videoView didOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end
