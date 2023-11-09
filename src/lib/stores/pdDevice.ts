import type { PlaydateDevice } from 'pd-usb'
import { writable, type Writable } from 'svelte/store'

export const pdDevice: Writable<PlaydateDevice | null> = writable(null)
