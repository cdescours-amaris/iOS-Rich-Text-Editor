Pod::Spec.new do |s|
    s.name = 'iOS-Rich-Text-Editor'
    s.version = '0.9.0'
    s.summary = 'A RichTextEditor for iPhone & iPad.'
    s.homepage = 'https://github.com/Deadpikle/iOS-Rich-Text-Editor'
    s.author = {'Aryan Gh' => 'https://github.com/Deadpikle/iOS-Rich-Text-Editor'}
    s.source = {:git => 'https://github.com/cdescours-amaris/iOS-Rich-Text-Editor.git', :tag => '0.9.0'}
    s.platform = :ios, '10.0'
    s.source_files = 'RichTextEditor/Source/*.{h,m}','RichTextEditor/Source/**/*.{h,m}'
    s.resources = ['RichTextEditor/Source/Assets/**/*', 'RichTextEditor/Source/**/*.{xcassets}']
    s.framework = 'Foundation', 'UIKit'
    s.requires_arc = true
end
