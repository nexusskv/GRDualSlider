//
//  GRSliderViewController.m
//  GRDualSlider
//
//  Created by rost on 11.12.14.
//  Copyright (c) 2014 Rost. All rights reserved.
//

#import "GRSliderViewController.h"
#import "GRDualSlider.h"


@interface GRSliderViewController ()
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@end


@implementation GRSliderViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    GRDualSlider *dualSlider = [[GRDualSlider alloc] initWithFrame:CGRectMake(20.0f, 0.0f, self.view.bounds.size.width - 40.0f, 15.0f)
                                                       andLeft:0.0f
                                                      andRight:100.0f];
    [dualSlider addTarget:self action:@selector(sliderValuesSelector:) forControlEvents:UIControlEventValueChanged];
    dualSlider.center = self.view.center;
    [self.view addSubview:dualSlider];
    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectOffset(dualSlider.frame, 0.0f, -dualSlider.frame.size.height * 1.5f)];
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.leftLabel];
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectOffset(dualSlider.frame, 0.0f, -dualSlider.frame.size.height * 1.5f)];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.rightLabel];
    
    [self sliderValuesSelector:dualSlider];
}
#pragma mark -


#pragma mark - Show slider values selector
- (void)sliderValuesSelector:(GRDualSlider *)slider {
    self.leftLabel.text = [NSString stringWithFormat:@"%0.1f", slider.leftSelectedValue];
    self.rightLabel.text = [NSString stringWithFormat:@"%0.1f", slider.rightSelectedValue];
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
