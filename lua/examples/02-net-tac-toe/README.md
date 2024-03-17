# Net-tac-toe (pdportal-02-net-tac-toe)

[Available for download on itch.io](https://paulstraw.itch.io/net-tac-toe)

Currently the most complete pdportal example. This is an implementation of a (very simple) two player turn-based game.

## Testing against yourself

Just like with 01-simple, you can use a second instance of the pdportal site on your computer to test Net-tac-toe. Follow the instructions in your browser console to access the pdportal development tools. From there, you can manually initialize a peer (without a second Playdate), connect to your existing peer, and exchange messages.

Whichever browser you enter the peer ID into will act as the "client", while the other browser will be the "host". If you make the browser connected to the Playdate the "client", you'll need to manually send a `MatchEvent.Start` event from the other browser for the game to begin.

Example messages:

```js
// Sent from host to client to start game. `isHostX` determines who goes first.
{"e": "s", "isHostX": false}

// Sent by current player to visually move the cursor. Indices start at 1 top
// left, then continue across and down (i.e. bottom left is 7)
{"e": "m", "oldIndex": 1, "newIndex": 3}

// Sent by current player to place a mark on their current square (ends turn)
{"e": "p", "index": 3}
```

## Installation

`./build.sh d` will compile and automatically install the app to your connected Playdate. I'm sorry, the script currently only works on macOS, and even then can be a bit janky. Pull requests welcome :)
