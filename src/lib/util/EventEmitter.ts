export class EventEmitter {
	// eslint-disable-next-line @typescript-eslint/ban-types
	private eventHandlers: Record<string, Function[]> = {}

	// eslint-disable-next-line @typescript-eslint/ban-types
	on(eventName: string, handler: Function) {
		if (!this.eventHandlers[eventName]) {
			this.eventHandlers[eventName] = []
		}

		this.eventHandlers[eventName].push(handler)
	}

	// eslint-disable-next-line @typescript-eslint/ban-types
	off(eventName: string, handlerToRemove: Function) {
		const handlers = this.eventHandlers[eventName]
		if (!handlers) {
			return
		}

		this.eventHandlers[eventName] = handlers.filter((handler) => {
			handler !== handlerToRemove
		})
	}

	protected emit(eventName: string, ...args: unknown[]) {
		const handlers = this.eventHandlers[eventName]
		if (!handlers) {
			return
		}

		handlers.forEach((handler) => {
			handler(...args)
		})
	}
}
