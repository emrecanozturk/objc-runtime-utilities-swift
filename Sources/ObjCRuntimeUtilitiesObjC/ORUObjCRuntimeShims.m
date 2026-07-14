#import "ObjCRuntimeUtilitiesObjC/ORUObjCRuntimeShims.h"

BOOL ORUExchangeInstanceMethods(Class cls, SEL originalSelector, SEL replacementSelector) {
    if (cls == Nil || originalSelector == NULL || replacementSelector == NULL) {
        return NO;
    }

    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method replacementMethod = class_getInstanceMethod(cls, replacementSelector);

    if (originalMethod == NULL || replacementMethod == NULL) {
        return NO;
    }

    BOOL didAddMethod = class_addMethod(
        cls,
        originalSelector,
        method_getImplementation(replacementMethod),
        method_getTypeEncoding(replacementMethod)
    );

    if (didAddMethod) {
        class_replaceMethod(
            cls,
            replacementSelector,
            method_getImplementation(originalMethod),
            method_getTypeEncoding(originalMethod)
        );
    } else {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }

    return YES;
}

BOOL ORUExchangeClassMethods(Class cls, SEL originalSelector, SEL replacementSelector) {
    if (cls == Nil) {
        return NO;
    }

    Class metaclass = object_getClass((id)cls);
    return ORUExchangeInstanceMethods(metaclass, originalSelector, replacementSelector);
}

NSArray<NSString *> *ORUCopyClassNamesWithPrefix(NSString * _Nullable prefix) {
    int expectedClassCount = objc_getClassList(NULL, 0);
    if (expectedClassCount <= 0) {
        return @[];
    }

    Class *classes = (__unsafe_unretained Class *)calloc((size_t)expectedClassCount, sizeof(Class));
    if (classes == NULL) {
        return @[];
    }

    int actualClassCount = objc_getClassList(classes, expectedClassCount);
    NSMutableArray<NSString *> *names = [NSMutableArray arrayWithCapacity:(NSUInteger)actualClassCount];

    for (int index = 0; index < actualClassCount; index++) {
        Class cls = classes[index];
        const char *name = class_getName(cls);
        if (name == NULL) {
            continue;
        }

        NSString *className = [NSString stringWithUTF8String:name];
        if (prefix == nil || [className hasPrefix:prefix]) {
            [names addObject:className];
        }
    }

    free(classes);
    return [names sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}
