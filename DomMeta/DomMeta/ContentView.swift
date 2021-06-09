//
//  ContentView.swift
//  DomMeta
//
//  Created by Daniel Watson on 08/06/2021.
//

import SwiftUI

struct Meta: Hashable {
    var meta_key = ""
    var meta_value = ""
}

class Post {
    var post_id: UUID
    var content: String
    var meta: [Meta]
    
    init() {
        self.post_id = UUID()
        self.content = ""
        self.meta = [Meta]()
    }
    func AddMeta(key: String, value: String) {
        var meta = Meta()
        meta.meta_key = key
        meta.meta_value = value
        self.meta.append(meta)
    }
}
class ContentViewModel: ObservableObject {
    
    @Published var key = ""
    @Published var value = ""
    @Published var content = ""
    @Published var meta = [Meta]()
    @Published var posts = [Post]()
    
    func CreatePost() {
        let post = Post()
        post.content = self.content
        post.meta = self.meta
        self.posts.append(post)
        self.content = ""
        self.meta.removeAll()
    }
    func AddMeta() {
        var meta = Meta()
        meta.meta_key = self.key
        meta.meta_value = self.value
        self.meta.append(meta)
        self.key = ""
        self.value = ""
    }
}

struct ContentView: View {
    @StateObject var VM = ContentViewModel()
    
    var body: some View {
        VStack {
            Text("Make a Post")
            TextField("Content", text: $VM.content)
            TextField("Key", text: $VM.key)
            TextField("Value", text: $VM.value)
            Button("Add Meta") {
                VM.AddMeta()
            }
            Button("Add Post") {
                VM.CreatePost()
            }
            Spacer()
            Text("POSTS")
            ForEach(VM.posts, id: \.post_id) { post in
                PostCard(post: post)
            }
        }
    }
}

struct PostCard: View {
    var post: Post
    var body: some View {
        VStack {
            Text(post.content)
                .font(.largeTitle)
            ForEach(post.meta, id: \.meta_key) { meta in
                HStack {
                    Text(meta.meta_key)
                    Text(meta.meta_value)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
