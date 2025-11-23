# Olalarm

A lightweight, beautifully alarm app, written in SwiftUI.

## Features

### Create Alarm

You can define you own alarm with name, trigger time, snooze duration and a sound.
You can pick default system sound or one from curated list of custom sounds.

### Accurate Alarm

Powered by **AlarmKit**, the app ensures that alarms fire reliably at the chosen time.

### Native look and feel

App supports alarm display in Lock screen, standby mode and dynamic island.

## Development

### Bumping version

To bump version, open `app_version` and increase semantic version and build number.

### .env file

Create `.env` file in root, copy content from `.env.example` and fill it with valid values.

### Building

Run fastlane via bundler:

```sh
bundle exec fastlane ios build_release
```

the `olalarm-VERSION.ipa` is in the root, ready to be deployed.

## Contributing

Contributions, bug reports, and feature ideas are welcome.
Open an Issue or submit a PR to get involved.

## License

```
Copyright 2025 Krzysztof Borowy

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
