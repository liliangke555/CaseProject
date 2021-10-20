//
//  NSString+MDYStringSize.m
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import "NSString+MDYStringSize.h"

@implementation NSString (MDYStringSize)
- (CGFloat)getLabelHeightWithWidth:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil]; return rect.size.height;
    
}
 
 
//根据高度度求宽度
 
- (CGFloat)getWidthWithHeight:(CGFloat)height font:(CGFloat)font
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil]; return rect.size.width;
    
}

- (CGFloat)getSpaceLabelHeightwithAttrDict:(NSMutableDictionary *)dict withWidth:(CGFloat)width {

    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return size.height;
}
- (NSString *)changeHtmlString {
    
    NSString *content = [self stringByReplacingOccurrencesOfString:@"&amp;quot" withString:@"'"];
        content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        
        NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                           "<head> \n"
                           "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
                           "<style type=\"text/css\"> \n"
                           "body {font-size:15px;}\n"
                           "</style> \n"
                           "</head> \n"
                           "<body>"
                           "<script type='text/javascript'>"
                           "window.onload = function(){\n"
                           "var $img = document.getElementsByTagName('img');\n"
                           "for(var p in  $img){\n"
                           " $img[p].style.width = '100%%';\n"
                           "$img[p].style.height ='auto'\n"
                           "}\n"
                           "}"
                           "</script>%@"
                           "</body>"
                           "</html>",content];
    
    return htmls;
}
@end
