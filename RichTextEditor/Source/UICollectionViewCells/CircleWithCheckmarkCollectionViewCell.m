//
//  CircleWithCheckmarkCollectionViewCell.m
//  RichTextEditor
//
//  Created by Michael Babienco on 12/31/19.
//  Copyright © 2019 Aryan Ghassemi. All rights reserved.
//

#import "CircleWithCheckmarkCollectionViewCell.h"

@interface CircleWithCheckmarkCollectionViewCell ()

@property UIColor *fillColor;
@property (weak) IBOutlet UIImageView *checkmarkView;

@end

@implementation CircleWithCheckmarkCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.color set];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path fill];
}

-(UIColor*)color {
    return self.fillColor;
}

-(void)setColor:(UIColor *)color {
    self.fillColor = color;
    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.checkmarkView.hidden = !selected;
}

@end
