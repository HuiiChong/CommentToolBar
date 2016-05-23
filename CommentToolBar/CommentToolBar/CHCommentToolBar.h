//
//  CHCommentToolBar.h
//  AviationNews
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 庄春辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHCommentToolBarDelegate <NSObject>

- (void)didCommentClicked;
- (void)didCollectionClicked;
- (void)didShareClicked;
- (void)didSendText:(NSString *)text;

@end

@interface CHCommentToolBar : UIToolbar

@property (nonatomic, weak) id<CHCommentToolBarDelegate> tool_delegate;

- (void)addKeyboardNotification;
- (void)removeKeyboardNotification;

- (void)setCommentCount:(NSInteger)count;
- (void)setCollectionSelected:(BOOL)selected;
- (void)setSendToName:(NSString *)name;

@end
