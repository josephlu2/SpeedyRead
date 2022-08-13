//
//  ContentView.swift
//  SpeedyRead
//
//  Created by Joseph Lu on 5/23/22.
//

import SwiftUI

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.primary.edgesIgnoringSafeArea(.all)
            Button("Dismiss Modal") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}


struct ContentView: View {
    init() {
        UITabBar.appearance().barTintColor = .systemBackground
        UINavigationBar.appearance().barTintColor = .systemBackground
        UITextView.appearance().backgroundColor = .clear
    }
    
    @State private var isPresented = false
    @State var selectedIndex = 0
    @State var shouldShowModal = false
    @State var text = ""
    @State private var showText = false
    @State var buttonText = "Convert"
    @State var currSize = 14.0
    @State var bgColor: Color = Color(red: 0.9, green: 0.9, blue: 0.9)
    @State var textColor: Color = .black
    @FocusState var amountIsFocused: Bool
    let tabBarImageNames = ["house", "gearshape"]
    
    var convert: String {
        let inputArray = text.components(separatedBy: " ")
        var retArray = [String]()
        if text == "" {
            return text
        }
        for word in inputArray {
            if word.count == 1 {
                if word == "*" {
                    retArray.append("*")
                    continue
                } else {
                    retArray.append("**" + word + "**")
                    continue
                }
            }
            
            
            if word.count == 0 {
                continue
            }
            
            if word.count == 2 {
                retArray.append("**" + word.prefix(1) + "**" + word.suffix(1))
                continue
            }
            
            if (word.count % 2 == 0) {
                var temp = word
                let tempLength = temp.count
                temp = "**" + word.prefix(tempLength / 2 + 1) + "**" + word.suffix(tempLength / 2 - 1)
                retArray.append(temp)
            } else {
            
            var temp = word
            let tempLength = temp.count
            temp = "**" + word.prefix(tempLength / 2 + 1) + "**" + word.suffix(tempLength / 2)
            retArray.append(temp)
        }
        }
        let ret = retArray.joined(separator: " ")
        return ret
    }
    
    var body: some View {
        VStack(spacing: 0){
            ZStack {
                
                Spacer().fullScreenCover(isPresented: $shouldShowModal, content: {
                    Button(action: {shouldShowModal.toggle()}, label: {
                        Text("Full screen cover")
                    })
                    
                })
                
                switch selectedIndex {
                case 0:
                    NavigationView {
                        ZStack {
                            Image("mtn")
                                .resizable()
                                .ignoresSafeArea()
                            VStack(){
                                if !amountIsFocused {
                                    Text("SpeedyRead")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .padding(.top)
                                    Text("Type or paste text in below and then click convert!")
                                        .multilineTextAlignment(.center)
                                        .padding(.top, -5.0)
                                }
                                    ZStack(alignment: .leading){
                                        if !showText {
                                        TextEditor(text: $text)
                                            .foregroundColor(textColor)
                                            .frame(height: 350)
                                            .background(bgColor)
                                            .keyboardType(.default)
                                            .focused($amountIsFocused)
                                            .font(.system(size: currSize))
                                            .cornerRadius(10)
                                            
                                        }
                                        if showText {
                                            ScrollView {
                                            Text(.init(convert))
                                                .padding()
                                                .fixedSize(horizontal: false, vertical: true)
                                                .background(bgColor)
                                                .cornerRadius(10)
                                                .textSelection(.enabled)
                                                .font(.system(size: currSize))
                                                .foregroundColor(textColor)
                                            }
                                            
                                        }
                                            
                                    }
                                VStack {
                                    
                                    HStack {
                                            Spacer()
                                            Button(buttonText) {
                                                if showText == false {
                                                    showText = true
                                                    buttonText = "Edit"
                                                } else {
                                                showText = false
                                                    buttonText = "Convert"
                                                }
                                            }
                                            .buttonStyle(.borderedProminent)
                                            Spacer()
                                                
                                        }
                                    .padding(.top)
                                    
                                }
                                    Spacer()
                                }
                                 .padding()
                                 .navigationBarHidden(true)
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                
                                Button("Done") {
                                    amountIsFocused = false
                                }
                            }
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                        .onAppear(perform: {
                                        ReviewHandler.requestReview()
                                    })
                    }
                    
                case 1:
                    NavigationView {
                        VStack {
                            Form {
                                Section {
                                Stepper("Font Size: \(Int(currSize))", value: $currSize, in: 4...36)
                                ColorPicker("Background Color", selection: $bgColor, supportsOpacity: false)
                                ColorPicker("Text Color", selection: $textColor, supportsOpacity: false)
                                }
                                
                                Section {
                                Text("SpeedyRead allows you to read faster than you previously thought possible. For more information or questions, contact us at contact@alpenglow.studio")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .textSelection(.enabled)
                                    .font(.system(size: 14))
                                }
                            }
                            .navigationTitle("App Settings")
                            Text("This app is not affiliated with \"Bionic Reading\" , \"Bionic Reading GmbH\" or \"Renato Casutt\" ")
                                .font(.system(size: 12))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.gray)
                        }
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    
                default:
                    Text("Second")
                }
            }
                
            //Spacer()
            
            Divider()
                .padding(.bottom, 8)
            
            HStack {
                ForEach(0..<2) { num in
                    Button(action: {
                        
                         selectedIndex = num
                    }, label: {
                        Spacer()
                            Image(systemName: tabBarImageNames[num])
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(selectedIndex == num ? Color(.black) : .init(white: 0.8))
                        
                        Spacer()
                    }
                    )
                }
            }
                
        }.ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
    }
}
