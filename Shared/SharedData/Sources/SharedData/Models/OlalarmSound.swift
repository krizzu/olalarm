
public struct OlalarmSound: Sendable, Hashable, Identifiable {
    public let id: String
    public let fileName: String
    public let title: String
    public let credits: String
}

// all sounds coming from Pixabay
// modified locally, need to be kept under 30 sec for alarm to work.
public let OlalarmSounds = [
    OlalarmSound(
        id: "wake-up-to-the-renaissance",
        fileName: "wake-up-to-the-renaissance.mp3",
        title: "Wake up to the Renaissance",
        credits: "Music by Denys Kyshchuk from Pixabay"
    ),
    OlalarmSound(
        id: "gentle-acoustic-guitar",
        fileName: "gentle-acoustic-guitar.mp3",
        title: "Gentle Acoustic Guitar",
        credits: "Music by Universfield from Pixabay"
    ),
    OlalarmSound(
        id: "deep-in-time-master-track",
        fileName: "deep-in-time-master-track.mp3",
        title: "Deep in time master track",
        credits: "Music by Vasileios Ziogas from Pixabay"
    ),
    OlalarmSound(
        id: "tick-tock",
        fileName: "tick-tock.mp3",
        title: "Tick-Tock",
        credits: "Music by Lesiakower from Pixabay"
    ),
    OlalarmSound(
        id: "whimsical-wonderland",
        fileName: "whimsical-wonderland.mp3",
        title: "Whimsical Wonderland",
        credits: "Music by Vlad Krotov from Pixabay"
    ),
]
