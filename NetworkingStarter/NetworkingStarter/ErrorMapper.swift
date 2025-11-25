import Foundation
enum NetError: LocalizedError, Equatable
{
    case http(status:Int)
    case url(URLError.Code)
    case decoding
    case unknown(String)
    
    var errorDescription: String?
    {
        switch self
        {
        case .http(let status): return "Server returned \(status)."
        case .url(let code):
            switch code
            {
            case .notConnectedToInternet: return "No internet conection"
            case .timedOut: return "The request timed out."
            case .cannotFindHost, .cannotConnectToHost: return "cannot reach the server."
            case .networkConnectionLost: return "Network connection was lost."
            default: return "Network error: (\(code.rawValue)"
            }
        case .decoding: return "Failed to read data from server."
        case .unknown(let msg): return msg
        }
    }
}

func mapError(_ error: Error) -> NetError
{
    if let urlErr = error as? URLError
    {
        return .url(urlErr.code)
    }
    if error is DecodingError
    {
        return .decoding
    }
    if let err = error as NSError?, err.domain == NSURLErrorDomain
    {
        return .url(URLError.Code(rawValue:err.code))
    }
    return .unknown(error.localizedDescription)
}
