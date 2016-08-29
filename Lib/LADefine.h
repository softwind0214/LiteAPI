//
//  LADefine.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#ifndef LADefine_h
#define LADefine_h

typedef NS_ENUM(NSInteger, LAStatus) {
    LAStatusProduction,             //!< suggested status for Release
    LAStatusBeta,                   //!< suggested status for Test
    LAStatusDevelop,                //!< suggested status for Develop
};

typedef NS_ENUM(NSInteger, LAPostStyle) {
    LAPostStyleForm,                //!< Form format post body
    LAPostStyleJSON,                //!< JSON format post body
    LAPostStyleCustom,              //!< Custom format post body
};

typedef NS_ENUM(NSInteger, LAMethod) {
    LAMethodGET,
    LAMethodPOST,
    LAMethodPUT,
    LAMethodDELETE,
};

typedef NS_ENUM(NSInteger, LAResponseStyle) {
    LAResponseStyleStream,          //!< API returns original binary data from network response.
    LAResponseStyleJSON,            //!< API returns JSON formatted data.
    LAResponseStyleCustom           //!< API returns customize data.
};

typedef NS_ENUM(NSInteger, LAThread) {
    LAThreadCurrent,
    LAThreadMain,
    LAThreadBackground,
};

typedef NSString * LAIdentifier;    //!< type of identifier of API template

#ifdef DEBUG
    #define LALog(format, ...) LALog0(format, ##__VA_ARGS__)
    #define LALog0(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
    #define LALog(format, ...)
#endif

#define LAPersistantKey     @"$LiteAPIPersistant$"

#define LAntoa(n)   [@(n) stringValue]

#endif /* LADefine_h */
