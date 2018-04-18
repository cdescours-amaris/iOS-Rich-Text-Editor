# RichTextEditor-iOS [![Version](http://cocoapod-badges.herokuapp.com/v/iOS-Rich-Text-Editor/badge.png)](http://cocoadocs.org/docsets/iOS-Rich-Text-Editor)

### 0.9 TODO
- [x] Drop WEPopover dependency and use native popovers on iPhone (see [here](https://rbnsn.me/ios-8-popover-presentations) and [here](https://richardallen.me/2014/11/28/popovers.html)). -- Dropped dependency but decided not to use popovers on iPhone per [interface guidelines](https://developer.apple.com/ios/human-interface-guidelines/ui-views/popovers/). 
- [x] Change style to have starting brackets on the same line as if statements & function calls (etc.)
- [ ] Update code style to use `.` notation rather than `[]` notation
- [ ] Bug fixing/checking
- [ ] Fix NSUndoManager undo/redo when using bulleted lists
- [x] Make the toolbar more pretty
- [x] Framework output
- [ ] New screenshots for this readme
- [x] Make use of iOS NSTextStorage
- [x] Port fixes and changes from OS X ([see here](https://github.com/Deadpikle/macOS-Rich-Text-Editor))
- [x] Convert this README file to use ## instead of ----- for h1/2/3/4/5 syntax
- [ ] Cocoapods
- [ ] Carthage

#### 1.0 TODO
- [ ] Support numbered lists

### Breaking Change Warning!

The BULLET_STRING was modified from '\u2022\t' to '\u2022\u00a0'. You may need to update your own code or saved rich text files accordingly.

## RichTextEditor for iPhone &amp; iPad

**Requirements**: iOS 8.0 or higher

Features:
- Bold
- Italic
- Underline
- StrikeThrough
- Bulleted lists
- Font
- Font size
- Text background color
- Text foregroud color
- Text alignment
- Paragraph Indent/Outdent

### Installing

Make sure to link the MobileCoreServices framework.

### Delegate Warning!

In order to intercept delegate messages, this class uses WZProtocolInterceptor. If you call `self.richTextView.delegate`, you will get the WZProtocolInterceptor object, *not* the original delegate that you set earlier with `self.richTextView.delegate = ...`! If you need to get the delegate that you set, call `[self.richTextView textViewDelegate]`. (This is caused by the richTextView needing its own delegate methods.) 

### Note

If text is set before the view is fully shown, the text may start scrolled to the bottom. Look [here](http://stackoverflow.com/a/27769359/3938401) for solutions. 

### Custom Font Size Selection

Font size selection can be customized by implementing the following data source method

```objective-c
- (NSArray *)fontSizeSelectionForRichTextEditor:(RichTextEditor *)richTextEditor {
	// pass an array of NSNumbers
	return @[@5, @10, @20, @30];
}
```

### Custom Font Family Selection

Font family selection can be customized by implementing the following data source method

```objective-c
- (NSArray *)fontFamilySelectionForRichTextEditor:(RichTextEditor *)richTextEditor {
    // pass an array of Strings
    // Can be taken from [UIFont familyNames]
    return @[@"Helvetica", @"Arial", @"Marion", @"Papyrus"];
}
```

### Presentation Style

You can switch between popover, or modal (presenting font-picker, font-size-picker, color-picker dialogs) by implementing the following data source method
```objective-c
- (RichTextEditorToolbarPresentationStyle)presentarionStyleForRichTextEditor:(RichTextEditor *)richTextEditor {
  // RichTextEditorToolbarPresentationStyleModal Or RichTextEditorToolbarPresentationStylePopover
	return RichTextEditorToolbarPresentationStyleModal;
}
```

### Modal Presentation Style

When presentarionStyleForRichTextEditor is a modal, modal-transition-style & modal-presentation-style can be configured
```objective-c
- (UIModalPresentationStyle)modalPresentationStyleForRichTextEditor:(RichTextEditor *)richTextEditor {
	return UIModalPresentationFormSheet;
}

- (UIModalTransitionStyle)modalTransitionStyleForRichTextEditor:(RichTextEditor *)richTextEditor {
	return UIModalTransitionStyleFlipHorizontal;
}
```

### Customizing Features

Features can be turned on/off by iplementing the following data source method
```objective-c
- (RichTextEditorFeature)featuresEnabledForRichTextEditor:(RichTextEditor *)richTextEditor {
   return RichTextEditorFeatureFont | 
          RichTextEditorFeatureFontSize |
          RichTextEditorFeatureBold |
          RichTextEditorFeatureParagraphIndentation;
}
```

### Enable/Disable RichText Toolbar

You can hide the rich text toolbar by implementing the following method. This method gets called everytime textView becomes first responder.
This can be usefull when you don't want the toolbar, instead you want to use the basic features (bold, italic, underline, strikeThrough), thoguht the UIMeMenuController
```objective-c
- (BOOL)shouldDisplayToolbarForRichTextEditor:(RichTextEditor *)richTextEditor {
   return YES;
} 
```

### Enable/Disable UIMenuController Options

On default the UIMenuController options (bold, italic, underline, strikeThrough) are turned off. You can implement the following method if you want these features to be available through the UIMenuController along with copy/paste/selectAll etc.
```objective-c
- (BOOL)shouldDisplayRichTextOptionsInMenuControllerForRichTextrEditor:(RichTextEditor *)richTextEdiotor {
   return YES;
} 
```

### Custom Toolbar Images

To use custom toolbar images, set the rich text editor's data source, and implement the following method:
```
- (UIImage *)imageForToolbarInRichTextEditor:(RichTextEditor *)richTextEditor forFeature:(RichTextEditorFeature)feature {
    if (feature == RichTextEditorFeatureBulletList)
        return [UIImage imageNamed:@"custom-bullet-list-image"];
    return nil; // return nil if you don't want to set a custom image
}
```

### Credits

Original Rich Text Editor code by aryaxt at [iOS Rich Text Editor](https://github.com/aryaxt/iOS-Rich-Text-Editor).
