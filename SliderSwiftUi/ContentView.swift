//
//  ContentView.swift
//  SliderSwiftUi
//
//  Created by Евгений Карась on 4.12.22.
//

import SwiftUI
import AVFoundation

class PlayerViewModel: ObservableObject{
    @Published public var maxDuration: Float = 0.0
    private var player: AVAudioPlayer?
    
    public func play(){
        playSound(name: "test")
        player?.play()
        
    }
    public func stop(){
        player?.stop()
    }
    public func setTime(value: Float){
        guard let time = TimeInterval(exactly: value) else {return}
        player?.currentTime = time
        player?.play()
    }
    private func playSound(name: String){
        guard let audioPath = Bundle.main.path(forResource: name, ofType: "mp3") else {return}
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            
            maxDuration = Float(player?.duration ?? 0.0)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct ContentView: View {
    @State private var progress = 0.0
    @ObservedObject var viewModel = PlayerViewModel()
    
    @State private var isEditing = false
    
    
    var body: some View {
        VStack{
            
//            Slider(value: $progress,in: 0...100) { editing in
//                isEditing = editing
//                self.viewModel.setTime(value: editing)
//            }.padding()
            
            Slider(value: Binding(get: {
                Float(self.progress)
            }, set: { newValue in
                self.progress = Double(newValue)
                self.viewModel.setTime(value: Float(newValue))
            }), in: 0...viewModel.maxDuration).padding()
           
            
            HStack{
                Button {
                    self.viewModel.play()
                    print("Start")

                } label: {
                    Text("Play")
                }
                .frame(width: 100,height: 50)
                .background(Color.orange)
                .cornerRadius(10)
                
                Button {
                    self.viewModel.stop()
                    print("Stop")
                    
                } label: {
                    Text("Stop")
                }
                .frame(width: 100,height: 50)
                .background(Color.orange)
                .cornerRadius(10)
                
            }

//            Text("\(speed)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
