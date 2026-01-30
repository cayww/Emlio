import SwiftData
import SwiftUI

struct DetailView: View {

  var postItem: PostData

  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject private var appState: AppState
  @Environment(\.modelContext) private var modelContext
  @State private var showSheet = false
  @Query private var following: [FollowData]
  @Query private var recreates: [RecreateData]
  @Query private var comments: [CommentData]
  @Query private var postLikes: [PostLikeData]
  @State private var commentText: String = ""
  @State private var showBlockSheet = false
  init(postItem: PostData) {
    self.postItem = postItem
    let userID = postItem.user.id
    let postID = postItem.id
    _following = Query(filter: #Predicate { $0.toUser.id == userID })
    _recreates = Query(filter: #Predicate { $0.post.id == postID })
    _comments = Query(filter: #Predicate { $0.post.id == postID })
    _postLikes = Query(filter: #Predicate { $0.post.id == postID })
  }

  var followingUserIDs: Set<UUID> {
    Set(following.map { $0.fromUser.id })
  }

  var body: some View {

    ScrollView {
      content
    }
    .scrollIndicators(.hidden)
    .scrollBounceBehavior(.basedOnSize)
    .padding(.horizontal, 16)
    .background(
      ZStack(alignment: .top) {
        DefaultBackground()
        Color
          .black
          .opacity(0.6)
          .frame(height: 480)
          .ignoresSafeArea()
      }
    )
    .safeAreaInset(edge: .bottom) {
      bottomInputBar
    }
    .sheet(isPresented: $showSheet) {
      commentBottomSheet
        .presentationCornerRadius(30)
        .presentationDetents([.height(440), .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(
          RadialGradient(
            gradient: Gradient(colors: [
              Color(red: 73 / 255, green: 36 / 255, blue: 88 / 255),
              Color(red: 23 / 255, green: 6 / 255, blue: 28 / 255),
            ]),
            center: UnitPoint(x: 1.0, y: 0.295),
            startRadius: 0,
            endRadius: 400
          )
        )
    }
    .navigationBarBackButtonHidden(true)
    .toolbar { toolbarContent }

  }
}

extension DetailView {
  fileprivate var content: some View {
    VStack(spacing: 0) {
      Spacer().frame(height: 20)

      postItem.postImage
        .resizable()
        .scaledToFill()
        .frame(height: 440)
        .cornerRadius(20)

      Spacer().frame(height: 20)

      Text(postItem.content)
        .foregroundColor(.white.opacity(0.7))
        .font(.system(size: 18))
        .frame(maxWidth: .infinity, alignment: .leading)

      Spacer().frame(height: 30)

      Text("Replicated jewelry")
        .foregroundColor(Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255))
        .font(.system(size: 16))
        .frame(maxWidth: .infinity, alignment: .leading)

      Spacer().frame(height: 12)

      recreateScroll
    }
  }
}

extension DetailView {
  fileprivate var recreateScroll: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 13) {
        ForEach(recreates, id: \.id) { recreate in
          recreate.imageImage
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 160)
            .cornerRadius(20)
        }

        Image("Assets/emlio_recreate_add")
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
          .frame(width: 120, height: 160)
          .background(.white.opacity(0.1))
          .cornerRadius(20)
          .onTapGesture {
            router.path.append(MainRoute.addRecreate(postItem: postItem))
          }
      }
    }
  }
}

extension DetailView {
  fileprivate var bottomInputBar: some View {
    HStack(spacing: 20) {
      TextField(
        "", text: $commentText,
        prompt: Text("Add Comment")
          .foregroundColor(.gray)
          .font(.system(size: 13, weight: .regular)),
      )
      .submitLabel(.send)
      .foregroundColor(.white)
      .padding(.horizontal, 16)
      .padding(.trailing, 50)
      .frame(height: 40)
      .background(Color(red: 97 / 255, green: 95 / 255, blue: 102 / 255))
      .cornerRadius(20)
      .onSubmit {
        sendComment()
      }
      VStack(spacing: 3) {
        Image("Assets/emlio_comment_icon")
          .resizable()
          .scaledToFit()
          .frame(width: 24, height: 24)
          .onTapGesture {
            showSheet = true
          }
        Text("\(comments.count)")
          .font(.system(size: 11, weight: .regular))
          .foregroundColor(.white.opacity(0.5))
      }
      VStack(spacing: 3) {

        Image(systemName: "heart.fill")
          .resizable()
          .scaledToFit()
          .frame(width: 24, height: 24)
          .foregroundColor(
            !isLiked ? .white.opacity(0.5) : Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255)
          )
          .onTapGesture {
            toggleLikePost()
          }
        Text("\(postLikes.count)")
          .font(.system(size: 11, weight: .regular))
          .foregroundColor(.white.opacity(0.5))
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 6)
    .background(
      Color.black
        .ignoresSafeArea(edges: .bottom)
    )
  }
}

extension DetailView {
  @ToolbarContentBuilder
  fileprivate var toolbarContent: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      HStack {
        Button {
          router.path.removeLast()
        } label: {
          Image("Assets/emlio_back")
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
        }

        postItem.user.photoImage
          .resizable()
          .scaledToFill()
          .frame(width: 39, height: 39)
          .clipShape(Circle())
          .overlay(
            Circle().stroke(
              Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255),
              lineWidth: 1
            )
          )

        Text(postItem.user.name)
          .font(.system(size: 15))
          .foregroundColor(.white)
          .lineLimit(1)
      }
    }

    if appState.currentUser?.id != postItem.user.id {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        if !followingUserIDs.contains(appState.currentUser!.id) {
          Image(systemName: "plus")
            .resizable()
            .scaledToFit()
            .frame(width: 12, height: 12)
            .foregroundColor(.white)
            .frame(width: 48, height: 24)
            .background(
              Capsule()
                .fill(Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255))
            )
            .onTapGesture {
              let follow = FollowData(
                fromUser: appState.currentUser!,
                toUser: postItem.user
              )
              modelContext.insert(follow)
              try? modelContext.save()
            }
        }

        Image("Assets/emlio_report_icon")
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
          .onTapGesture {
            showSheet = true
          }
      }
    }
  }
}

extension DetailView {
  fileprivate func sendComment() {
    guard !commentText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
    let comment = CommentData(
      user: appState.currentUser!,
      post: postItem,
      content: commentText
    )
    modelContext.insert(comment)
    try? modelContext.save()
    commentText = ""
  }
}

extension DetailView {
  var postLikeUserIDs: [UUID] {
    postLikes.map { $0.user.id }
  }
  var isLiked: Bool {
    postLikeUserIDs.contains(appState.currentUser!.id)
  }
  fileprivate func toggleLikePost() {
    if isLiked {
      modelContext.delete(postLikes.first(where: { $0.user.id == appState.currentUser!.id })!)
    } else {
      let like = PostLikeData(user: appState.currentUser!, post: postItem)
      modelContext.insert(like)
    }
    try? modelContext.save()
  }
}

extension DetailView {
  fileprivate var commentBottomSheet: some View {
    VStack {
      Spacer().frame(height: 30)
      Text("\(comments.count) comments")
        .foregroundColor(.white)
        .bold()
        .font(.system(size: 18))
      Spacer().frame(height: 20)
      if comments.isEmpty {
        Empty()
          .frame(maxHeight: .infinity, alignment: .center)
      } else {
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 20) {
            ForEach(comments, id: \.id) { comment in
              HStack(alignment: .top, spacing: 12) {
                comment.user.photoImage
                  .resizable()
                  .scaledToFill()
                  .frame(width: 44, height: 44)
                  .clipShape(Circle())
                VStack(alignment: .leading, spacing: 6) {
                  Text(comment.user.name)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .bold))
                  Text(comment.content)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 13, weight: .regular))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
              }
              .padding(.horizontal, 16)
            }
          }
        }
        .scrollBounceBehavior(.basedOnSize)
      }
      Spacer()
    }
    .safeAreaInset(edge: .bottom) {
      TextField(
        "", text: $commentText,
        prompt: Text("Add Comment")
          .foregroundColor(.gray)
          .font(.system(size: 13, weight: .regular)),
      )
      .submitLabel(.done)
      .foregroundColor(.white)
      .padding(.horizontal, 16)
      .padding(.trailing, 50)
      .frame(height: 40)
      .background(Color(red: 97 / 255, green: 95 / 255, blue: 102 / 255))
      .cornerRadius(20)
      .overlay(
        Image("Assets/emlio_send_icon")
          .resizable()
          .scaledToFit()
          .frame(width: 60, height: 40)
          .onTapGesture {
            sendComment()
          }, alignment: .trailing
      )
      .padding(.horizontal, 10)
      .padding(.top, 6)
      .background(
        Color.black
          .ignoresSafeArea(edges: .bottom)
      )
    }
  }
}
