import SwiftUI

struct SocialFeedView: View {
    @StateObject private var viewModel = SocialViewModel()
    @State private var showingAuthSheet = false
    @State private var showingShareSheet = false
    @State private var newWishText = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    
    var body: some View {
        ZStack {
            // Background
            CosmicBackground(stars: .constant([]))
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("✨ Wish Community ✨")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // User profile button
                    if let user = viewModel.currentUser {
                        UserAvatarView(username: user.username)
                            .onTapGesture {
                                viewModel.signOut()
                            }
                    } else {
                        Button(action: { showingAuthSheet = true }) {
                            Text("Sign In")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(hex: "FFB6C1"))
                                .cornerRadius(15)
                        }
                    }
                }
                .padding()
                
                // Share wish button (only for logged in users)
                if viewModel.currentUser != nil {
                    Button(action: { showingShareSheet = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Share a Wish")
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "FFB6C1"),
                                    Color(hex: "DDA0DD")
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                    }
                    .padding(.bottom)
                }
                
                // Wishes feed
                if viewModel.isLoading && viewModel.publicWishes.isEmpty {
                    SwiftUI.ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.publicWishes.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("No wishes shared yet")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        if viewModel.currentUser != nil {
                            Text("Be the first to share!")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.6))
                        } else {
                            Text("Sign in to share your wishes")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.publicWishes) { wish in
                                SocialWishCard(
                                    wish: wish,
                                    onSendEnergy: { fromPosition in
                                        // Calculate the center of the card
                                        let toPosition = CGPoint(
                                            x: UIScreen.main.bounds.width / 2,
                                            y: UIScreen.main.bounds.height / 3
                                        )
                                        
                                        viewModel.sendEnergy(
                                            to: wish,
                                            fromPosition: fromPosition,
                                            toPosition: toPosition
                                        )
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            
            // Energy animations layer
            ForEach(Array(viewModel.activeEnergyAnimations.keys), id: \.self) { id in
                if let animation = viewModel.activeEnergyAnimations[id] {
                    EnergyFlowView(
                        fromPosition: animation.from,
                        toPosition: animation.to,
                        onCompleted: {}
                    )
                }
            }
        }
        .onAppear {
            viewModel.fetchPublicWishes()
        }
        .sheet(isPresented: $showingAuthSheet) {
            AuthView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareWishView(viewModel: viewModel)
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .alert(item: Binding<AlertItem?>(
            get: { viewModel.errorMessage.map { AlertItem(message: $0) } },
            set: { _ in viewModel.errorMessage = nil }
        )) { alertItem in
            Alert(
                title: Text("Error"),
                message: Text(alertItem.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// Helper for alert binding
struct AlertItem: Identifiable {
    let id = UUID()
    let message: String
}

// User avatar view
struct UserAvatarView: View {
    let username: String
    
    var body: some View {
        Text(String(username.prefix(1)).uppercased())
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 36, height: 36)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "FFB6C1"),
                        Color(hex: "DDA0DD")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}

// Wish card in social feed
struct SocialWishCard: View {
    let wish: SocialWish
    let onSendEnergy: (CGPoint) -> Void
    
    @State private var cardOffset = CGSize.zero
    @State private var energyButtonPosition: CGPoint = .zero
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User info
            HStack {
                UserAvatarView(username: wish.username)
                
                VStack(alignment: .leading) {
                    Text(wish.username)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(timeAgo(from: wish.createdAt))
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
            }
            
            // Wish content
            Text(wish.text)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            // Wish image if present
            if let imageURL = wish.imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        SwiftUI.ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(height: 180)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .clipped()
                            .cornerRadius(12)
                    case .failure:
                        Image(systemName: "photo.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.3))
                            .frame(height: 180)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            // Energy count and send button
            HStack {
                Text("\(wish.energyCount) energy")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Button(action: {
                    onSendEnergy(energyButtonPosition)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                        Text("Send Energy")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(hex: "FFB6C1").opacity(0.8))
                    .cornerRadius(15)
                }
                .background(
                    GeometryReader { geo -> Color in
                        DispatchQueue.main.async {
                            // Get the button position
                            energyButtonPosition = CGPoint(
                                x: geo.frame(in: .global).midX,
                                y: geo.frame(in: .global).midY
                            )
                        }
                        return Color.clear
                    }
                )
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    // Format relative time
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// Authentication view
struct AuthView: View {
    @ObservedObject var viewModel: SocialViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                Text(isSignUp ? "Create Account" : "Welcome Back")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                VStack(spacing: 16) {
                    if isSignUp {
                        TextField("Username", text: $username)
                            .textFieldStyle(RoundedTextFieldStyle())
                    }
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedTextFieldStyle())
                }
                
                Button(action: {
                    if isSignUp {
                        viewModel.signUp(username: username, email: email, password: password)
                    } else {
                        viewModel.signIn(email: email, password: password)
                    }
                }) {
                    Text(isSignUp ? "Sign Up" : "Sign In")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "FFB6C1"),
                                    Color(hex: "DDA0DD")
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                }
                .disabled(viewModel.isLoading)
                .overlay(
                    Group {
                        if viewModel.isLoading {
                            SwiftUI.ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                )
                
                Button(action: {
                    withAnimation {
                        isSignUp.toggle()
                    }
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(32)
        }
        .onReceive(viewModel.$currentUser) { user in
            if user != nil {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// Custom text field style
struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

// Share wish view
struct ShareWishView: View {
    @ObservedObject var viewModel: SocialViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var wishText = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var isPublic = true
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Share Your Wish")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                ZStack(alignment: .topTrailing) {
                    TextField("Type your wish...", text: $wishText, axis: .vertical)
                        .lineLimit(5)
                        .padding()
                        .frame(minHeight: 120, alignment: .top)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(hex: "FFDAB9").opacity(0.5), lineWidth: 1)
                        )
                    
                    // Image picker button
                    Button(action: { isImagePickerPresented = true }) {
                        Image(systemName: selectedImage == nil ? "photo.circle.fill" : "photo.circle.fill.badge.checkmark")
                            .font(.system(size: 24))
                            .foregroundColor(selectedImage == nil ? .white.opacity(0.6) : Color(hex: "FFB6C1"))
                            .padding(12)
                    }
                }
                
                // Image preview if selected
                if let image = selectedImage {
                    HStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        
                        Button(action: { selectedImage = nil }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.6))
                                .font(.system(size: 20))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                // Public toggle
                Toggle(isOn: $isPublic) {
                    Text("Share publicly")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                }
                .padding(.horizontal)
                .tint(Color(hex: "FFB6C1"))
                
                Spacer()
                
                HStack(spacing: 16) {
                    // Cancel button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(15)
                    }
                    
                    // Share button
                    Button(action: {
                        viewModel.shareWish(text: wishText, image: selectedImage, isPublic: isPublic)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Share")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "FFB6C1"))
                            .cornerRadius(15)
                    }
                    .disabled(wishText.isEmpty || viewModel.isLoading)
                }
            }
            .padding(24)
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}
