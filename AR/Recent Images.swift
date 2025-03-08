import SwiftUI

struct RecentImages: View {
    
    @Binding var uiImagesTaken: [UIImage]
    @State var showingAllImages = false
    
    var body: some View {
        ZStack {
            ForEach(uiImagesTaken, id: \.self) { uiImage in
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .border(.white, width: 10)
                    .rotationEffect(.degrees(.random(in: -15...15)))
            }
            .shadow(color: .secondary.opacity(0.3), radius: 10)
            .onTapGesture {
                showingAllImages.toggle()
            }
        }
        .sheet(isPresented: $showingAllImages) {
            NavigationStack {
                ScrollView {
                    Text("Tap a photo to share it.")
                        .foregroundColor(.secondary)
                        .font(.bodoni(.bold, size: 18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(uiImagesTaken, id: \.self) { uiImage in
                            ShareLink(item: Image(uiImage: uiImage), preview: SharePreview("Photo Taken", image: Image(uiImage: uiImage))) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                    .border(.white, width: 10)
                                    .shadow(color: .secondary.opacity(0.3), radius: 10)
                            }
                        }
                    }   
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) { 
                        Button("Done") {
                            showingAllImages = false
                        }
                        .font(.bodoni(.extraBold, size: 18))
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Clear") {
                            withAnimation(.spring()) { 
                                uiImagesTaken = []
                            }
                        }
                        .foregroundColor(.red)
                        .font(.bodoni(.extraBold, size: 18))
                    }
                }
                .navigationTitle("Photos Taken")
            }
        }
    }
}
