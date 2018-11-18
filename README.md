## SAMP GameMode in Assembly (SGMA)

SGMA is the first [SAMP](http://sa-mp.com/) gamemode written entirely in assembly programming language using [fasm](https://flatassembler.net/)

#### Technical features
* As fast as it gets: doesn't use an AMX machine, runs on native x86 code
* Cross-platform: in assembly, yeah!

#### Gamemode features

* Simple Deathmatch
* SQLite-based account system
* Weapon store

## Building

### On Linux

1. Download flat assembler from the [official website](https://flatassembler.net/download.php)
2. Unpack it anywhere you want
3. Open `makefile`
4. Specify the path to the fasm binary
5. Save and run `make`

### On Windows

1. Download flat assembler from the [official website](https://flatassembler.net/download.php)
2. Unpack it anywhere you want
3. Fasm doesn't come with a linker and Microsoft Linker isn't distributed separately, so you'll need to download a [MASM32](http://www.masm32.com/download.htm) package and install it
4. Open `build.bat` and specify the path to the fasm executable, Microsoft Linker, and its libraries
5. Run `build.bat`

## Running

1. Place `sgma.dll` (on Windows) or `sgma.so` (on Linux) into the `plugins` folder
2. Open `server.cfg` and append `sgma` or `sgma.so` to the `plugins` line

## Notes

For technical and development notes please see [NOTES.md](NOTES.md)