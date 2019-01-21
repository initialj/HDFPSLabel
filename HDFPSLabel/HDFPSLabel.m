//
//  HDFPSLabel.m
//  HDFPSLabelDemo
//
//  Created by jiamengqiang on 2019/1/21.
//  Copyright © 2019 Jia. All rights reserved.
//

#import "HDFPSLabel.h"

@interface HDPrivateProxy ()
@property (nonatomic,weak,readonly) id target;
@end

@implementation HDPrivateProxy

#pragma mark - Life Cycle

- (instancetype)initWithTarget:(id)target{
    _target = target;
    return self;
}

+ (instancetype)weakProxyForObject:(id)target {
    HDPrivateProxy* weakProxy = [HDPrivateProxy alloc];
    return [weakProxy initWithTarget:target];
}

#pragma mark - Forwarding Messages

- (BOOL)respondsToSelector:(SEL)aSelector{
    return [self.target respondsToSelector:aSelector];
}


/**
 消息转发第二步，在第一步无法完成的情况下执行。这里只是把一个Selector简单的转发给另一个对象
 */
- (id)forwardingTargetForSelector:(SEL)selector
{
    // Keep it lightweight: access the ivar directly
    return _target;
}
/**
 当一个消息转发的动作NSInvocation到来的时候，在这里选择把消息转发给对应的实际处理对象
 消息转发第三步，在第二步也无法完成的情况下执行。将整个消息封装成NSInvocation，传递下去
 */
- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL sel = [invocation selector];
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    }else{
        void *null = NULL;
        [invocation setReturnValue:&null];
    }
}

/**
 当一个SEL到来的时候，在这里返回SEL对应的NSMethodSignature
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [self.target methodSignatureForSelector:aSelector];
}


- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}

- (NSUInteger)hash {
    return [_target hash];
}

- (Class)superclass {
    return [_target superclass];
}

- (Class)class {
    return [_target class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [_target description];
}

- (NSString *)debugDescription {
    return [_target debugDescription];
}
@end

#define kSize CGSizeMake(55, 20)

@implementation HDFPSLabel{
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
    
    NSTimeInterval _llll;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = kSize;
    }
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:4];
    }
    
    _link = [CADisplayLink displayLinkWithTarget:[HDPrivateProxy weakProxyForObject:self] selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    [text setAttributes:@{NSForegroundColorAttributeName: color} range:NSMakeRange(0, text.length-3)];
    [text setAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} range:NSMakeRange(text.length - 3, 3)];
    [text setAttributes:@{NSFontAttributeName: _font} range:NSMakeRange(0, text.length)];
    [text setAttributes:@{NSFontAttributeName: _subFont} range:NSMakeRange(text.length - 4, 1)];
    
    self.attributedText = text;
}

@end

