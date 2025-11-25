import Foundation

public struct Post: Codable, Identifiable, Hashable
{
    public let userId: Int
    public let id: Int
    public let title: String
    public let body: String
}
