//
//  GRDualSlider.h
//  GRDualSlider
//
//  Created by rost on 11.12.14.
//  Copyright (c) 2014 Rost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRDualSlider : UIControl

@property (nonatomic, strong) UIImageView *leftThumb;
@property (nonatomic, strong) UIImageView *rightThumb;

@property (nonatomic, assign) CGFloat leftSelectedValue;
@property (nonatomic, assign) CGFloat rightSelectedValue;

- (id)initWithFrame:(CGRect)frame andLeft:(CGFloat)left andRight:(CGFloat)right;

@end
