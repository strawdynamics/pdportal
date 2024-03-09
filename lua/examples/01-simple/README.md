# pdportal-01-simple

This example responds to every event by telling pdportal to log a message to the browser console. This is just a demonstration of subclassing `PdPortal` and overriding the default empty implementations.

To test the peer connection parts of this demo, open a second instance of the pdportal site on your computer. Follow the instructions in your browser console to enable the development tools, then visit `/just-dev-things`. From here, you can manually initialize a peer, connect to your existing peer peer, and exchange messages.

## Installation

`./build.sh d` will compile and automatically install the app to your connected Playdate. I'm sorry, the script currently only works on macOS, and even then can be a bit janky. Pull requests welcome :)
