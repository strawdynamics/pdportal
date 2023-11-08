// Ported from https://github.com/cranksters/playdate-reverse-engineering/blob/main/tools/pdz.py
import { readFileSync, mkdirSync, writeFileSync } from 'fs';
import { join, dirname } from 'path';
import { inflateSync } from 'zlib';

const PDZ_IDENT = Buffer.from('Playdate PDZ');
const FILE_TYPES = {
	1: 'luac',
	2: 'pdi',
	3: 'pdt',
	4: 'unknown', // guess would be pdv
	5: 'pda',
	6: 'str',
	7: 'pft'
};

class PlaydatePdz {
	static open(filePath) {
		return new PlaydatePdz(readFileSync(filePath));
	}

	constructor(buffer) {
		this.buffer = buffer;
		this.entries = {};
		this.num_entries = 0;
		this.readHeader();
		this.readEntries();
	}

	readHeader() {
		let magic = this.buffer.slice(0, 16);
		magic = magic.slice(0, magic.indexOf(0)); // trim null bytes
		if (!magic.equals(PDZ_IDENT)) {
			throw new Error('Invalid PDZ file ident');
		}
	}

	readString(offset) {
		let end = offset;
		while (this.buffer[end] !== 0) end++;
		return this.buffer.toString('utf8', offset, end);
	}

	readEntries() {
		let ptr = 0x10;
		const pdzLen = this.buffer.length;
		while (ptr < pdzLen) {
			const head = this.buffer.readUInt32LE(ptr);
			ptr += 4;
			const flags = head & 0xff;
			let entryLen = (head >> 8) & 0xffffff;
			const isCompressed = (flags >> 7) & 0x1;
			const fileType = FILE_TYPES[flags & 0xf];
			const file_name = this.readString(ptr);
			ptr += file_name.length + 1; // +1 for the null terminator
			ptr = (ptr + 3) & ~3; // align offset to next nearest multiple of 4

			let decompressedSize = entryLen;
			if (isCompressed) {
				decompressedSize = this.buffer.readUInt32LE(ptr);
				ptr += 4;
				entryLen -= 4;
			}

			const data = this.buffer.slice(ptr, ptr + entryLen);
			ptr += entryLen;

			this.num_entries++;
			this.entries[file_name] = {
				name: file_name,
				type: fileType,
				data: data,
				size: entryLen,
				compressed: isCompressed,
				decompressedSize: decompressedSize
			};
		}
	}

	getEntryData(name) {
		if (!(name in this.entries)) {
			throw new Error('Entry not found');
		}
		const entry = this.entries[name];
		if (entry.compressed) {
			return inflateSync(entry.data);
		}
		return entry.data;
	}

	saveEntryData(name, outDir) {
		if (!(name in this.entries)) {
			throw new Error('Entry not found');
		}
		const entry = this.entries[name];
		const data = this.getEntryData(name);
		const filePath = join(outDir, `${entry.name}.${entry.type}`);
		if (filePath.includes('/')) {
			mkdirSync(dirname(filePath), { recursive: true });
		}
		writeFileSync(filePath, data);
	}

	saveEntries(outDir) {
		for (const name in this.entries) {
			this.saveEntryData(name, outDir);
		}
	}
}

const args = process.argv.slice(2);

if (args.length < 2) {
	console.log('pdz.js');
	console.log('Unpack a Playdate .pdz executable file archive');
	console.log('Usage:');
	console.log('node pdz.js input.pdz output_directory');
	process.exit();
}

const pdz = PlaydatePdz.open(args[0]);
pdz.saveEntries(args[1]);
