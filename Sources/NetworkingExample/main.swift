//
//  main.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

import Networking

struct GetPostRequest: Request {
    let postId: Int
    
    var body: some Request {
        Get("posts", postId)
    }
}

struct PostCommentRequest: Request {
    let postId: Int
    let message: String
    
    var body: some Request {
        Post("posts", postId, "comment")
            .body(message.data(using: .utf8))
    }
}

struct DeleteCommentRequest: Request {
    let commentId: Int
    
    var body: some Request {
        Delete("comments", commentId)
    }
}

let getPostRequest = GetPostRequest(postId: 4)
let postCommentRequest = PostCommentRequest(postId: 4, message: "Hello, world!")
let deleteCommentRequest = DeleteCommentRequest(commentId: 123)
