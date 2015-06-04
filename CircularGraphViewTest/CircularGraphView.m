//
//  CircularGraphView.m
//  CircularGraphViewTest
//
//  Created by Nicolas Ameghino on 6/3/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import "CircularGraphView.h"

@interface CircularGraphView ()
@property(nonatomic, strong) NSMutableArray *values;
@property(nonatomic, strong) NSMutableArray *colors;

@property(nonatomic, strong) UIColor *emptyFillColor;
@property(nonatomic, assign) CGFloat maxArcRadius;
@end

static NSArray *starterColors;

@implementation CircularGraphView

+(void)load {
    starterColors = @[[UIColor greenColor], [UIColor magentaColor], [UIColor cyanColor], [UIColor purpleColor]];
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    [self setup];
    return self;
}

-(void)awakeFromNib {
    [self setup];
}

-(void) setup {
    [self addObserver:self
           forKeyPath:@"indexCount"
              options:0
              context:NULL];
    
    self.values = [NSMutableArray array];
    self.colors = [NSMutableArray array];
    
    self.backgroundColor = [UIColor blackColor];
    self.emptyFillColor = [UIColor colorWithRed:0.3f
                                          green:0.3f
                                           blue:0.3f
                                          alpha:1];
    self.layer.masksToBounds = YES;
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    if ([keyPath isEqualToString:@"indexCount"]) {
        [self.values removeAllObjects];
        [self.colors removeAllObjects];
        for (NSInteger i=0; i < self.indexCount; ++i) {
            [self.values addObject:@(0)];
            [self.colors addObject:starterColors[i]];
        }
    }
    
}

-(void)drawRect:(CGRect)rect {
    self.maxArcRadius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) * 0.8;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, self.backgroundColor.CGColor);
    CGContextFillRect(ctx, rect);
    
    for (NSInteger li=0; li < [self.layer.sublayers count]; ++li) {
        CALayer *s = self.layer.sublayers[li];
        [s removeFromSuperlayer];
    }
    
    
    for (NSInteger i=0; i < self.indexCount; ++i) {
        [self drawArcWithValue:[self.values[i] floatValue] atIndex:i animated:YES];
    }
}

-(void) drawArcWithValue:(CGFloat) value atIndex:(NSInteger) index animated:(BOOL) animated {
    CGFloat spacing = 5.0f;
    CGFloat arcWidth = 40.0f;
    CGFloat arcRadius = self.maxArcRadius - ((arcWidth + spacing) * index);
    
    CGPoint startingPoint = (CGPoint){self.center.x - arcRadius/2.0f - arcWidth, self.center.y};
    CGPoint endingPoint = (CGPoint){self.center.x + arcRadius/2.0f - arcWidth, self.center.y};;
    CGPoint cp1 = (CGPoint){startingPoint.x, 0};
    CGPoint cp2 = (CGPoint){endingPoint.x, 0};
    
    NSLog(@"sp: %@ - ep: %@ - cp1: %@ - cp2: %@",
          NSStringFromCGPoint(startingPoint),
          NSStringFromCGPoint(endingPoint),
          NSStringFromCGPoint(cp1),
          NSStringFromCGPoint(cp2));
    NSLog(@"AR: %f", arcRadius);
    
    for (UIColor *c in @[self.emptyFillColor, self.colors[index]]) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.name = [NSString stringWithFormat:@"index-%ld-%@-layer",
                      index,
                      (c == self.emptyFillColor ? @"background" : @"value")];
        
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:startingPoint];
        [path addCurveToPoint:endingPoint controlPoint1:cp1 controlPoint2:cp2];

        [layer setPath:path.CGPath];
        [layer setLineCap:@"round"];
        [layer setLineWidth:arcWidth];
        [layer setStrokeColor:c.CGColor];
        [layer setStrokeStart:0];
        
        if (animated) {
            [UIView beginAnimations:[NSString stringWithFormat:@"index-%ld-value-changed", index] context:NULL];
            [UIView setAnimationDuration:0.3f];
        }
        [layer setStrokeEnd: (c == self.emptyFillColor ? 1.0 : value)];
        if (animated ) {
            [UIView commitAnimations];
        }
        
        [self.layer addSublayer:layer];
    }
    
    
}

-(void)setColor:(UIColor *)color forIndex:(NSInteger)index {
    
}

-(void)setValue:(CGFloat)value forIndex:(NSInteger)index animated:(BOOL)animated {
    if (index > [self.values count]) { return; }
    self.values[index] = @(value);
    for (CAShapeLayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:[NSString stringWithFormat:@"index-%ld-value-layer", index]]) {
            [CATransaction begin];
            [CATransaction setDisableActions:!animated];
            [layer setStrokeEnd: value];
            [CATransaction commit];
        }
    }
}

@end
