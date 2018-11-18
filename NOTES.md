## Technical Notes

* This gamemode is designed to be run on 0.3.7 R2 server version. It won't work on any other version.
* The `gamemode0` *(and also 1-15)* parameter in server.cfg has no effect but an existing file must be specified
* RCON commands such as `gmx` and `changemode` don't work, so you'll have to restart the server completely in order to reload the gamemode.

## Development Notes

* The `src` folder is structured as follows:
 * `gamemode` - source files related to gamemode logic
 * `macro` - macros
 * `native` - native addresses list
 * `main.asm` - the plugin core that lets you run the gamemode in assembly
* Most of the macros are taken from fasm
* SGMA's own macros are based on fasm macros
* The `callback` and `plugin_proc` macros are analogous to the `proc` macro, except you can't specify the calling convention to use
* To call a native pawn function you'll have to use the `ncall` macro
* The `format` native was renamed to `sformat` due to fasm syntax restrictions
* All optional arguments in natives have to be passed explicitly
* Variadic natives accept addresses instead of their respective values as arguments
* Pawn natives operate on 4-byte strings while callbacks accept 1-byte strings, so in order to extend these you'll have to use the `ConvertToAMXString` function
* Most natives such as `SetTimer(Ex)`, `CallLocalFunction`, `setproperty` etc. will not work due to the absence of an AMX machine
* If you want to use timers you'll have to write your own timer processor based on `ProcessTick`