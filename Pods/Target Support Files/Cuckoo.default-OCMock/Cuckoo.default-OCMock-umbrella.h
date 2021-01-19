#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Cuckoo-BridgingHeader.h"
#import "NSInvocation+OCMockWrapper.h"
#import "NSObject+TrustMe.h"
#import "ObjectiveCatcher.h"
#import "OCMockObject+CuckooMockObject.h"
#import "OCMockObject+Workaround.h"
#import "StringProxy.h"

FOUNDATION_EXPORT double CuckooVersionNumber;
FOUNDATION_EXPORT const unsigned char CuckooVersionString[];

