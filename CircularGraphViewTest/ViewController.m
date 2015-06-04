//
//  ViewController.m
//  CircularGraphViewTest
//
//  Created by Nicolas Ameghino on 6/3/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import "ViewController.h"
#import "CircularGraphView.h"

@interface ViewController ()
@property(nonatomic, weak) IBOutlet UISlider *slider;
@property(nonatomic, weak) IBOutlet CircularGraphView *graph;
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slider.maximumValue = 1.0f;
    self.slider.minimumValue = 0.0f;
    self.slider.value = 0.5f;
    [self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.graph setValue:self.slider.value forIndex:0 animated:NO];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                  target:self
                                                selector:@selector(shuffleValue:)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    self.graph.indexCount = 1;
    [self.graph setValue:0.25f forIndex:0 animated:NO];
//    [self.graph setValue:0.75f forIndex:1 animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) shuffleValue:(NSTimer *)timer {
    CGFloat r = arc4random_uniform(1024) / 1024.0f;
    [self.graph setValue:r
                forIndex:0
                animated:YES];
    [self.slider setValue:r animated:YES];
}

- (void) valueChanged:(id) sender {
    [self.graph setValue:self.slider.value
                forIndex:0
                animated:YES];
    /*
    [self.graph setValue:1 - self.slider.value
                forIndex:1
                animated:YES];
    */
    NSLog(@"Setting value to %f", self.slider.value);
}

@end
