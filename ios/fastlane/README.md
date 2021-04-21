fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios tests
```
fastlane ios tests
```
Run tests
### ios beta
```
fastlane ios beta
```
Push a new beta build to TestFlight
### ios prod
```
fastlane ios prod
```

### ios test
```
fastlane ios test
```

### ios set_release_version
```
fastlane ios set_release_version
```
Sets the version of the bundle to a RELEASE_VERSION passed in as an environment variable

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
