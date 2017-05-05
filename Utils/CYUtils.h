//
//  CYUtils.h
//  Utils
//
//  Created by Charlesyx on 2017/5/5.
//  Copyright © 2017年 cy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CYUtils : NSObject

#pragma mark - 获取某个view所在的控制器
+ (UIViewController *)viewControllerForView:(UIView *)view;

#pragma mark - 删除NSUserDefaults所有记录
+ (void)resetUserDefaults;

#pragma mark - 取图片某一像素点的颜色
+ (UIColor *)colorAtPixel:(CGPoint)point image:(UIImage *)image;

#pragma mark - 返回反转字符串
+ (NSString *)reservseString:(NSString *)string;

#pragma mark - 禁止屏幕锁屏
+ (void)disabledIdelTimer;

#pragma mark - 字符串按多个符号分割
+ (NSArray <NSString *>*)separatedArrayWithString:(NSString *)string characters:(NSString *)characters;

#pragma mark - 去AppStore给应用评分
+ (void)gotoAppStoreCommentWithAppId:(NSString *)appId;

#pragma mark - 获取汉字的拼音
+ (NSString *)pinyinWithChinese:(NSString *)chinese;

#pragma mark - 手动修改状态栏的颜色
+ (void)changeStatusBarBackgroundColor:(UIColor *)backgroundColor;

#pragma mark - 获取实际使用的launchImage的名字
+ (NSString *)launchImageName;

#pragma mark - 获取当前屏幕的第一响应者
+ (UIView *)firstRespondeForKeyWindow;

#pragma mark -  修改输入框中Placeholder的文字颜色
+ (void)setTextField:(UITextField *)textField placeholderColor:(UIColor *)placeholderColor;

#pragma mark - 获取一个类的所有子类
+ (NSArray *)allSubClassesWithCls:(Class)cls;

#pragma mark - 阿拉伯数字转化为中文格式 
+ (NSString *)transArebicStringToChineseString:(NSString *)arebicString;

#pragma mark - 取消UICollectionView的隐式动画
+ (void)collectView:(UICollectionView *)collectionView reloadItemWithNoFadeAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - UIImage 占用内存大小
+ (NSInteger)sizeWithImage:(UIImage *)image;

#pragma mark - 图片上绘制文字
+ (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize image:(UIImage *)image;

#pragma mark - 计算文件大小
+ (long long)fileSizeAtPath:(NSString *)path;

#pragma mark - 查找一个视图的所有子视图
+ (NSMutableArray *)allSubViewsForView:(UIView *)view;

#pragma mark - 计算字符串字符长度，一个汉字算两个字符
+ (int)convertToInt:(NSString *)strtemp;

#pragma mark - 给UIView设置图片
+ (void)setImage:(UIImage *)image forView:(UIView *)view;

#pragma mark - 字符串中是否含有中文
+ (BOOL)containsChinese:(NSString *)string;

@end
