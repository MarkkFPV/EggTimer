//
//  ContentView.swift
//  Egg Timer
//
//  Created by Mark on 22.3.2025.
//

import SwiftUI
import Combine
import AVFoundation
import AudioToolbox


class TimerManager: ObservableObject {
    var timer: Timer?
    @Published var title: String = "how would you like your egg?"
    @Published var secondsPassed = 0
    @Published var totalTime = 1
    
    
    func startTimer(seconds: Int, title: String) {
        timer?.invalidate()
        totalTime = seconds
        

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.secondsPassed < self.totalTime {
                self.secondsPassed += 1
            } else {

                self.timer?.invalidate()
                playSound(tone: "A")
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                self.title = title
             }
        }
    }
}
var player: AVAudioPlayer?
struct ContentView: View {
    @StateObject private var timerManager = TimerManager()

    let softTime = 300
    let mediumTime = 420
    let hardTime = 720
    
    

    var body: some View {
        ZStack {
            Image("2")
                .resizable()
                .ignoresSafeArea(edges: .all)
            VStack {
                Spacer()
                Text("Egg Timer")
                    .font(.system(size: 30, weight: .bold))
                Text(timerManager.title)
                Spacer()
                
               
                HStack {
                    Button {
                        timerManager.title = "Hard Egg Timer"
                        timerManager.secondsPassed = 0
                        timerManager.startTimer(seconds: hardTime, title: "Your Hard Egg Is Ready!")
                    } label: {
                        VStack {
                            Image("hard_egg")
                                .resizable()
                                .frame(width: 120, height: 160)
                            Text("Hard")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    Button {
                        timerManager.title = "Medium Egg Timer"
                        timerManager.secondsPassed = 0
                        timerManager.startTimer(seconds: mediumTime, title: "Your Medium Egg Is Ready!")
                                            } label: {
                        VStack {
                            Image("medium_egg")
                                .resizable()
                                .frame(width: 120, height: 160)
                            Text("Medium")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    Button {
                        timerManager.title = "Soft Egg Timer"
                        timerManager.secondsPassed = 0
                        timerManager.startTimer(seconds: softTime, title: "Your Soft Egg Is Ready!")
                    } label: {
                        VStack {
                            Image("soft_egg")
                                .resizable()
                                .frame(width: 120, height: 160)
                            Text("Soft")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    
                }
                let floatTotalTime = Float(timerManager.totalTime)
                let floatSecondsPassed: Float = Float(timerManager.secondsPassed)
                let barProgress: Float = floatSecondsPassed / floatTotalTime
                ProgressView(value: barProgress)
                
                if timerManager.totalTime > 1 {
                    Text("\(timerManager.secondsPassed)/\(timerManager.totalTime)")
                        .font(.system(size: 18, weight: .bold))
                    
                } else {
                    
                }
                
                    
                Spacer()
            }
            
        }
        
    }
}
func playSound(tone: String) {
    guard let url = Bundle.main.url(forResource: tone, withExtension: "mp3") else { return }

    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)

        /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

        /* iOS 10 and earlier require the following line:
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

        guard let player = player else { return }

        player.play()

    } catch let error {
        print(error.localizedDescription)
    }
}
#Preview {
    ContentView()

}
