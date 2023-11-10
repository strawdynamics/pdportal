import {
	writable,
	type Unsubscriber,
	type Writable,
	type Subscriber,
	type Invalidator
} from 'svelte/store'

export enum ToastLevel {
	Info,
	Warning
}

export interface Toast {
	id: number
	title: string
	description: string
	level: ToastLevel
}

interface ToastStoreData {
	toasts: Toast[]
}

class ToastStore {
	private writable: Writable<ToastStoreData>

	private nextToastId = 1

	subscribe: (
		this: void,
		run: Subscriber<ToastStoreData>,
		invalidate?: Invalidator<ToastStoreData>
	) => Unsubscriber

	constructor() {
		this.writable = writable({
			toasts: []
		})

		this.subscribe = this.writable.subscribe
	}

	addToast(title: string, description: string, level: ToastLevel) {
		this.writable.update((state) => {
			const toast = {
				id: this.nextToastId++,
				title,
				description,
				level
			}

			state.toasts.push(toast)
			return state
		})
	}

	removeToast(id: number) {
		this.writable.update((state) => {
			const toastIndex = state.toasts.findIndex((toast) => {
				return toast.id === id
			})

			if (toastIndex > -1) {
				state.toasts.splice(toastIndex, 1)
			}

			return state
		})
	}
}

export const toastStore = new ToastStore()
