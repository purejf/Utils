//
//  CYUtils.m
//  Utils
//
//  Created by Charlesyx on 2017/5/5.
//  Copyright © 2017年 cy. All rights reserved.
//

#import "CYUtils.h"
#import <objc/runtime.h>

@implementation CYUtils

#pragma mark - 获取某个view所在的控制器
+ (UIViewController *)viewControllerForView:(UIView *)view {
    
    UIViewController *viewController = nil;
    UIResponder *next = view.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    }
    return viewController;
}

#pragma mark - 删除NSUserDefaults所有记录
+ (void)resetUserDefaults {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

#pragma mark - 取图片某一像素点的颜色
+ (UIColor *)colorAtPixel:(CGPoint)point image:(UIImage *)image {
    
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = {0, 0, 0, 0};
    
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -point.x, point.y - image.size.height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), image.CGImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark - 返回反转字符串
+ (NSString *)reservseString:(NSString *)string {
    NSMutableString *reverString = [NSMutableString stringWithCapacity:string.length];
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reverString appendString:substring];
    }];
    return reverString;
}

#pragma mark - 禁止屏幕锁屏
+ (void)disabledIdelTimer {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

#pragma mark - 字符串按多个符号分割
+ (NSArray<NSString *> *)separatedArrayWithString:(NSString *)string characters:(NSString *)characters{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:characters];
    return [string componentsSeparatedByCharactersInSet:set];
}

#pragma mark - 去AppStore给应用评分
+ (void)gotoAppStoreCommentWithAppId:(NSString *)appId {
    NSString *URLString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
    NSURL *URL = [NSURL URLWithString:URLString];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL];
    }
}

#pragma mark - 获取汉字的拼音
+ (NSString *)pinyinWithChinese:(NSString *)chinese {
    // 将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    // 将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    // 去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    // 返回最近结果
    return pinyin;
}

#pragma mark - 手动修改状态栏的颜色
+ (void)changeStatusBarBackgroundColor:(UIColor *)backgroundColor {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = backgroundColor;
    }
}

#pragma mark - 获取实际使用的launchImage的名字
+ (NSString *)launchImageName {
    
    CGSize viewSize = [UIApplication sharedApplication].keyWindow.bounds.size;
    // 竖屏
    NSString *viewOrientation = @"Portrait";
    NSString *launchImageName = nil;
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
}

#pragma mark - 获取当前屏幕的第一响应者
+ (UIView *)firstRespondeForKeyWindow {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    return firstResponder;
}

#pragma mark - 修改UITextField中Placeholder的文字颜色
+ (void)setTextField:(UITextField *)textField placeholderColor:(UIColor *)placeholderColor {
    [textField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark - 获取一个类的所有子类
+ (NSArray *)allSubClassesWithCls:(Class)cls {
    Class myClass = [cls class];
    NSMutableArray *mySubclasses = [NSMutableArray new];
    unsigned int numOfClasses;
    Class *classes = objc_copyClassList(&numOfClasses);
    for (unsigned int ci = 0; ci < numOfClasses; ci++) {
        Class superClass = classes[ci];
        do {
            superClass = class_getSuperclass(superClass);
        } while (superClass && superClass != myClass);
        
        if (superClass) {
            [mySubclasses addObject: classes[ci]];
        }
    }
    free(classes);
    return mySubclasses;
}

#pragma mark - 阿拉伯数字转化为中文格式
+ (NSString *)transArebicStringToChineseString:(NSString *)arebicString {
    
    NSString *str = arebicString;
    
    NSArray *arabic_numerals = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
    NSArray *chinese_numerals = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"零"];
    NSArray *digits = @[@"个", @"十", @"百", @"千", @"万", @"十", @"百", @"千", @"亿", @"十", @"百", @"千", @"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]]) {
            if ([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]]) {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            } else {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum]) {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    NSString *sumStr = [sums componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    return chinese;
}

#pragma mark - 取消UICollectionView的隐式动画
+ (void)collectView:(UICollectionView *)collectionView reloadItemWithNoFadeAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0
                     animations:^{
                         [collectionView performBatchUpdates:^{
                             [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                         } completion:nil];
                     }];
}

#pragma mark - UIImage 占用内存大小
+ (NSInteger)sizeWithImage:(UIImage *)image {
    NSUInteger size = CGImageGetHeight(image.CGImage) * CGImageGetBytesPerRow(image.CGImage);
    return size;
}

#pragma mark - 图片上绘制文字
+ (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize image:(UIImage *)image {
    // 画布大小
    CGSize size = CGSizeMake(image.size.width, image.size.height);
    // 创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0); // opaque:NO  scale:0.0
    
    [image drawAtPoint:CGPointMake(0.0, 0.0)];
    
    // 文字居中显示在画布上
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter; // 文字居中
    
    // 计算文字所占的size,文字居中显示在画布上
    CGSize sizeText = [title boundingRectWithSize:image.size options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                        context:nil].size;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    CGRect rect = CGRectMake((width-sizeText.width) / 2.0, (height-sizeText.height) / 2.0, sizeText.width, sizeText.height);
    // 绘制文字
    [title drawInRect:rect withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                            NSParagraphStyleAttributeName: paragraphStyle}];
    
    // 返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 计算文件大小
+ (long long)fileSizeAtPath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    long long folderSize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            if ([fileManager fileExistsAtPath:fileAbsolutePath]) {
                long long size = [fileManager attributesOfItemAtPath:fileAbsolutePath error:nil].fileSize;
                folderSize += size;
            }
        }
    }
    
    return folderSize;
}

#pragma mark - 查找一个视图的所有子视图
+ (NSMutableArray *)allSubViewsForView:(UIView *)view {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (UIView *subView in view.subviews) {
        [array addObject:subView];
        if (subView.subviews.count > 0) {
            [array addObjectsFromArray:[self allSubViewsForView:subView]];
        }
    }
    return array;
}

#pragma mark - 计算字符串字符长度，一个汉字算两个字符
+ (int)convertToInt:(NSString *)strtemp {
    int strlength = 0;
    char *p = (char *)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return strlength;
}

#pragma mark - 给UIView设置图片
+ (void)setImage:(UIImage *)image forView:(UIView *)view {
    view.layer.contents = (__bridge id _Nullable)(image.CGImage);
    view.layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
}

#pragma mark - 字符串中是否含有中文
+ (BOOL)containsChinese:(NSString *)string {
    for (int i = 0; i < string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}

@end
