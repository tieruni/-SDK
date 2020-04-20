//
//  BUDExpressInterstitialViewController.m
//  BUDemo
//
//  Created by xxx on 2019/5/15.
//  Copyright © 2019 bytedance. All rights reserved.
//

#import "BUDExpressInterstitialViewController.h"
#import <BUAdSDK/BUNativeExpressInterstitialAd.h>
#import "BUDMacros.h"
#import "BUDSlotID.h"
#import <BUAdSDK/BUSize.h>
#import "NSString+LocalizedString.h"
#import "BUDSelectedView.h"

@interface BUDExpressInterstitialViewController ()<BUNativeExpresInterstitialAdDelegate>
@property (nonatomic, strong) BUNativeExpressInterstitialAd *interstitialAd;
@property (nonatomic, strong) BUDSelectedView *selectedView;
@property (nonatomic, copy) NSDictionary *sizeDict;
@end

@implementation BUDExpressInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.sizeDict = @{
                      express_interstitial_ID_1_1:[NSValue valueWithCGSize:CGSizeMake(300, 300)],
                      express_interstitial_ID_2_3:[NSValue valueWithCGSize:CGSizeMake(300, 450)],
                      express_interstitial_ID_3_2:[NSValue valueWithCGSize:CGSizeMake(300, 200)],
                      express_interstitial_ID_overSeas:[NSValue valueWithCGSize:CGSizeMake(300, 300)],
                      };
    BUDSelcetedItem *item1 = [[BUDSelcetedItem alloc] initWithDict:@{@"slotID":express_interstitial_ID_1_1,@"title":@"1:1"}];
    BUDSelcetedItem *item2 = [[BUDSelcetedItem alloc] initWithDict:@{@"slotID":express_interstitial_ID_2_3,@"title":@"2:3"}];
    BUDSelcetedItem *item3 = [[BUDSelcetedItem alloc] initWithDict:@{@"slotID":express_interstitial_ID_3_2,@"title":@"3:2"}];
    BUDSelcetedItem *item4 = [[BUDSelcetedItem alloc] initWithDict:@{@"slotID":express_interstitial_ID_overSeas,@"title":@"overSeas"}];
    NSArray *titlesAndIDS = @[@[item1,item2],@[item3,item4]];
    
    __weak typeof(self) weakself = self;
    self.selectedView = [[BUDSelectedView alloc] initWithAdName:@"Express Interstital" SelectedTitlesAndIDS:titlesAndIDS loadAdAction:^(NSString * _Nullable slotId) {
        __strong typeof(self) strongself = weakself;
        [strongself loadInterstitialWithSlotID:slotId];
    } showAdAction:^{
        __strong typeof(self) strongself = weakself;
        [strongself showInterstitial];
    }];
    [self.view addSubview:self.selectedView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)loadInterstitialWithSlotID:(NSString *)slotID {
    NSValue *sizeValue = [self.sizeDict objectForKey:slotID];
    CGSize size = [sizeValue CGSizeValue];
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)-40;
    CGFloat height = width/size.width*size.height;
#warning 升级的用户请注意，初始化方法去掉了imgSize参数
    self.interstitialAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:slotID adSize:CGSizeMake(width, height)];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAdData];
    self.selectedView.promptStatus = BUDPromptStatusLoading;
}

- (void)showInterstitial {
    if (self.interstitialAd) {
        [self.interstitialAd showAdFromRootViewController:self];
    }
    self.selectedView.promptStatus = BUDPromptStatusDefault;
}

#pragma ---BUNativeExpresInterstitialAdDelegate
- (void)nativeExpresInterstitialAdDidLoad:(BUNativeExpressInterstitialAd *)interstitialAd {
    BUD_Log(@"%s",__func__);
}

- (void)nativeExpresInterstitialAd:(BUNativeExpressInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    self.selectedView.promptStatus = BUDPromptStatusAdLoadedFail;
    BUD_Log(@"%s",__func__);
}

- (void)nativeExpresInterstitialAdRenderSuccess:(BUNativeExpressInterstitialAd *)interstitialAd {
    self.selectedView.promptStatus = BUDPromptStatusAdLoaded;
    BUD_Log(@"%s",__func__);
}

- (void)nativeExpresInterstitialAdRenderFail:(BUNativeExpressInterstitialAd *)interstitialAd error:(NSError *)error {
    self.selectedView.promptStatus = BUDPromptStatusAdLoadedFail;
    BUD_Log(@"%s",__func__);
    NSLog(@"error code : %ld , error message : %@",(long)error.code,error.description);
}

- (void)nativeExpresInterstitialAdWillVisible:(BUNativeExpressInterstitialAd *)interstitialAd {
    BUD_Log(@"%s",__func__);
}

- (void)nativeExpresInterstitialAdDidClick:(BUNativeExpressInterstitialAd *)interstitialAd {
    BUD_Log(@"%s",__func__);
}

- (void)nativeExpresInterstitialAdWillClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    BUD_Log(@"%s",__func__);
}

- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    BUD_Log(@"%s",__func__);
}

- (void)nativeExpresInterstitialAdDidCloseOtherController:(BUNativeExpressInterstitialAd *)interstitialAd interactionType:(BUInteractionType)interactionType {
    NSString *str = nil;
    if (interactionType == BUInteractionTypePage) {
        str = @"ladingpage";
    } else if (interactionType == BUInteractionTypeVideoAdDetail) {
        str = @"videoDetail";
    } else {
        str = @"appstoreInApp";
    }
    BUD_Log(@"%s __ %@",__func__,str);
}

@end
