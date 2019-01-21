//
//  HDFPSLabel.h
//  HDFPSLabelDemo
//
//  Created by jiamengqiang on 2019/1/21.
//  Copyright © 2019 Jia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 Show Screen FPS...
 
 The maximum fps in OSX/iOS Simulator is 60.00.
 The maximum fps on iPhone is 59.97.
 The maxmium fps on iPad is 60.0.
 */
@interface HDFPSLabel : UILabel

@end

@interface HDPrivateProxy : NSProxy

- (instancetype)initWithTarget:(id)target;

+ (instancetype)weakProxyForObject:(id)target;
@end

NS_ASSUME_NONNULL_END
