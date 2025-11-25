import Foundation

struct APIClient
{
    var baseURL: URL = URL(string:"https://jsonplaceholder.typicode.com")!
    
    func fetchPosts(userId: Int?) async throws -> [Post]
    {
        var components = URLComponents(url:baseURL.appendingPathComponent("userId"),
                                       resolvingAgainstBaseURL: false)!
        if let userId = userId
        {
            components.queryItems = [URLQueryItem(name:"userId", value:String(userId))]
        }
        
        let url = components.url!
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.timeoutInterval = 15
        
        let(data,response) = try await URLSession.shared.data(for:request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else
        {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([Post].self, from:data)
    }
}
