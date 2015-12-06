//
//  AFDropdownNotification.h
//  AFDropdownNotification-Demo
//
//  Created by Alvaro Franco on 21/08/14.
//  Copyright (c) 2014 AluanaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol AFDropdownNotificationDelegate <NSObject>

-(void)dropdownNotificationTopButtonTapped;
-(void)dropdownNotificationBottomButtonTapped;

@end

@interface AFDropdownNotification : NSObject

typedef NS_ENUM(NSInteger, AFDropdownNotificationEvent) {
    AFDropdownNotificationEventTopButton,
    AFDropdownNotificationEventBottomButton,
    AFDropdownNotificationEventTap,
    AFDropdownNotificationEventSwipe
};

typedef void (^block)(AFDropdownNotificationEvent event);

@property (nonatomic, strong) id<AFDropdownNotificationDelegate> notificationDelegate;

@property (nonatomic, strong) UIView *notificationView;
@property (nonatomic) CGFloat notificationHeight;

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *subtitleText;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) CGFloat imageHeight;

@property (nonatomic, strong) NSString *topButtonText;
@property (nonatomic, strong) NSString *bottomButtonText;
@property (nonatomic, strong) UIFont *titleLabelFont;
@property (nonatomic, strong) UIColor *titleLabelColor;
@property (nonatomic, strong) UIFont *subtitleLabelFont;
@property (nonatomic, strong) UIColor *subtitleLabelColor;
@property (nonatomic, strong) UIFont *buttonFont;
@property (nonatomic, strong) UIColor *topButtonTextColor;
@property (nonatomic, strong) UIColor *topButtonBackgroundColor;
@property (nonatomic, strong) UIColor *topButtonBorderColor;
@property (nonatomic, strong) UIColor *bottomButtonTextColor;
@property (nonatomic, strong) UIColor *bottomButtonBackgroundColor;
@property (nonatomic, strong) UIColor *bottomButtonBorderColor;
@property (nonatomic) CGFloat buttonCornerRadius;
@property (nonatomic) CGFloat buttonBorderWidth;
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle;

@property (nonatomic) BOOL isBeingShown;
@property (nonatomic) BOOL isImageRounded;

-(void)listenEventsWithBlock:(block)block;

-(void)presentInView:(UIView *)view withGravityAnimation:(BOOL)animation;
-(void)dismissWithGravityAnimation:(BOOL)animation;

@property (nonatomic) BOOL dismissOnTap;
@property (nonatomic) BOOL dismissOnSwipeUp;

@end
