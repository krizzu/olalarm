import { createFileRoute } from '@tanstack/react-router'
import AppShot from './assets/app-shot.png'

export const Route = createFileRoute('/')({ component: App })

const appStoreLink = 'https://apps.apple.com/app/olalarm/id6755116777'

function App() {
  return (
    <div className="min-h-screen bg-background text-foreground flex items-center justify-center p-8">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-12 max-w-6xl w-full">
        <div className="flex order-2 md:order-1 flex-col justify-center space-y-6">
          <h1 className="text-4xl md:text-5xl font-bold text-foreground">
            Olalarm
          </h1>
          <p className="text-lg md:text-xl text-foreground/80 max-w-md">
            A beautifully simple and reliable alarm app designed to help you
            wake up on time, every time. Clean design, smart features, and
            effortless control.
          </p>

          <a
            href={appStoreLink}
            className="inline-block w-fit bg-primary text-primary-foreground px-6 py-3 rounded-xl text-lg font-medium shadow hover:opacity-90 transition"
          >
            Download on the App Store
          </a>
        </div>

        <div className="flex order-1 md:order-2 items-center justify-center">
          <img
            src={AppShot}
            alt="OlaAlarm App Screenshot"
            className="w-full max-w-sm"
          />
        </div>
      </div>
    </div>
  )
}
