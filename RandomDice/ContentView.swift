import SwiftUI

struct ContentView: View {
    @State private var diceValue = 1
    @State private var isRolling = false
    @State private var isButtonEnabled = true
    
    private let diceRollDuration = 1.0 // Duration of the rolling animation
    private let delayAfterRolling = 0.1 // Shortened waiting time
    
    private let numberOfDiceFaces = 6
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.green)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("Dice Value: \(diceValue)")
                        .font(.largeTitle)
                        .padding(.bottom, 50)
                    
                    Image("dice-six-faces-\(numberToText(diceValue) ?? "")")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(isRolling ? 360 : 0))
                        .onAppear {
                            isRolling = false // Ensure that isRolling is initially set to false
                            withAnimation(
                                Animation.linear(duration: diceRollDuration)
                                    .repeatCount(1, autoreverses: false)
                            ) {
                                isRolling = true
                            }
                        }
                    
                    Spacer()
                    
                    Button(action: {
                        rollDice()
                    }) {
                        Text("Roll Dice")
                            .font(.title)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                    }
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                    .frame(width: 220, height: 80)
                    .disabled(!isButtonEnabled)
                    
                    Spacer()
                }
                .frame(height: geometry.size.height) // Set the height to the full screen height
            }
        }
    }

    func rollDice() {
        // Disable the button during animation
        isButtonEnabled = false
        
        // Generate a random dice value
        let randomDiceValue = Int.random(in: 1...numberOfDiceFaces)
        
        // Simulate a rolling animation
        withAnimation {
            isRolling = true
        }
        
        // Shortened waiting time after starting the rolling animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Update the dice value after a short delay
            self.diceValue = randomDiceValue
            
            // Reset isRolling to false immediately after setting the diceValue
            self.isRolling = false
        }
        
        // Enable the button after a shorter delay
        DispatchQueue.main.asyncAfter(deadline: .now() + diceRollDuration - delayAfterRolling) {
            self.isButtonEnabled = true
        }
    }
    
    func numberToText(_ number: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        return numberFormatter.string(from: NSNumber(value: number))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("iPhone 14")
    }
}

