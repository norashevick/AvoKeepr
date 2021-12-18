//
//  HeapOptions.h
//  Copyright (c) Heap Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// Makes nonnull annotation default everywhere. We can explicitly annotate with
// nullable if necessary. This makes Swift use non-optional types instead of
// implicitly unwrapped optionals.
NS_ASSUME_NONNULL_BEGIN

/// @name Heap options library

/// The Heap initialization options API.
@interface HeapOptions : NSObject

/// Start debug logging of Heap activity via NSLog. This should not be called in the release version of an app.
@property (assign) BOOL debug;

/// Disable target text capture.
@property (assign) BOOL disableTextCapture;

 /// Don't capture the iOS vendor ID (IDFV).
@property (assign) BOOL disableVendorIdCapture;

/// Don't capture the iOS advertiser ID (IDFA).
@property (assign) BOOL disableAdvertiserIdCapture;

/// Opt-out of telemetry capture.
@property (assign) BOOL disableTelemetryCapture;

/// Disable Heap autocapture when the app has been backgrounded.
@property (assign) BOOL disableAutocaptureWhenBackgrounded;

/// Disable Heap event capture
@property (assign) BOOL disableTracking;

/// Disable Heap autocapture for touches, fieldedits, swipes, gesture recognizers, etc.
@property (assign) BOOL disableTouchAutocapture;

/// Limit the size of the hierarchy (of parent view elements) captured for every autocaptured interaction. (Default: 30)
@property (assign) NSInteger hierarchyCaptureLimit;

/// Proxy tracking requests through an alternative base URL.
@property (nonatomic, copy, nullable) NSURL *captureBaseUrl;

/// Proxy Event Visualizer requests through an alternative base URL. Path components are currently ignored and should be omitted.
@property (nonatomic, copy, nullable) NSURL *eventVisualizerWebSocketBaseUrl;

@end

NS_ASSUME_NONNULL_END
