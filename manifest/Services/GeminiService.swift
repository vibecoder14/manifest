//
//  GeminiService.swift
//  manifest
//
//  Created by Ferhat Okan İdem on 6.06.2025.
//

import Foundation

// Represents the structure for the request body sent to the Gemini API.
private struct GeminiRequest: Encodable {
    let contents: [Content]
    
    struct Content: Encodable {
        let parts: [Part]
    }

    struct Part: Encodable {
        let text: String
    }
}

// Represents the top-level structure of the response from the Gemini API.
private struct GeminiResponse: Decodable {
    let candidates: [Candidate]
    
    // Extracts the generated text from the response.
    var generatedText: String? {
        return candidates.first?.content.parts.first?.text
    }
}

// Represents a candidate response from the API.
private struct Candidate: Decodable {
    let content: Content
    
    struct Content: Decodable {
        let parts: [Part]
        let role: String
    }
    
    struct Part: Decodable {
        let text: String
    }
}

// Custom error type for the Gemini Service for clearer error handling.
enum GeminiError: Error, LocalizedError {
    case failedToEncode
    case invalidResponse(String)
    case failedToDecode
    case noGeneratedText
    
    var errorDescription: String? {
        switch self {
        case .failedToEncode:
            return "Failed to encode request body."
        case .invalidResponse(let responseBody):
            return "Invalid response from Gemini API: \(responseBody)"
        case .failedToDecode:
            return "Failed to decode Gemini response."
        case .noGeneratedText:
            return "Could not parse generated text from Gemini response."
        }
    }
}

class GeminiService {
    private let apiKey = Secrets.geminiApiKey
    private let apiUrl = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent")!

    func generateAffirmation(for specialDay: SpecialDay) async throws -> String {
        let prompt = """
        Bugünün özel adı: \(specialDay.name).
        Bu güne özel, pozitif ve ilham verici, 2-3 kısa cümleden oluşan bir olumlama, niyet veya dua cümlesi oluştur.
        Cevabın sadece bu cümleyi içersin, başka hiçbir ek metin olmasın.
        Tonu, günün temasına uygun olsun. Tema: \(specialDay.theme.rawValue).
        Cevabı Türkçe ver.
        """
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
        
        let requestBody = GeminiRequest(
            contents: [
                .init(parts: [.init(text: prompt)])
            ]
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            throw GeminiError.failedToEncode
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorBody = String(data: data, encoding: .utf8) ?? "No response body"
            throw GeminiError.invalidResponse(errorBody)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
            if let text = decodedResponse.generatedText {
                return text
            } else {
                throw GeminiError.noGeneratedText
            }
        } catch {
            throw GeminiError.failedToDecode
        }
    }
} 