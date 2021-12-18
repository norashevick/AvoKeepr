//
//  UIView+HeapIgnore.h
//  Copyright (c) Heap Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HeapIgnore)
/**
 * Whether Heap should ignore this view and its descendents in the view hierarchy.
 *
 * Defaults to false. This is not thread-safe, and should only be accessed from
 * the main thread.
 */
@property (nonatomic, assign) IBInspectable BOOL heapIgnore;
@end
