//
//  ZemogaMobileTestTests.swift
//  ZemogaMobileTestTests
//
//  Created by Diana Ayala on 5/18/22.
//

import XCTest
@testable import ZemogaMobileTest

class ZemogaMobileTestTests: XCTestCase {
    
    // MARK: Business Functions Tests
    
    func testPost_Favorite() throws {
        let sut = Post.create(Post.self, id: -1)
        // Check if post has a false favorite by default
        XCTAssertFalse(sut.favorite, "Post favorite is not false")
        // delete created post
        try Post.deleteSingle(id: -1)
        // save
        try CoreData.save()
    }
    
    func testPost_ToggleFavorite() throws {
        let sut = Post.create(Post.self, id: -1)
        // Check if post can toggle favorite from false to true
        sut.toggleFavorite()
        XCTAssertTrue(sut.favorite, "Toggle favorite FTT didn't work")
        // and viceversa
        sut.toggleFavorite()
        XCTAssertFalse(sut.favorite, "Toggle favorite TTF didn't work")
        // delete created post
        try Post.deleteSingle(id: -1)
        // save
        try CoreData.save()
    }
    
    // MARK: API Tests

    func testPostsAPI_getAll() throws {
        let sut = PostsWS()
        let expectation = self.expectation(description: "Wait for posts to arrive")
        sut.fetchPosts { postsDTO in
            // Finish expectation
            expectation.fulfill()
            let posts = postsDTO.toPosts
            // Check if posts are arriving from the API
            XCTAssertFalse(posts.isEmpty, "Posts are not arriving")
            // Check if all posts are arriving from the API
            XCTAssertEqual(posts.count, 100, "Posts are arriving incomplete")
        } error: { errorMessage in
            // Finish expectation
            expectation.fulfill()
            // If we get here is because we have an error
            XCTAssertNil(errorMessage, errorMessage.localizedDescription)
            // Test should fail even if the error is nil
            XCTFail("Server returned Unknown error")
        }
        // Wait for service to arrive
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPostsAPI_deleteAll() throws {
        let sut = PostsWS()
        let expectation = self.expectation(description: "Wait for posts to be deleted")
        sut.deleteAllPosts {
            // Finish expectation
            expectation.fulfill()
            // Since the API doesn't really delete, we are only checking if there's a success, so the test should pass
        } error: { errorMessage in
            // Finish expectation
            expectation.fulfill()
            // If we get here is because we have an error
            XCTAssertNil(errorMessage, errorMessage.localizedDescription)
            // Test should fail even if the error is nil
            XCTFail("Server returned Unknown error")
        }
        // Wait for service to arrive
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPostsAPI_deleteSingle() throws {
        let sut = PostsWS()
        let expectation = self.expectation(description: "Wait for post to be deleted")
        sut.deletePostWithId(id: 1) {
            // Finish expectation
            expectation.fulfill()
            // Since the API doesn't really delete, we are only checking if there's a success, so the test should pass
        } error: { errorMessage in
            // Finish expectation
            expectation.fulfill()
            // If we get here is because we have an error
            XCTAssertNil(errorMessage, errorMessage.localizedDescription)
            // Test should fail even if the error is nil
            XCTFail("Server returned Unknown error")
        }
        // Wait for service to arrive
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDetailAPI_getUser() throws {
        let sut = PostDetailWS()
        let expectation = self.expectation(description: "Wait for user to arrive")
        sut.fetchUser(userID: 1) { userDTO in
            // Finish expectation
            expectation.fulfill()
            // Check if there's a user arriving
            XCTAssertNotNil(userDTO, "User didn't arrive")
            // Check if it's the right user with the right data
            XCTAssertEqual(userDTO.id, 1, "User with wrong id")
            XCTAssertEqual(userDTO.name, "Leanne Graham", "User with wrong name")
            XCTAssertEqual(userDTO.email, "Sincere@april.biz", "User with wrong email")
            XCTAssertEqual(userDTO.phone, "1-770-736-8031 x56442", "User with wrong phone")
            XCTAssertEqual(userDTO.website, "hildegard.org", "User with wrong website")
        } error: { errorMessage in
            // Finish expectation
            expectation.fulfill()
            // If we get here is because we have an error
            XCTAssertNil(errorMessage, errorMessage.localizedDescription)
            // Test should fail even if the error is nil
            XCTFail("Server returned Unknown error")
        }
        // Wait for service to arrive
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDetailAPI_getComments() throws {
        let sut = PostDetailWS()
        let expectation = self.expectation(description: "Wait for comments to arrive")
        sut.fetchComments(postId: 1) { commentsDTO in
            // Finish expectation
            expectation.fulfill()
            let comments = commentsDTO.toComments
            // Check if posts are arriving from the API
            XCTAssertFalse(comments.isEmpty, "Comments for post with id 1 are not arriving")
            // Check if all posts are arriving from the API
            XCTAssertEqual(comments.count, 5, "Comments for post with id 1 are arriving incomplete")
            // Check if it's the right data for first comment
            let firstComment = comments.first
            // Check if there's a comment
            XCTAssertNotNil(firstComment, "First comment is nil")
            XCTAssertEqual(firstComment!.id, 1, "Comment with wrong id")
            XCTAssertEqual(firstComment!.postId, 1, "Comment with wrong post id")
            XCTAssertEqual(firstComment!.body, "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium", "Comment with wrong body")
        } error: { errorMessage in
            // Finish expectation
            expectation.fulfill()
            // If we get here is because we have an error
            XCTAssertNil(errorMessage, errorMessage.localizedDescription)
            // Test should fail even if the error is nil
            XCTFail("Server returned Unknown error")
        }
        // Wait for service to arrive
        waitForExpectations(timeout: 5, handler: nil)
    }

}
