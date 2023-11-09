import type { PlaydateDevice } from '$lib/3p/pd-usb/src/PlaydateDevice'
import { writable, type Writable } from 'svelte/store'

export const pdDevice: Writable<PlaydateDevice | null> = writable(null)
