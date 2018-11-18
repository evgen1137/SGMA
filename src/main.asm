include 'macro/macros.inc'
declare_format
include 'main.inc'

codeseg
if target_system eq windows
	public DllEntryPoint as '__DllMainCRTStartup@12'
	proc DllEntryPoint hinstDLL,fdwReason,lpvReserved
		mov eax, 1
		ret
	endp
else if target_system eq linux
	public start
	start:
		ret
end if

plugin_proc Supports
	mov eax, 20200h ; SUPPORTS_VERSION | SUPPORTS_PROCESS_TICK
	ret
endp

plugin_proc Load uses esi edi, ppData
	mov [famx.heap], MAX_VAL
	mov [famx.stp], MAX_VAL
	mov eax, [famx.header]
	mov word [eax + 4], 0f1e0h ; famx.header.magic
	mov edx, eax
	neg edx
	mov [eax + 16], edx ; famx.header.dat

	if target_system eq linux
	stdcall UnProtect, 80986DFh, 4
	mov eax, 80986DFh
	mov dword [eax], 90909090h
	end if
	
	xor ecx, ecx
	mov esi, callbackAddresses
	mov edi, callbackPointers
@@:
	cmp ecx, 57
	jae @F
	stdcall InstallJmpHook, [esi + ecx*4], [edi + ecx*4]
	inc ecx
	jmp @B
@@:
	mov eax, 1
	ret
endp

plugin_proc Unload
	ret
endp

plugin_proc ProcessTick
	ret
endp

proc UnProtect address, size
if target_system eq windows
local oldProtect:DWORD
	lea eax, [oldProtect]
	invoke VirtualProtect, [address], [size], 40h, eax ; PAGE_EXECUTE_READWRITE
else if target_system eq linux
	mov edx, 111b
	mov ecx, [size]
	mov ebx, [address]
	and ebx, 0FFFFF000h
	mov eax, 125
	int 80h
end if
	ret
endp

proc InstallJmpHook uses ecx, hookAddr, hookFunc
	stdcall UnProtect, [hookAddr], 5
	mov edx, [hookFunc]
	sub edx, [hookAddr]
	sub edx, 5
	mov eax, [hookAddr]
	mov byte [eax], 0E9h
	mov [eax + 1], edx
	ret
endp


dataseg
	struct FakeAMXHeader
		data db 256 dup (?)
		size dd ?
		magic dw ?
		dump1 db 10 dup(?)
		dat dd ?
		dump2 db 36 dup(?)
	ends
	struct FakeAMX
		header dd ? ; pFakeAMXHeader
		dump1 db 20 dup (?)
		heap dd ?
		dump2 db 8 dup (?)
		stp dd ?
		dump3 db 62 dup (?)
	ends
	
	famxheader FakeAMXHeader <>
	famx FakeAMX <famxheader>
	public famx
	
	callbackPointers dd OnGameModeInit, OnGameModeExit, OnPlayerConnect, OnPlayerDisconnect, OnPlayerSpawn, OnPlayerDeath, OnVehicleSpawn, OnVehicleDeath, OnPlayerText, OnPlayerCommandText, OnPlayerRequestClass, OnPlayerRequestSpawn, OnPlayerEnterVehicle, OnPlayerExitVehicle, OnPlayerStateChange, OnPlayerInteriorChange, OnPlayerEnterCheckpoint, OnPlayerLeaveCheckpoint, OnPlayerEnterRaceCheckpoint, OnPlayerLeaveRaceCheckpoint, OnPlayerKeyStateChange, OnRconCommand, OnObjectMoved, OnPlayerObjectMoved, OnPlayerPickUpPickup, OnPlayerExitedMenu, OnPlayerSelectedMenuRow, OnVehicleRespray, OnVehicleMod, OnEnterExitModShop, OnVehiclePaintjob, OnScriptCash, OnRconLoginAttempt, OnPlayerUpdate, OnPlayerStreamIn, OnPlayerStreamOut, OnVehicleStreamIn, OnVehicleStreamOut, OnActorStreamIn, OnActorStreamOut, OnDialogResponse, OnPlayerClickPlayer, OnPlayerTakeDamage, OnPlayerGiveDamage, OnPlayerGiveDamageActor, OnVehicleDamageStatusUpdate, OnUnoccupiedVehicleUpdate, OnPlayerClickMap, OnPlayerEditAttachedObject, OnPlayerEditObject, OnPlayerSelectObject, OnPlayerClickTextDraw, OnPlayerClickPlayerTextDraw, OnPlayerWeaponShot, OnIncomingConnection, OnTrailerUpdate, OnVehicleSirenStateChange
	if target_system eq windows
		callbackAddresses dd 46F560h, 46D7B0h, 46D910h, 46D970h, 46D9D0h, 46DA30h, 46DAB0h, 46DB10h, 46DB80h, 46DC80h, 46DD30h, 46DDC0h, 46DE40h, 46DEE0h, 46DF70h, 46E010h, 46E0B0h, 46E130h, 46E190h, 46E1F0h, 46E250h, 46E2C0h, 46E340h, 46E3A0h, 46E410h, 46E480h, 46E4E0h, 46E550h, 46E5D0h, 46E650h, 46E6D0h, 46E750h, 46E7D0h, 46E880h, 46E8E0h, 46E950h, 46E9C0h, 46EA30h, 46EAA0h, 46EB10h, 46EB80h, 46EC50h, 46ECF0h, 46ED70h, 46EDF0h, 46EE70h, 46EEE0h, 46EFC0h, 46F030h, 46F150h, 46F210h, 46F2A0h, 46F300h, 46F360h, 46F400h, 46F480h, 46F4E0h
	else if target_system eq linux
		callbackAddresses dd 80A4E90h, 80A4DB0h, 80A5160h, 80A51D0h, 80A5250h, 80A52C0h, 80A5350h, 80A53C0h, 80A5440h, 80A5580h, 80A56C0h, 80A5760h, 80A57F0h, 80A58A0h, 80A5940h, 80A59F0h, 80A5AA0h, 80A5B30h, 80A5BA0h, 80A5C10h, 80A5C80h, 80A5D10h, 80A5DB0h, 80A5E20h, 80A5EA0h, 80A5F20h, 80A5F90h, 80A6010h, 80A60B0h, 80A6140h, 80A61D0h, 80A6260h, 80A62F0h, 80A63E0h, 80A6450h, 80A64D0h, 80A6550h, 80A65D0h, 80A6650h, 80A66D0h, 80A6750h, 80A6850h, 80A6910h, 80A69C0h, 80A6A70h, 80A6B20h, 80A6BA0h, 80A6CC0h, 80A6D70h, 80A6EF0h, 80A7010h, 80A70F0h, 80A7170h, 80A72A0h, 80A7380h, 80A7430h, 80A74B0h
	end if