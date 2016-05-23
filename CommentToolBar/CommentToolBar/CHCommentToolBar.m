//
//  CHCommentToolBar.m
//  AviationNews
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 庄春辉. All rights reserved.
//

#import "CHCommentToolBar.h"
#import<CoreText/CoreText.h>

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define CONTENT_HEIGHT 150+300
#define MAX_COUNT 150

@interface CHCommentToolBar ()<UITextViewDelegate>
{
    UIButton                *_btnSay;
    UILabel                 *_lbSay;
    
    UILabel                 *_lbComment;
    UIButton                *_btnCollection;
    
    UIButton                *_hudView;
    UIView                  *_contentView;
    UITextView              *_tvContent;
    UILabel                 *_lbTitle;
    UILabel                 *_lbNum;
    UIButton                *_btnOK;
    
    BOOL                    _isAnimation;
}

@end

@implementation CHCommentToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = RGBA(248, 248, 248, 1);
        _isAnimation = NO;
        
        //
        _btnSay = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSay.frame = CGRectMake(10, 5, frame.size.width/2, frame.size.height-10);
        [_btnSay setTitle:@"我来说两句" forState:UIControlStateNormal];
        [_btnSay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _btnSay.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _btnSay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btnSay.contentEdgeInsets = UIEdgeInsetsMake(0,15, 0, 15);
        _btnSay.backgroundColor = [UIColor whiteColor];
        _btnSay.layer.borderColor = RGBA(218, 218, 218, 1).CGColor;
        _btnSay.layer.borderWidth = 0.5f;
        _btnSay.layer.cornerRadius = (frame.size.height-10)/2;
        [_btnSay addTarget:self action:@selector(btnSayClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnSay];
        
        _lbSay = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _btnSay.frame.size.width-30, _btnSay.frame.size.height)];
        _lbSay.textAlignment = NSTextAlignmentLeft;
        _lbSay.font = [UIFont systemFontOfSize:16.f];
        [_btnSay addSubview:_lbSay];
        _lbSay.hidden = YES;
        
        //
        CGFloat _width = (frame.size.width/2-20)/3;
        
        UIButton *_btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnComment.frame = CGRectMake(frame.size.width/2+20, 0, _width, frame.size.height);
        [_btnComment setImage:[UIImage imageNamed:@"btnCommend_icon.png"] forState:UIControlStateNormal];
        [_btnComment addTarget:self action:@selector(btnCommentClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnComment];
        
        //
        _btnCollection = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCollection.frame = CGRectMake(frame.size.width/2+_width+20, 0, _width, frame.size.height);
        [_btnCollection setImage:[UIImage imageNamed:@"btnCollection_icon_normal.png"] forState:UIControlStateNormal];
        [_btnCollection setImage:[UIImage imageNamed:@"btnCollection_icon_selected.png"] forState:UIControlStateSelected];
        [_btnCollection addTarget:self action:@selector(btnCollectionClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCollection];
        
        _lbComment = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2+_width-5, 5, 40, 12)];
        _lbComment.text = @"";
        _lbComment.textAlignment = NSTextAlignmentLeft;
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.font = [UIFont systemFontOfSize:10.f];
        _lbComment.backgroundColor = RGBA(52, 169, 218, 1);
        _lbComment.layer.cornerRadius = 6.f;
        _lbComment.clipsToBounds = YES;
        _lbComment.hidden = YES;
        [self addSubview:_lbComment];
        
        //
        UIButton *_btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnShare.frame = CGRectMake(frame.size.width/2+_width*2+20, 0, _width, frame.size.height);
        [_btnShare setImage:[UIImage imageNamed:@"btnShare_icon.png"] forState:UIControlStateNormal];
        [_btnShare addTarget:self action:@selector(btnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnShare];
    }
    return self;
}

#pragma mark public method

- (void)addKeyboardNotification
{
    if(_hudView){
        [self removeKeyboardNotification];
    }
    
    UIWindow *_window = [UIApplication sharedApplication].keyWindow;
    //
    _hudView = [UIButton buttonWithType:UIButtonTypeCustom];
    _hudView.frame = CGRectMake(0, 0, WIDTH, HEIGHT+CONTENT_HEIGHT);
    _hudView.hidden = YES;
    _hudView.backgroundColor = RGBA(0, 0, 0, 1);
    _hudView.alpha = 0;
    [_hudView addTarget:self action:@selector(btnHudClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_window addSubview:_hudView];
    
    //
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, CONTENT_HEIGHT)];
    _contentView.backgroundColor = RGBA(235, 235, 235, 1);
    [_window addSubview:_contentView];
    
    UIButton *_btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCancel.frame = CGRectMake(10, 0, 60, 45);
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _btnCancel.titleLabel.font = [UIFont systemFontOfSize:16.f];
    _btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_btnCancel addTarget:self action:@selector(btnCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_btnCancel];
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, WIDTH-200, 45)];
    _lbTitle.text = @"写评论";
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.textColor = [UIColor blackColor];
    _lbTitle.font = [UIFont systemFontOfSize:18.f];
    [_contentView addSubview:_lbTitle];
    
    _btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnOK.frame = CGRectMake(WIDTH-70, 0, 60, 45);
    [_btnOK setTitle:@"发送" forState:UIControlStateNormal];
    [_btnOK setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [_btnOK setTitleColor:RGBA(52, 169, 218, 1) forState:UIControlStateNormal];
    [_btnOK setTitleColor:RGBA(12, 109, 218, 1) forState:UIControlStateHighlighted];
    _btnOK.titleLabel.font = [UIFont systemFontOfSize:16.f];
    _btnOK.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnOK.enabled = NO;
    [_btnOK addTarget:self action:@selector(btnOKClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_btnOK];
    
    _tvContent = [[UITextView alloc] initWithFrame:CGRectMake(10, 45, WIDTH-20, 90)];
    _tvContent.font = [UIFont systemFontOfSize:16.f];
    _tvContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tvContent.layer.borderWidth = 0.5f;
    _tvContent.delegate = self;
    _tvContent.returnKeyType = UIReturnKeySend;
    [_contentView addSubview:_tvContent];
    
    _lbNum = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH-100)/2, 30, 100, 15)];
    _lbNum.text = [NSString stringWithFormat:@"(*%d字内*)",MAX_COUNT];
    _lbNum.textAlignment = NSTextAlignmentCenter;
    _lbNum.textColor = [UIColor redColor];
    _lbNum.font = [UIFont systemFontOfSize:12.f];
    _lbNum.hidden = YES;
    [_contentView addSubview:_lbNum];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeKeyboardNotification
{
    if(_lbNum){
        [_lbNum removeFromSuperview];
        _lbNum = nil;
    }
    if(_tvContent){
        [_tvContent removeFromSuperview];
        _tvContent = nil;
    }
    if(_btnOK){
        [_btnOK removeFromSuperview];
        _btnOK = nil;
    }
    if(_contentView){
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
    if(_hudView){
        [_hudView removeFromSuperview];
        _hudView = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setCommentCount:(NSInteger)count
{
    if(count==0){
        _lbComment.hidden = YES;
    }else{
        _lbComment.hidden = NO;
        _lbComment.text = [NSString stringWithFormat:@"0%ld",count];
        [_lbComment sizeToFit];
        _lbComment.text = [NSString stringWithFormat:@"%ld",count];
        _lbComment.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)setCollectionSelected:(BOOL)selected
{
    _btnCollection.selected = selected;
}

- (void)setSendToName:(NSString *)name
{
    if([name isEqualToString:@""]){
        _lbTitle.text = @"写评论";
    }else{
        _lbTitle.text = [NSString stringWithFormat:@"回复: %@",name];
    }
    _isAnimation = YES;
    [_tvContent becomeFirstResponder];
}

#pragma mark button event

- (void)btnSayClicked:(id)sender
{
    _lbTitle.text = @"写评论";
    _isAnimation = YES;
    [_tvContent becomeFirstResponder];
}

- (void)btnCommentClicked:(id)sender
{
    [self.tool_delegate didCommentClicked];
}

- (void)btnCollectionClicked:(id)sender
{
    _btnCollection.selected = !_btnCollection.selected;
    [self.tool_delegate didCollectionClicked];
}

- (void)btnShareClicked:(id)sender
{
    [self.tool_delegate didShareClicked];
}

- (void)btnOKClicked:(id)sender
{
    if(_tvContent.text.length>MAX_COUNT){
        return;
    }
    [self btnHudClicked:sender];
    [self.tool_delegate didSendText:_tvContent.text];
    _tvContent.text = @"";
}

- (void)btnHudClicked:(id)sender
{
    if(_tvContent.text.length>0){
        [_btnSay setTitle:@"" forState:UIControlStateNormal];
        _lbSay.hidden = NO;
        
        NSString *_title = [NSString stringWithFormat:@"[草稿] %@",_tvContent.text];
        NSMutableAttributedString *_aTitle = [[NSMutableAttributedString alloc] initWithString:_title];
        [_aTitle addAttribute:NSForegroundColorAttributeName
                        value:[UIColor redColor]
                        range:NSMakeRange(0, 4)];
        _lbSay.attributedText = _aTitle;
        
    }else{
        _lbSay.attributedText = nil;
        _lbSay.hidden = YES;
        [_btnSay setTitle:@"我来说两句" forState:UIControlStateNormal];
    }
    
    [_tvContent resignFirstResponder];
}

- (void)btnCancelClicked:(id)sender
{
    [self btnHudClicked:sender];
}

#pragma mark keybaord notificate

- (void)keyboardWillShow:(NSNotification *)notification
{
    if(!_isAnimation){
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    _hudView.hidden = NO;
    __weak CHCommentToolBar *_weakSelf = self;
    [UIView animateWithDuration:animationDuration animations:^{
        __strong CHCommentToolBar *_strongSelf = _weakSelf;
        if(_strongSelf){
            _strongSelf->_hudView.alpha = 0.75f;
            _strongSelf->_contentView.frame = CGRectMake(0, HEIGHT-keyboardRect.size.height-150, WIDTH, CONTENT_HEIGHT);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardChange:(NSNotification *)notification
{
    _isAnimation = YES;
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    _hudView.hidden = NO;
    
    __weak CHCommentToolBar *_weakSelf = self;
    [UIView animateWithDuration:animationDuration animations:^{
        __strong CHCommentToolBar *_strongSelf = _weakSelf;
        if(_strongSelf){
            _strongSelf->_hudView.alpha = 0.75f;
            _strongSelf->_contentView.frame = CGRectMake(0, HEIGHT-keyboardRect.size.height-150, WIDTH, CONTENT_HEIGHT);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    __weak CHCommentToolBar *_weakSelf = self;
    [UIView animateWithDuration:animationDuration animations:^{
        __strong CHCommentToolBar *_strongSelf = _weakSelf;
        if(_strongSelf){
            _strongSelf->_hudView.alpha = 0.f;
            _strongSelf->_contentView.frame = CGRectMake(0, HEIGHT, WIDTH, CONTENT_HEIGHT);
        }
    } completion:^(BOOL finished) {
        __strong CHCommentToolBar *_strongSelf = _weakSelf;
        if(_strongSelf){
            _strongSelf->_hudView.hidden = YES;
            _strongSelf->_isAnimation = NO;
        }
    }];
}

#pragma mark textview delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if(_tvContent.text.length==0){
        _btnOK.enabled = NO;
        [_btnOK setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        _btnOK.enabled = YES;
        [_btnOK setTitleColor:RGBA(52, 169, 218, 1) forState:UIControlStateNormal];
    }
    
    if(_tvContent.text.length>MAX_COUNT){
        _lbNum.hidden = NO;
    }else{
        _lbNum.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

@end
