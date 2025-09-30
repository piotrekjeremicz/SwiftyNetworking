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
            .headers {
                Accept.json
                ContentType.json
                CacheControl.maxAge(60)
            }
            .queryItems {
                Key("flag", value: true)
            }
            .body {
                Key("message", value: message)
            }
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

let group = Key("dictionary") {
    Key("int", value: 1)
    Key("double", value: 3.14)
    Key("string", value: "foo")
    Key("boolean", value: true)
    Key("null", value: Optional<String>.none)
    Key("arrays") {
        Key("int", value: [1, 2, 3])
        Key("double", value: [3.14, 1.71, 1.41])
        Key("string", value: ["foo", "bar", "baz"])
        Key("boolean", value: [true, false, true])
        Key("null", value: ["foo", nil, "baz"])
        Key("foo") {
            Key("bar", value: "baz")
        }
    }
}
