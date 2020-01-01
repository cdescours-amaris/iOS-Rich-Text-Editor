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
    CGRect smallerSize = CGRectMake(2, 4, rect.size.width - 4, rect.size.height - 6);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:smallerSize];
    [path fill];
    if ([self.color isEqual:UIColor.clearColor]) {
        // draw a line through the view so that the "clear" color is visible
        // https://stackoverflow.com/a/5391559/3938401
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, UIColor.redColor.CGColor);
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        CGContextSetLineWidth(context, 2.0f);
        CGContextMoveToPoint(context, 10, rect.size.height - 10); // start at this point
        CGContextAddLineToPoint(context, rect.size.width - 9, 9); // draw to this point
        // and now draw the Path!
        CGContextStrokePath(context);
        
        path.lineWidth = 2;
        if (@available(iOS 13, *)) {
            [UIColor.opaqueSeparatorColor set];
        } else {
            [UIColor.lightGrayColor set];
        }
        [path stroke];
    }
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
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    NSString *imageName = self.useWhiteCheckmark ? @"check-white" : @"check";
    self.checkmarkView.image = [UIImage imageNamed:imageName inBundle:frameworkBundle compatibleWithTraitCollection:nil];
    self.checkmarkView.hidden = !selected;
}

@end
