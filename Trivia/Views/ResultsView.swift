//
//  ResultsView.swift
//  Trivia
//
//  Created by Ethan Zemelman on 2020-09-12.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import SwiftUI

struct ResultsView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var showingAnswers = false
    
    let questions: [Question]
    let correctQuestions: Int
    let totalQuestions: Int
    
    private var percent: Double {
        Double(correctQuestions) / Double(totalQuestions) * 100
    }
    private var percentColor: Color {
        if percent <= 30 {
            return .red
        } else if percent < 70 {
            return .yellow
        } else {
            return .blue
        }
    }
    private var message: String {
        if percent <= 30 {
            return "Better luck next time 🙁"
        } else if percent < 70 {
            return "You did okay 😐"
        } else {
            return "You did amazing 🙂!"
        }
    }
    
    private let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack() {
            
            Text("Score:").font(.system(size: 30))
            
            Text("\(correctQuestions)/\(totalQuestions)")
                .font(.system(size: 80))
                .bold()
                .padding(.top, 30)
            
            Text("\(String(format: "%.1f", percent))%")
                .font(.system(size: 50))
                .padding()
                .background(percentColor)
                .clipShape(Capsule())
                .padding(.top)
            
            Text(message)
                .font(.system(size: 25))
                .padding(.top, 50)
            
            Button(action: {
                self.showingAnswers.toggle()
            }) {
                Text("View Answers")
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .font(.system(size: 25))
                    .clipShape(Capsule())
                    .padding(.top, 50)
            }.sheet(isPresented: $showingAnswers) {
                AnswersView(questions: self.questions)
            }
            
            Spacer()
            
            Button(action: {
                // Dismiss the view to go back
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Create Another Quiz")
                    .frame(width: self.screenWidth - 40)
                    .padding(.vertical)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            
        }.navigationBarTitle("Results")
    }
}

struct ResultsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack {
                Color.green.edgesIgnoringSafeArea(.all)
                
                ResultsView(questions: [Question](), correctQuestions: 8, totalQuestions: 10)
            }
        }
    }
}
