import AVFoundation
import SharedData
import SwiftUI

struct SoundPicker: View {
    @Binding var sound: OlalarmSound?

    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying: Bool = false
    @State private var audioPlayerDelegate = AudioDelegate()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Picker(selection: $sound) {
                Text("System default").tag(nil as OlalarmSound?)
                ForEach(OlalarmSounds, id: \.self) { sound in
                    VStack {
                        Text(sound.title).foregroundStyle(.colorTextPrimary)

                    }.tag(sound)
                }

            } label: {}
                .pickerStyle(.menu)
                // remove apple's internal padding
                .padding(.leading, -8)
                .padding(.top, -4)
                .tint(.colorPrimary)
            if let selectedSound = sound {
                HStack {
                    Button(action: {
                        togglePlay(sound: selectedSound)
                    }) {
                        Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                            .foregroundStyle(.colorPrimary)
                        Text(isPlaying ? "Stop" : "Play")
                            .foregroundStyle(.colorPrimary)
                    }
                    .buttonStyle(.bordered)

                    Spacer()
                    if let credit = sound?.credits {
                        Text(credit)
                            .font(.caption2)
                            .foregroundStyle(
                                .colorTextPrimary.opacity(0.75)
                            )
                    }
                }
            }

        }.onChange(of: sound) { prev, curr in
            if prev?.id != curr?.id {
                audioPlayer?.stop()
                isPlaying = false
            }
        }
    }

    // MARK: - Audio Control

    private func togglePlay(sound: OlalarmSound) {
        if isPlaying {
            audioPlayer?.stop()
            isPlaying = false
        } else {
            guard let url = Bundle.main.url(forResource: sound.fileName, withExtension: nil) else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true)

                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayerDelegate.onFinish { _ in
                    isPlaying = false
                }
                audioPlayer?.delegate = audioPlayerDelegate
                audioPlayer?.play()
                isPlaying = true

            } catch {
                print("Failed to play sound:", error)
            }
        }
    }
}

// Simple AVAudioPlayerDelegate wrapper
private class AudioDelegate: NSObject, AVAudioPlayerDelegate {
    var onFinish: ((Bool) -> Void)? = nil

    func onFinish(block: @escaping (Bool) -> Void) {
        onFinish = block
    }

    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully flag: Bool) {
        if let onFinish = onFinish {
            onFinish(flag)
        }
    }
}

#Preview {
    @Previewable @State var s: OlalarmSound? = OlalarmSounds.first
    SoundPicker(sound: $s)
}
