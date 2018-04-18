//
//  RichTextImageAttachment.m
//  RichTextEditor
//
//  Created by hstdt on 2017/8/22.
//  Copyright © 2017年 Aryan Ghassemi. All rights reserved.
//

#import "RichTextImageAttachment.h"

@implementation RichTextImageAttachment


- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0) {
    if (self.image.size.width > lineFrag.size.width && lineFrag.size.width != 0) {
        // resize to make image attachment has the same width with line's width without changing self.image.bounds
        CGFloat aspect = self.image.size.width / lineFrag.size.width;
        return CGRectMake(0, 0, lineFrag.size.width, self.image.size.height / aspect);
    }
    else {
        return CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    }
}

@end
