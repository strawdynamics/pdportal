# pdportal

A magic portal for [Playdate](https://play.date) that enables online multiplayer using Web Serial and WebRTC. This is the web interface (available for use with any Playdate game at https://pdportal.net). If you want to make a multiplayer game that uses pdportal, check out the [lua](./lua) subfolder.

Note that [this technique _cannot_ be used with Catalog games](https://github.com/cranksters/playdate-reverse-engineering/blob/main/usb/usb.md#eval) currently/probably ever.

```
+------------+                             +------------+
|            |                             |            |
| Playdate 1 |                             | Playdate 2 |
|            |                             |            |
+------------+       WebRTC P2P conn       +------------+
       ^            established with              ^
       |                 PeerJS                   |
    Serial                  |                  Serial
       |                    v                     |
       v                .-------.                 v
+------------+       ,-'         '-.       +------------+
| Computer 1 |      ;               :      | Computer 2 |
| (Browser @ |<---->:   Internet    ;<---->| (Browser @ |
| pdportal)  |       \             /       | pdportal)  |
+------------+        '-.       ,-'        +------------+
                         `-----'
```

## Thanks

pdportal uses [pd-usb](https://github.com/cranksters/pd-usb) to communicate with the cheese. It's built with [Svelte](https://svelte.dev/) and [PeerJS](https://peerjs.com/).

Inspiration and help with the Lua bytecode parts came from [pd-camera](https://github.com/t0mg/pd-camera), and code from [Eric Lewis](https://gist.github.com/ericlewis/43d07016275308de11a5519466deea85).

## Running locally

```bash
npm i

npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building for production

```bash
npm run build
npm run preview
```
