import Foundation
import SwiftUI

@MainActor
final class PostsViewModel: ObservableObject
{
    @Published var posts: [Post] = []
    @Published var state: LoadedState = .idle
    @Published var selectedUserId: Int? = nil
    
    enum LoadedState: Equatable
    {
        case idle, loading, loaded, failed(NetError)
    }
    
    private let api = APIClient()
    
    func load() async
    {
        state = .loading
        do
        {
            let out = try await api.fetchPosts(userId: selectedUserId)
            self.posts = out
            self.state = .loaded
        } catch {
            self.state = .failed(mapError(error))
        }
    }
}
