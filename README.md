# [WIP] pdportal

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

pdportal uses [pd-usb](https://github.com/cranksters/pd-usb) and info from [playdate-reverse-engineering](https://github.com/cranksters/playdate-reverse-engineering) to communicate with the cheese. It's built with [Svelte](https://svelte.dev/) and [PeerJS](https://peerjs.com/).

Inspiration and help with the Lua bytecode parts came from [pd-camera](https://github.com/t0mg/pd-camera), and code from [Eric Lewis](https://gist.github.com/ericlewis/43d07016275308de11a5519466deea85).

## Want to help?

### Contributing

Thanks for your interest in contributing to pdportal! Before you get started:

1. Read and agree to follow the [code of conduct (Contributor Covenant 2.1)]('./CODE_OF_CONDUCT.md').
2. Before you start work, check the [open issues](https://github.com/strawdynamics/pdportal/issues) to make sure there isn't an existing issue for the fix or feature you want to work on.
3. If there's not already a relevant issue, [open a new one](https://github.com/strawdynamics/pdportal/issues/new). Your new issue should describe the fix or feature, why you think it's necessary, and how you want to approach the work (please use one of the issue templates).
4. Project maintainers will review your proposal and work with you to figure out next steps!

### Running locally

```bash
npm i

npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

### Building for production

```bash
npm run build
npm run preview
```
