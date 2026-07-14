#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT BOOL ORUExchangeInstanceMethods(Class cls, SEL originalSelector, SEL replacementSelector);
FOUNDATION_EXPORT BOOL ORUExchangeClassMethods(Class cls, SEL originalSelector, SEL replacementSelector);
FOUNDATION_EXPORT NSArray<NSString *> *ORUCopyClassNamesWithPrefix(NSString * _Nullable prefix);

NS_ASSUME_NONNULL_END
