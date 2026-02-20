#import <XCTest/XCTest.h>
#import "NSUserActivity+WMFExtensions.h"

@interface NSUserActivity_WMFExtensions_wmf_activityForWikipediaScheme_Test : XCTestCase
@end

@implementation NSUserActivity_WMFExtensions_wmf_activityForWikipediaScheme_Test

- (void)testURLWithoutWikipediaSchemeReturnsNil {
    NSURL *url = [NSURL URLWithString:@"http://www.foo.com"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testInvalidArticleURLReturnsNil {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/Foo"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testArticleURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/wiki/Foo"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLink);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString, @"https://en.wikipedia.org/wiki/Foo");
}

- (void)testExploreURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://explore"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeExplore);
}

- (void)testSavedURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://saved"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeSavedPages);
}

- (void)testSearchURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/w/index.php?search=dog"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLink);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString,
                          @"https://en.wikipedia.org/w/index.php?search=dog&title=Special:Search&fulltext=1");
}

- (void)testPlacesWithArticleURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?WMFArticleURL=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FAmsterdam"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString, @"https://en.wikipedia.org/wiki/Amsterdam");
    XCTAssertNil(activity.userInfo[@"latitude"]);
    XCTAssertNil(activity.userInfo[@"longitude"]);
}

- (void)testPlacesWithCoordinates {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?latitude=52.3676&longitude=4.9041"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertNil(activity.webpageURL);
    XCTAssertEqualWithAccuracy([activity.userInfo[@"latitude"] doubleValue], 52.3676, 0.0001);
    XCTAssertEqualWithAccuracy([activity.userInfo[@"longitude"] doubleValue], 4.9041, 0.0001);
}

- (void)testPlacesWithCoordinatesAndName {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?latitude=52.3676&longitude=4.9041&name=Amsterdam"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertNil(activity.webpageURL);
    XCTAssertEqualWithAccuracy([activity.userInfo[@"latitude"] doubleValue], 52.3676, 0.0001);
    XCTAssertEqualWithAccuracy([activity.userInfo[@"longitude"] doubleValue], 4.9041, 0.0001);
    XCTAssertEqualObjects(activity.userInfo[@"name"], @"Amsterdam");
}

- (void)testPlacesWithNoParams {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertNil(activity.webpageURL);
    XCTAssertNil(activity.userInfo[@"latitude"]);
    XCTAssertNil(activity.userInfo[@"longitude"]);
}

@end
