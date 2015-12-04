//
//  AFDropdownNotification.m
//  AFDropdownNotification-Demo
//
//  Created by Alvaro Franco on 21/08/14.
//  Copyright (c) 2014 AluanaLabs. All rights reserved.
//

#import "AFDropdownNotification.h"

#define kDropdownImageSize 40
#define kDropdownPadding 10
#define kDropdownTitleFontSize 19
#define kDropdownSubtitleFontSize 14
#define kDropdownButtonWidth 75
#define kDropdownButtonHeight 30

@interface AFDropdownNotification ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic) CGSize screenSize;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic) BOOL gravityAnimation;

@property (nonatomic, copy) block internalBlock;

@end

@implementation AFDropdownNotification

-(id)init {

    self = [super init];

    if (self) {

        _notificationView = [UIView new];
        _notificationView.backgroundColor = [UIColor whiteColor];

        _titleLabel = [UILabel new];

        _subtitleLabel = [UILabel new];
        _subtitleLabel.numberOfLines = 0;

        _imageView = [UIImageView new];
        _imageView.image = nil;

        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.adjustsImageWhenHighlighted = YES;

        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _screenSize = [[UIScreen mainScreen] bounds].size;

        _dismissOnTap = NO;
        _dismissOnSwipeUp = YES;
    }

    return self;
}

-(void)presentInView:(UIView *)view withGravityAnimation:(BOOL)animation {

    if (!_isBeingShown) {

        _imageView.image = _image;
        _titleLabel.text = _titleText;
        _subtitleLabel.text = _subtitleText;
        [_topButton setTitle:_topButtonText forState:UIControlStateNormal];
        [_bottomButton setTitle:_bottomButtonText forState:UIControlStateNormal];
        
        _titleLabel.font = _titleLabelFont ? : [UIFont systemFontOfSize:15];
        _titleLabel.textColor = _titleLabelColor ? : [UIColor blackColor];
        
        _subtitleLabel.font = _subtitleLabelFont ? : [UIFont systemFontOfSize:13];
        _subtitleLabel.textColor = _subtitleLabelColor ? : [UIColor blackColor];
        
        _topButtonBackgroundColor = _topButtonBackgroundColor ? : [UIColor clearColor];
        _topButtonBorderColor = _topButtonBorderColor ? : [UIColor grayColor];
        
        _buttonBorderWidth = _buttonBorderWidth ? : 1;
        _buttonCornerRadius = _buttonCornerRadius ? : 10;
        
        _topButton.backgroundColor = _topButtonBackgroundColor;
        _topButton.titleLabel.font = _buttonFont;
        [_topButton setTitleColor:_topButtonTextColor forState:UIControlStateNormal];
        [_topButton.layer setCornerRadius:_buttonCornerRadius];
        [_topButton.layer setBorderWidth:_buttonBorderWidth];
        [_topButton.layer setBorderColor:_topButtonBorderColor.CGColor];
        [_topButton.layer setMasksToBounds:YES];
        
        _bottomButtonBackgroundColor = _bottomButtonBackgroundColor ? : [UIColor clearColor];
        _bottomButtonBorderColor = _bottomButtonBorderColor ? : [UIColor grayColor];
        
        _bottomButton.titleLabel.font = _buttonFont;
        [_bottomButton setTitleColor:_bottomButtonTextColor forState:UIControlStateNormal];
        [_bottomButton.layer setCornerRadius:_buttonCornerRadius];
        [_bottomButton.layer setBorderWidth:_buttonBorderWidth];
        [_bottomButton.layer setBorderColor:_bottomButtonBorderColor.CGColor];
        [_bottomButton.layer setMasksToBounds:YES];

        NSInteger textWidth = ([[UIScreen mainScreen] bounds].size.width - kDropdownPadding - kDropdownImageSize - kDropdownPadding - kDropdownPadding - kDropdownButtonWidth - kDropdownPadding);
        NSInteger titleHeight = [_titleLabel.text boundingRectWithSize:CGSizeMake(textWidth, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:kDropdownTitleFontSize]} context:nil].size.height;
        NSInteger subtitleHeight = [_subtitleLabel.text boundingRectWithSize:CGSizeMake(textWidth, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:kDropdownSubtitleFontSize]} context:nil].size.height;
        NSInteger notificationHeight = (20 + kDropdownPadding + titleHeight + (kDropdownPadding / 2) + subtitleHeight + kDropdownPadding);

        if (notificationHeight < 100) {

            notificationHeight = 100;
        }

        _notificationView.frame = CGRectMake(0, -notificationHeight, [[UIScreen mainScreen] bounds].size.width, notificationHeight);
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:_notificationView];
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:_notificationView];

        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
            _blurEffectStyle = _blurEffectStyle ? : UIBlurEffectStyleLight;
            UIVisualEffect *visualEffect = [UIBlurEffect effectWithStyle:_blurEffectStyle];
            UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
            blurView.frame = _notificationView.bounds;
            [_notificationView addSubview:blurView];
        }

        _imageView.frame = CGRectMake(kDropdownPadding, (notificationHeight / 2) - (kDropdownImageSize / 2) + (20 / 2), kDropdownImageSize, kDropdownImageSize);

        if (_image) {
            [_notificationView addSubview:_imageView];

            if (self.isImageRounded) {
                self.imageView.clipsToBounds = YES;
                self.imageView.layer.cornerRadius = kDropdownImageSize/2;
                self.imageView.image = _image;
            }
        }

        _titleLabel.frame = CGRectMake(kDropdownPadding + kDropdownImageSize + kDropdownPadding, 20 + kDropdownPadding, textWidth, titleHeight);

        if (_titleText) {
            [_notificationView addSubview:_titleLabel];
        }

        _subtitleLabel.frame = CGRectMake(kDropdownPadding + kDropdownImageSize + kDropdownPadding, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 3, textWidth, subtitleHeight);

        if (_subtitleText) {
            [_notificationView addSubview:_subtitleLabel];
        }

        _topButton.frame = CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + kDropdownPadding, 20 + (kDropdownPadding / 2), kDropdownButtonWidth, kDropdownButtonHeight);
        [_topButton addTarget:self action:@selector(topButtonTapped) forControlEvents:UIControlEventTouchUpInside];

        if (_topButtonText) {
            [_notificationView addSubview:_topButton];
        }

        _bottomButton.frame = CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + kDropdownPadding, _topButton.frame.origin.y + _topButton.frame.size.height + 6, kDropdownButtonWidth, kDropdownButtonHeight);
        [_bottomButton addTarget:self action:@selector(bottomButtonTapped) forControlEvents:UIControlEventTouchUpInside];

        if (_bottomButtonText) {
            [_notificationView addSubview:_bottomButton];
        }

        if (_dismissOnTap) {

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
            tap.numberOfTapsRequired = 1;
            [_notificationView addGestureRecognizer:tap];
        }
        
        if (_dismissOnSwipeUp) {
            
            UIPanGestureRecognizer *swipeUp = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            [_notificationView addGestureRecognizer:swipeUp];
            
        }

        if (animation) {

            _animator = [[UIDynamicAnimator alloc] initWithReferenceView:[[UIApplication sharedApplication] keyWindow]];

            UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[_notificationView]];
            [_animator addBehavior:gravity];

            UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[_notificationView]];
            collision.translatesReferenceBoundsIntoBoundary = NO;
            [collision addBoundaryWithIdentifier:@"notificationEnd" fromPoint:CGPointMake(0, notificationHeight) toPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width, notificationHeight)];
            [_animator addBehavior:collision];

            UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_notificationView]];
            elasticityBehavior.elasticity = 0.3f;
            [_animator addBehavior:elasticityBehavior];
        } else {

            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

                _notificationView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, notificationHeight);
            } completion:nil];
        }

        _isBeingShown = YES;
        _gravityAnimation = animation;
    }

    _internalBlock = ^(AFDropdownNotificationEvent event) {

    };
}

-(void)topButtonTapped {

    [self.notificationDelegate dropdownNotificationTopButtonTapped];

    if (_internalBlock) {

        _internalBlock(AFDropdownNotificationEventTopButton);
    }
}

-(void)bottomButtonTapped {

    [self.notificationDelegate dropdownNotificationBottomButtonTapped];

    //    if (_internalBlock) {

    _internalBlock(AFDropdownNotificationEventBottomButton);
    //    }
}

-(void)dismiss:(id)sender {

    [self dismissWithGravityAnimation:_gravityAnimation];

    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {

        if (_internalBlock) {

            _internalBlock(AFDropdownNotificationEventTap);
        }
    } else if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        if (_internalBlock) {
            
            _internalBlock(AFDropdownNotificationEventSwipe);
        }
    }
}

-(void)dismissWithGravityAnimation:(BOOL)animation {

    if (animation) {

        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[_notificationView]];
        gravity.gravityDirection = CGVectorMake(0, -1.5);
        [_animator addBehavior:gravity];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            [_animator removeAllBehaviors];
            [self removeSubviews];
            [_notificationView removeFromSuperview];

            _isBeingShown = NO;
        });
    } else {

        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

            [_animator removeAllBehaviors];

            _notificationView.frame = CGRectMake(0, -_notificationView.frame.size.height, [[UIScreen mainScreen] bounds].size.width, _notificationView.frame.size.height);
        } completion:^(BOOL finished) {

            [self removeSubviews];
            [_notificationView removeFromSuperview];

            _isBeingShown = NO;
        }];
    }
}

-(void)removeSubviews {

    for (UIView *subiew in _notificationView.subviews) {

        [subiew removeFromSuperview];
    }
}

-(void)listenEventsWithBlock:(block)block {

    _internalBlock = ^(AFDropdownNotificationEvent event) {

        if (block) {

            block(event);
        }
    };
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:_notificationView];
        if (velocity.y < 0) {
            if (recognizer.state == UIGestureRecognizerStateEnded) {
                NSLog(@"Swipe up");
                [self dismiss:recognizer];
            }
        }
    }
}

@end
