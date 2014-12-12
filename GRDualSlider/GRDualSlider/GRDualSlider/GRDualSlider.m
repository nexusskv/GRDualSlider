//
//  GRDualSlider.m
//  GRDualSlider
//
//  Created by rost on 11.12.14.
//  Copyright (c) 2014 Rost. All rights reserved.
//

#import "GRDualSlider.h"

@interface GRDualSlider ()
@property (nonatomic, assign) CGFloat barWidth;
@property (nonatomic, assign) CGFloat barHeight;

@property (nonatomic, assign) CGFloat valueSpan;

@property (nonatomic, assign) BOOL leftFlag;
@property (nonatomic, assign) BOOL rightFlag;

@property (nonatomic, assign) CGFloat leftValue;
@property (nonatomic, assign) CGFloat rightValue;
@end


@implementation GRDualSlider

#pragma mark - Constructor
- (id)initWithFrame:(CGRect)frame andLeft:(CGFloat)left andRight:(CGFloat)right {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.valueSpan = right - left;
        self.barHeight = frame.size.height;
        self.barWidth = self.frame.size.width / self.transform.a;  //calculate the actual bar width by dividing with the cos of the view's angle
        
        self.leftThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left_thumb"]
                                           highlightedImage:[UIImage imageNamed:@"left_thumb_tapped"]];
        self.leftThumb.center = CGPointMake(self.barWidth * 0.2f, self.barHeight / 2.0f);
        [self addSubview:self.leftThumb];
        
        self.rightThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_thumb"]
                                           highlightedImage:[UIImage imageNamed:@"right_thumb_tapped"]];
        self.rightThumb.center = CGPointMake(self.barWidth * 0.8f, self.barHeight / 2.0f);
        [self addSubview:self.rightThumb];

        if (left < right) {
            self.leftValue  = left;
            self.rightValue = right;
        } else {
            self.leftValue  = right;
            self.rightValue = left;
        }
        
        self.leftFlag = NO;
        self.rightFlag = NO;
        [self refreshValues];
    }
    return self;
}
#pragma mark -


#pragma mark - Draw control
- (void) drawRect:(CGRect)rect {
    static const CGFloat gradientColors [] = {0.5f, 0.6f, 0.8f, 0.5f,
                                              0.5f, 0.7f, 0.7f, 0.7f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef customGradient = CGGradientCreateWithColorComponents(colorSpace, gradientColors, NULL, 2);
    CGColorSpaceRelease(colorSpace), colorSpace = NULL;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    CGRect firstRect = CGRectMake(0.0f, 0.0, self.rightThumb.center.x, self.barHeight);
    CGRect secondRect = CGRectMake(self.leftThumb.center.x, 0.0f, self.rightThumb.center.x - self.leftThumb.center.x, self.barHeight);
    CGRect thirdRect = CGRectMake(self.rightThumb.center.x, 0.0f, self.barWidth - self.rightThumb.center.x, self.barHeight);
    
    CGContextSaveGState(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

    [self addToContext:context roundRect:thirdRect andOptions:@{@"one":@NO,@"two":@YES,@"three":@YES,@"four":@NO,@"radius":@7.0f}];
    [self addToContext:context roundRect:firstRect andOptions:@{@"one":@YES,@"two":@NO,@"three":@NO,@"four":@YES,@"radius":@7.0f}];
    
    CGContextClip(context);
    CGContextDrawLinearGradient(context, customGradient, startPoint, endPoint, 0);
    
    CGGradientRelease(customGradient), customGradient = NULL;

    CGContextRestoreGState(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:246.0f/255.0f green:247.0f/255.0f blue:242.0f/255.0f alpha:0.9f].CGColor);
    CGContextFillRect(context, secondRect);
    
    [super drawRect:rect];
}

- (void)addToContext:(CGContextRef)context roundRect:(CGRect)rect andOptions:(NSDictionary *)opt {
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(context, minX, midY);
    CGContextAddArcToPoint(context, minX, minY, midX, minY, [opt[@"one"] boolValue]   ? [opt[@"radius"] floatValue] : 0.0f);
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, [opt[@"two"] boolValue]   ? [opt[@"radius"] floatValue] : 0.0f);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, [opt[@"three"] boolValue] ? [opt[@"radius"] floatValue] : 0.0f);
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, [opt[@"four"] boolValue]  ? [opt[@"radius"] floatValue] : 0.0f);
}
#pragma mark -


#pragma mark - Selectors
- (void)refreshValues {
    self.leftSelectedValue = self.leftValue + self.leftThumb.center.x / self.barWidth * self.valueSpan;
    self.rightSelectedValue = self.leftValue + self.rightThumb.center.x / self.barWidth * self.valueSpan;

    if (self.leftSelectedValue < (self.leftValue + 0.01f * self.valueSpan))
        self.leftSelectedValue = self.leftValue;
    if (self.rightSelectedValue > (self.rightValue - 0.01f * self.valueSpan))
        self.rightSelectedValue = self.rightValue;
}

- (void)refreshThumbs {
    self.leftThumb.highlighted  = self.leftFlag;
    self.rightThumb.highlighted = self.rightFlag;
}
#pragma mark -


#pragma mark - Handle touches on slider
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.leftThumb.frame, touchPoint)) {
        self.leftFlag = YES;
    } else if (CGRectContainsPoint(self.rightThumb.frame, touchPoint)) {
        self.rightFlag = YES;
    }
    
    [self refreshThumbs];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    
    if (self.leftFlag || CGRectContainsPoint(self.leftThumb.frame, touchPoint)) {
        if (touchPoint.x < self.rightThumb.center.x - 31.5f && touchPoint.x > 0.0) {
            self.leftThumb.center = CGPointMake(touchPoint.x, self.leftThumb.center.y);
            [self refreshValues];
        }
    } else if (self.rightFlag || CGRectContainsPoint(self.rightThumb.frame, touchPoint) ) {
        if (touchPoint.x > self.leftThumb.center.x + 31.5f && touchPoint.x < self.barWidth) {
            self.rightThumb.center = CGPointMake(touchPoint.x, self.rightThumb.center.y);
            [self refreshValues];
        }
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.leftFlag  = NO;
    self.rightFlag = NO;
    
    [self refreshThumbs];
}
#pragma mark -

@end
