//
//  CircularGraphView.h
//  CircularGraphViewTest
//
//  Created by Nicolas Ameghino on 6/3/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularGraphView : UIView

@property(nonatomic, assign) NSInteger indexCount;

-(void) setColor: (UIColor *)color forIndex: (NSInteger)index;
-(void) setValue: (CGFloat)value forIndex:(NSInteger)index animated:(BOOL)animated;

@end
