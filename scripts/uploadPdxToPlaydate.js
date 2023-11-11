import { SerialPort } from 'serialport'
import Watch from 'node-watch'
import { exec } from 'child_process'
import fs from 'fs'
import path from 'path'

const pdxFilePath = path.resolve(process.argv[2])
const playdateVolumePath = '/Volumes/PLAYDATE/Games'
const baudRate = 115200

console.log('Copying PDX to Playdate')

if (!fs.existsSync(pdxFilePath)) {
	console.error('PDX file not found.')
	process.exit(1)
}

SerialPort.list().then((ports) => {
	const playdatePortInfo = ports.find((port) => {
		return (
			port.path.includes('tty.usbmodemPD') && port.manufacturer === 'Panic Inc'
		)
	})
	if (!playdatePortInfo) {
		console.error('Playdate serial port not found')
		process.exit(1)
	}

	const playdatePort = new SerialPort({
		path: playdatePortInfo.path,
		baudRate
	})

	playdatePort.write('datadisk\r\n', (err) => {
		if (err) {
			console.error('Error sending command:', err.message)
			process.exit(1)
		}
		playdatePort.close()
	})
})

function waitForMount(path, callback) {
	const interval = setInterval(() => {
		fs.access(path, fs.constants.F_OK | fs.constants.W_OK, (err) => {
			if (!err) {
				clearInterval(interval)
				callback()
			}
		})
	}, 100)
}

Watch('/Volumes', { recursive: false }, (evt, name) => {
	if (name.includes('PLAYDATE')) {
		waitForMount('/Volumes/PLAYDATE/Games', () => {
			const destPath = path.join(playdateVolumePath, path.basename(pdxFilePath))
			fs.cp(pdxFilePath, destPath, { recursive: true }, (err) => {
				if (err) {
					console.error('Error copying PDX:', err)
				} else {
					console.log('PDX copied successfully')
					ejectDisk()
				}
			})
		})
	}
})

function ejectDisk() {
	exec(`diskutil eject '/Volumes/PLAYDATE'`, (err, stdout, stderr) => {
		if (err) {
			console.error('Error ejecting disk:', stderr)
			process.exit(1)
		}
		console.log('Playdate disk ejected')
		process.exit(0)
	})
}
