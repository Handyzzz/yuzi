//
//  WithyouTests.m
//  WithyouTests
//
//  Created by Handyzzz on 2017/7/5.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

/*
 单元测试的内容：
 
 单元测试的测试目的
 模块接口测试
 局部数据结构测试
 路径测试
 错误处理测试
 边界测试
 */
/*
 XCTest测试范畴：
 
 基本逻辑测试处理测试
 异步加载数据测试
 数据mock测试
 */
/*
 1.：单元测试类继承自XCTestCase，他有一些重要的方法，其中最重要的有3个， setUp ,tearDown,measureBlock
 2.测试函数的要求是：1.必须无返回值；2.以test开头  该类中以test开头的方法且void返回类型的方法都会变成单元测试用例
 3.测试函数执行的顺序：以函数名中test后面的字符大小有关，比如-（void）test001XXX会先于-（void）test002XXX执行；
*/

/*
 快捷键
 cmd + 5 切换到测试选项卡后会看到很多小箭头，点击可以单独或整体测试
 cmd + U 运行整个单元测试
 */

/*
 断言:大部分的测试方法使用断言决定的测试结果。所有断言都有一个类似的形式：比较，表达式为真假，强行失败等。
 1.通用断言
 XCTAssert(expression, format...)
 
 2.常用断言：
 
 //失败断言
 XCTFail(format…)
 //为空判断，a1为空时通过，反之不通过；
 XCTAssertNil(a1, format...)
 //不为空判断，a1不为空时通过，反之不通过；
 XCTAssertNotNil(a1, format…)
 //当expression求值为TRUE时通过；
 XCTAssert(expression, format...)
 //当expression求值为TRUE时通过；
 XCTAssertTrue(expression, format...)
 //当expression求值为False时通过；
 XCTAssertFalse(expression, format...)
 //判断相等，[a1 isEqual:a2]值为TRUE时通过，其中一个不为空时，不通过；
 XCTAssertEqualObjects(a1, a2, format...)
 //判断不等，[a1 isEqual:a2]值为False时通过；
 XCTAssertNotEqualObjects(a1, a2, format...)
 //判断相等（当a1和a2是 C语言标量、结构体或联合体时使用,实际测试发现NSString也可以）；
 XCTAssertEqual(a1, a2, format...)
 //判断不等（当a1和a2是 C语言标量、结构体或联合体时使用）；
 XCTAssertNotEqual(a1, a2, format...)
 //判断相等，（double或float类型）提供一个误差范围，当在误差范围（+/-accuracy）以内相等时通过测试；
 XCTAssertEqualWithAccuracy(a1, a2, accuracy, format...)
 //判断不等，（double或float类型）提供一个误差范围，当在误差范围以内不等时通过测试；
 XCTAssertNotEqualWithAccuracy(a1, a2, accuracy, format...)
 //异常测试，当expression发生异常时通过，反之不通过；
 XCTAssertThrows(expression, format...)
 //异常测试，当expression发生specificException异常时通过；反之发生其他异常或不发生异常均不通过
 XCTAssertThrowsSpecific(expression, specificException, format...)
 //异常测试，当expression发生具体异常、具体异常名称的异常时通过测试，反之不通过；
 XCTAssertThrowsSpecificNamed(expression, specificException, exception_name, format...)
 //异常测试，当expression没有发生异常时通过测试；
 XCTAssertNoThrow(expression, format…)
 //异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过；
 XCTAssertNoThrowSpecific(expression, specificException, format...)
 //异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过
 XCTAssertNoThrowSpecificNamed(expression, specificException, exception_name, format...)
 */


#import <XCTest/XCTest.h>

@interface WithyouTests : XCTestCase

@end

@implementation WithyouTests
//每次测试前调用，可以在测试之前创建在test case方法中需要用到的一些对象等
- (void)setUp {
    [super setUp];
    
}

//每次测试结束时调用tearDown方法
- (void)tearDown {
    
    [super tearDown];
}


- (void)testExample {
    //设置变量和设置预期值
    NSUInteger a = 10;NSUInteger b = 15;
    NSUInteger expected = 24;
    //执行方法得到实际值
    NSUInteger actual = [self add:a b:b];
    
    //断言判定实际值和预期是否符合
//    XCTAssertEqual(expected, actual,@"add方法错误！");
}
-(NSUInteger)add:(NSUInteger)a b:(NSUInteger)b{
    return a+b;
}

- (void)testPerformanceExample {
    //性能测试方法，通过测试block中方法执行的时间，比对设定的标准值和偏差觉得是否可以通过测试
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



@end
