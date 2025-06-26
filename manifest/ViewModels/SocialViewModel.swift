import SwiftUI
import Combine

class SocialViewModel: ObservableObject {
    // Published properties
    @Published var currentUser: User?
    @Published var publicWishes: [SocialWish] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Energy animation state
    @Published var activeEnergyAnimations: [String: (from: CGPoint, to: CGPoint)] = [:]
    
    // Mock data
    private var mockUsers: [User] = []
    private var mockWishes: [SocialWish] = []
    
    // Subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupMockData()
        fetchPublicWishes()
    }
    
    // MARK: - Mock Data Setup
    
    private func setupMockData() {
        // Create mock users
        let user1 = User(username: "Sarah", createdWishes: 5, energySent: 12)
        let user2 = User(username: "Michael", createdWishes: 3, energySent: 8)
        let user3 = User(username: "Emma", createdWishes: 7, energySent: 15)
        
        mockUsers = [user1, user2, user3]
        
        // Create mock wishes
        mockWishes = [
            SocialWish(
                userId: user1.id,
                username: user1.username,
                text: "I wish for peace and harmony in the world",
                energyCount: 24
            ),
            SocialWish(
                userId: user2.id,
                username: user2.username,
                text: "I manifest abundance and prosperity in my life",
                energyCount: 18
            ),
            SocialWish(
                userId: user3.id,
                username: user3.username,
                text: "I wish for health and happiness for my family",
                energyCount: 32
            ),
            SocialWish(
                userId: user1.id,
                username: user1.username,
                text: "I am attracting my dream job",
                energyCount: 15
            ),
            SocialWish(
                userId: user3.id,
                username: user3.username,
                text: "I wish to travel the world and experience new cultures",
                energyCount: 27
            )
        ]
    }
    
    // MARK: - Authentication
    
    func signIn(email: String, password: String) {
        isLoading = true
        
        // Mock sign in - just pick a random user
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            self?.currentUser = self?.mockUsers.randomElement()
        }
    }
    
    func signUp(username: String, email: String, password: String) {
        isLoading = true
        
        // Create a new mock user
        let newUser = User(username: username)
        mockUsers.append(newUser)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            self?.currentUser = newUser
        }
    }
    
    func signOut() {
        currentUser = nil
    }
    
    // MARK: - Wish Management
    
    func fetchPublicWishes() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading = false
            self?.publicWishes = self?.mockWishes ?? []
        }
    }
    
    func shareWish(text: String, image: UIImage?, isPublic: Bool = true) {
        guard let currentUser = currentUser else {
            errorMessage = "You must be logged in to share wishes"
            return
        }
        
        isLoading = true
        
        // Create a new wish
        let wish = SocialWish(
            userId: currentUser.id,
            username: currentUser.username,
            userProfileImageURL: currentUser.profileImageURL,
            text: text,
            isPublic: isPublic
        )
        
        // Add to mock data
        mockWishes.insert(wish, at: 0)
        
        // Update user's wish count
        if let index = mockUsers.firstIndex(where: { $0.id == currentUser.id }) {
            mockUsers[index].createdWishes += 1
            self.currentUser = mockUsers[index]
        }
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading = false
            self?.publicWishes = self?.mockWishes ?? []
        }
    }
    
    // MARK: - Energy Transfers
    
    func sendEnergy(to wish: SocialWish, fromPosition: CGPoint, toPosition: CGPoint) {
        guard let currentUser = currentUser else {
            errorMessage = "You must be logged in to send energy"
            return
        }
        
        // Start animation
        let animationId = UUID().uuidString
        activeEnergyAnimations[animationId] = (from: fromPosition, to: toPosition)
        
        // Update wish energy count
        if let index = mockWishes.firstIndex(where: { $0.id == wish.id }) {
            mockWishes[index].energyCount += 1
            publicWishes = mockWishes
        }
        
        // Update user's energy sent count
        if let userIndex = mockUsers.firstIndex(where: { $0.id == currentUser.id }) {
            mockUsers[userIndex].energySent += 1
            self.currentUser = mockUsers[userIndex]
        }
        
        // Remove animation after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.activeEnergyAnimations.removeValue(forKey: animationId)
        }
    }
} 