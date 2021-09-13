//
//  ContentView.swift
//  Addicting Calculator
//
//  Created by Aidan Gordon on 6/6/20.
//  Copyright © 2020 Aidan Gordon. All rights reserved.
//

import SwiftUI


// Calculator Button Class
struct CalculatorButton: Hashable {
    private var title : String
    private var isLocked : Bool
    
    init(_ title: String, _ isLocked: Bool) {
        self.title = title
        self.isLocked = isLocked
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getLocked() -> Bool {
        return isLocked
    }
    
    mutating func setLocked(_ newLocked: Bool) {
        self.isLocked = newLocked
    }
    
    mutating func setTitle(_ newTitle: String) {
        self.title = newTitle
    }
}

// Environment Object
class GlobalEnvironment: ObservableObject {
    
    @Published var display = ""
    
    var buttons: [[CalculatorButton]] = [
    [CalculatorButton("AC", false), CalculatorButton("±", true), CalculatorButton("%", true), CalculatorButton("÷", true)],
        [CalculatorButton("7", true), CalculatorButton("8", true), CalculatorButton("9", true), CalculatorButton("X", true)],
        [CalculatorButton("4", true), CalculatorButton("5", true), CalculatorButton("6", true), CalculatorButton("-", true)],
        [CalculatorButton("1", false), CalculatorButton("2", true), CalculatorButton("3", true), CalculatorButton("+", true)],
        [CalculatorButton("0", true), CalculatorButton(".", true), CalculatorButton("=", true)]
    ]
    
    var firstNumber: Int! = nil
    var secondNumber: Int! = nil
    var result:Int! = nil
    
    func buttonPress(calculatorButton: CalculatorButton) {
        switch calculatorButton.getTitle() {
            case "+":
                if firstNumber == nil {
                    buttons[3][0].setLocked(false)
                }
                firstNumber = Int(self.display)
                secondNumber = nil
                self.display = ""
                buttons[3][3].setLocked(true)
            case "=":
                if secondNumber == nil {
                    secondNumber = Int(self.display)
                } else {
                    firstNumber = result
                }
                result = firstNumber + secondNumber
                self.display = String(result)
            case "1":
                if firstNumber == nil {
                    buttons[3][3].setLocked(false)
                } else {
                    buttons[4][2].setLocked(false)
                }
                self.display += "1"
                buttons[3][0].setLocked(true)
            case "2":
                self.display += "2"
                buttons[3][1].setLocked(true)
                buttons[3][3].setLocked(true)
            case "3":
                self.display += "3"
                buttons[3][2].setLocked(true)
                buttons[3][3].setLocked(true)
            case "4":
                self.display += "4"
                buttons[2][0].setLocked(true)
                buttons[3][3].setLocked(true)
            case "5":
                self.display += "5"
                buttons[2][1].setLocked(true)
                buttons[3][3].setLocked(true)
            case "6":
                self.display += "6"
                buttons[2][2].setLocked(true)
                buttons[3][3].setLocked(true)
            case "7":
                self.display += "7"
                buttons[1][0].setLocked(true)
                buttons[3][3].setLocked(true)
            case "8":
                self.display += "8"
                buttons[1][1].setLocked(true)
                buttons[3][3].setLocked(true)
            case "9":
                self.display += "9"
                buttons[1][2].setLocked(true)
                buttons[3][3].setLocked(true)
            default:
                self.display = ""
                firstNumber = nil
                secondNumber = nil
                result = nil
        }
    }
    
    func levelUp(_ newLevel: Int) {
        
        buttons[3][3].setLocked(false)
        
        switch newLevel {
            case 2:
                buttons[3][0].setLocked(true)
                buttons[3][1].setLocked(false)
            case 3:
                buttons[3][1].setLocked(true)
                buttons[3][2].setLocked(false)
            case 4:
                buttons[3][2].setLocked(true)
                buttons[2][0].setLocked(false)
            case 5:
                buttons[2][0].setLocked(true)
                buttons[2][1].setLocked(false)
                buttons[0][0].setLocked(true)
            case 6:
                buttons[2][1].setLocked(true)
                buttons[2][2].setLocked(false)
            case 7:
                buttons[2][2].setLocked(true)
                buttons[1][0].setLocked(false)
            case 8:
                buttons[1][0].setLocked(true)
                buttons[1][1].setLocked(false)
            default:
                buttons[1][1].setLocked(true)
                buttons[1][2].setLocked(false)
        }
    }
}

struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnvironment
    @State private var level:Int = 1

    var body: some View {
        
        ZStack (alignment: .bottom){
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack (spacing: 12) {
                Text("Level " + self.getLevel())
                .foregroundColor(.red)
                .font(.system(size: 32))
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text(env.display).foregroundColor(.red)
                        .font(.system(size: 64))
                }.padding()
                
                ForEach(env.buttons, id: \.self) { row in
                    HStack (spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            CalculatorButtonView(button: button)
                        }
                    }
                }
            }.padding(.bottom)
        }
    }
    
    func getLevel() -> String {
        let thresholds: [Int] = [-1, 50, 250, 700, 1500, 2500, 3700, 5100, 9100]
        
        if env.result ?? 0 >=  thresholds[8] {
            if env.result == thresholds[8] && env.secondNumber != nil {
                env.levelUp(9)
            }
            return "9"
        } else if env.result ?? 0 >=  thresholds[7] {
            if env.result == thresholds[7] && env.secondNumber != nil {
                env.levelUp(8)
            }
            return "8"
        } else if env.result ?? 0 >=  thresholds[6] {
            if env.result == thresholds[6] && env.secondNumber != nil {
                env.levelUp(7)
            }
            return "7"
        } else if env.result ?? 0 >=  thresholds[5] {
            if env.result == thresholds[5] && env.secondNumber != nil {
                env.levelUp(6)
            }
            return "6"
        } else if env.result ?? 0 >=  thresholds[4] {
            if env.result == thresholds[4] && env.secondNumber != nil {
                env.levelUp(5)
            }
            return "5"
        } else if env.result ?? 0 >=  thresholds[3] {
            if env.result == thresholds[3] && env.secondNumber != nil {
                env.levelUp(4)
            }
            return "4"
        } else if env.result ?? 0 >=  thresholds[2] {
            if env.result == thresholds[2] && env.secondNumber != nil {
                env.levelUp(3)
            }
            return "3"
        } else if env.result ?? 0 >=  thresholds[1] {
            if env.result == thresholds[1] && env.secondNumber != nil {
                env.levelUp(2)
            }
            return "2"
        } else if env.result ?? 0 >=  thresholds[0] {
            return "1"
        } else {
            return "0"
        }
    }
}

struct CalculatorButtonView: View {
    
    var button: CalculatorButton
    
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        HStack {
            Button(action: {
                if !self.button.getLocked() {
                    self.env.buttonPress(calculatorButton: self.button)
                }
            }) {
                Text(button.getTitle())
                .font(.system(size:32))
                    .frame(width: self.buttonWidth(button: button), height: (UIScreen.main.bounds.width - 5 * 12) / 4)
                    .foregroundColor(.red)
                    .background(Color.white)
                    .cornerRadius(self.buttonWidth(button: button))
                    .overlay(self.getImage(button: button)
                        .renderingMode(.original)
                        .font(.largeTitle))

            }
        }
    }
    
    private func buttonWidth(button: CalculatorButton) -> CGFloat {
        if button.getTitle() == "0" {
            return 2 * (UIScreen.main.bounds.width - 4 * 12) / 4
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
    private func getImage(button: CalculatorButton) -> Image {
        if button.getLocked() {
            return Image(systemName: "lock.fill")
        } else {
            return Image("blank")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
    }
}


