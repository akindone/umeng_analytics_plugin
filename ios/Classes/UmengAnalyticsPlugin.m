#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import "UmengAnalyticsPlugin.h"

@implementation UmengAnalyticsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"jitao.tech/umeng_analytics_plugin"
                                     binaryMessenger:[registrar messenger]];
    UmengAnalyticsPlugin* instance = [[UmengAnalyticsPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        [self init:call result:result];
    } else if ([@"pageStart" isEqualToString:call.method]) {
        [self pageStart:call result:result];
    } else if ([@"pageEnd" isEqualToString:call.method]) {
        [self pageEnd:call result:result];
    } else if ([@"event" isEqualToString:call.method]) {
        [self event:call result:result];
    } else if ([@"eventObject" isEqualToString:call.method]) {
        [self eventObject:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)init:(FlutterMethodCall*)call result:(FlutterResult)result {
    // NSString * deviceID =[UMConfigure deviceIDForIntegration];
    // NSLog(@"集成测试的deviceID:%@", deviceID);
    [UMConfigure initWithAppkey:call.arguments[@"iosKey"] channel:call.arguments[@"channel"]];
    [UMConfigure setLogEnabled:call.arguments[@"logEnabled"]];
    [UMConfigure setEncryptEnabled:call.arguments[@"encryptEnabled"]];
    [UMConfigure setLogEnabled:[call.arguments[@"sessionContinueMillis"] doubleValue]];
//    UMConfigInstance.bCrashReportEnabled = call.arguments[@"catchUncaughtExceptions"];
    result([NSNumber numberWithBool:YES]);
}

- (void)pageStart:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* viewName = call.arguments[@"viewName"];
    [MobClick beginLogPageView:viewName];
    result([NSNumber numberWithBool:YES]);
}

- (void)pageEnd:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* viewName = call.arguments[@"viewName"];
    [MobClick endLogPageView:viewName];
    result([NSNumber numberWithBool:YES]);
}

- (void)event:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* eventId = call.arguments[@"eventId"];
    NSString* label = call.arguments[@"label"];
    if (label == nil) {
        [MobClick event:eventId];
    } else {
        [MobClick event:eventId label:label];
    }
    result([NSNumber numberWithBool:YES]);
}

- (void)eventObject:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* eventId = call.arguments[@"eventId"];
    NSString* jsonString = call.arguments[@"paramJson"];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        result([NSNumber numberWithBool:NO]);
    } else {
        [MobClick event:eventId attributes:dic];
        result([NSNumber numberWithBool:YES]);
    }
}

@end
