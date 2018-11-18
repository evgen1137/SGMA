include '../macro/macros.inc'
declare_format
include '../native/natives.inc'
include 'const.inc'
include 'gamemode.inc'	

codeseg
callback OnGameModeInit unused
	ncall SetGameModeText, gamemodetext
	ncall UsePlayerPedAnims
	ncall EnableStuntBonusForAll, 0
	; AddPlayerClass
	xor ecx, ecx
@@:
	cmp ecx, 3
	jae @F
	push ecx
	ncall AddPlayerClass, 0, 1958.3783, 1343.1572, 15.3746, 270.1425, 0, 0, 0, 0, 0, 0
	pop ecx
	inc ecx
	jmp @B
@@:
	ncall CreatePickup, 19130, 23, 2491.0276, 1878.5166, 10.6133, 0
	mov [pickups+0], eax
	ncall CreatePickup, 19133, 23, 2442.4863, 1954.9645, 10.7966, 0
	mov [pickups+4], eax
	ncall CreatePickup, 1240, 23, 2444.5002, 1959.5040, 10.7745, 0
	mov [pickups+8], eax
	ncall CreatePickup, 1242, 2, 2487.0300, 1822.7881, 10.8203, 0
	mov [pickups+12], eax
	ncall Create3DTextLabel, StrWeapons, COLOR_CYAN, 2491.0276, 1878.5166, 10.6133, 55.0, 0, 1
	ncall Create3DTextLabel, StrDrinks, COLOR_CYAN, 2442.4863, 1954.9645, 10.7966, 55.0, 0, 1
	
	ncall fexist, StrBaseName
	test eax, eax
	je @F
	ncall db_open, StrBaseName
	mov [database], eax
@@:
	ncall db_open, StrBaseName
	mov [database], eax
	ncall db_query, [database], StrSqlCreateDb
	ncall db_free_result, eax
	
	ncall print, StrStripLine
	ncall print, StrSGMA
	ncall print, StrStripLine
	mov eax, 1
	ret
endc

callback OnGameModeExit
	mov eax, 1
	ret
endc

callback OnPlayerConnect playerid
local result:DWORD
	ncall GetPlayerName, [playerid], name, 24
	ncall sformat, temp, 256, FormatStrSqlCheckReg, name
	ncall db_query, [database], temp
	mov [result], eax
	ncall db_num_rows, [result]
	test eax, eax
	jne @F
	ncall SetPVarInt, [playerid], StrAuth, -1
	jmp .db_free
@@:
	ncall db_get_field, [result], 0, temp, 64
	ncall SetPVarString, [playerid], StrPsalt, temp
	ncall SetPVarInt, [playerid], StrAuth, 1
.db_free:
	ncall db_free_result, [result]
	lea eax, [playerid]
	ncall sformat, temp, 256, FormatStrPlayerJoined, name, eax
	ncall SendClientMessageToAll, COLOR_SYSTEM, temp
	ncall SendClientMessage, [playerid], COLOR_YELLOW, StrWelcome
	mov eax, 1
	ret
endc

callback OnPlayerDisconnect playerid, reason
	stdcall SavePlayerData, [playerid]
	ncall GetPlayerName, [playerid], name, 24
	cmp [reason], 0
	jne @F
	mov edx, StrReasonLost
	jmp .finish
@@:
	cmp [reason], 1
	jne @F
	mov edx, StrReasonExit
	jmp .finish
@@:
	mov edx, StrReasonKick
.finish:
	lea eax, [playerid]
	ncall sformat, temp, 256, FormatStrPlayerLeft, name, eax, edx
	ncall SendClientMessageToAll, COLOR_SYSTEM, temp
	mov eax, 1
	ret
endc

callback OnPlayerSpawn playerid
	ncall random,SPAWN_COUNT
	shl eax, 4
	add eax, gRandomPlayerSpawns
	push eax
	ncall SetPlayerPos, [playerid], [eax], [eax+4], [eax+8]
	pop eax
	ncall SetPlayerFacingAngle, [playerid], [eax+12]
	ncall SetCameraBehindPlayer, [playerid]
	ncall GivePlayerWeapon, [playerid], 5, 1
	ncall GivePlayerWeapon, [playerid], 25, 25
	ncall GivePlayerWeapon, [playerid], 29, 200
	ncall GivePlayerWeapon, [playerid], 30, 350
	ncall GivePlayerWeapon, [playerid], 41, 500
	ncall GivePlayerWeapon, [playerid], 22, 300
	ncall GivePlayerMoney, [playerid], 1000
	mov eax, 1
	ret
endc

callback OnPlayerDeath playerid, killerid, reason
local money:DWORD
	ncall GetPlayerMoney, [playerid]
	shr eax, 1
	mov [money], eax
	ncall SendDeathMessage, [killerid], [playerid], [reason]
	cmp [money], 0
	je @F
	ncall ResetPlayerMoney, [playerid]
	ncall GivePlayerMoney, [playerid], [money]
@@:
	cmp [killerid], INVALID_PLAYER_ID
	je @F
	ncall GetPlayerScore, [killerid]
	inc eax
	ncall SetPlayerScore, [killerid], eax
	ncall GivePlayerMoney, [killerid], [money]
	ncall GetPVarInt, [playerid], StrDeaths
	inc eax
	ncall SetPVarInt, [playerid], StrDeaths, eax
@@:
	mov eax, 1
	ret
endc

callback OnVehicleSpawn vehicleid
	mov eax, 1
	ret
endc

callback OnVehicleDeath vehicleid, killerid
	mov eax, 1
	ret
endc

callback OnPlayerText playerid:DWORD, text
	ncall GetPVarInt, [playerid], StrAuth
	test eax, eax
	je @F
	ncall SendClientMessage, [playerid], COLOR_RED, StrPleaseLogIn
	xor eax, eax
	ret
@@:
	ncall GetPlayerName, [playerid], name, 24
	stdcall ConvertToAMXStr, temp, [text] 
	ncall SetPlayerChatBubble, [playerid], temp, 0ffffaah, 35.0, 10000
	lea eax, [playerid]
	ncall sformat, temp, 256, FormatStrPlayerText, name, eax, temp
	ncall GetPlayerColor, [playerid]
	ncall SendClientMessageToAll, eax, temp
	xor eax, eax
	ret
endc

callback OnPlayerCommandText playerid, cmdtext
	ncall GetPVarInt, [playerid], StrAuth
	test eax, eax
	je @F
	ncall SendClientMessage, [playerid], COLOR_RED, StrPleaseLogIn
	mov eax, 1
	ret
@@:
	xor eax, eax
	ret
endc

callback OnPlayerRequestClass playerid, classid
local oldclass:DWORD, skin:DWORD
	ncall GetPVarInt, [playerid], StrAuth
	test eax, eax
	je @F
	stdcall ShowAuthProcess, [playerid]
	ncall SetPlayerPos, [playerid], 2482.113525, 1266.363037, 10.812500
	ncall SetPlayerFacingAngle, [playerid], 267.734191
	ncall SetPlayerCameraLookAt, [playerid], 2482.113525, 1266.363037, 10.812500
	ncall SetPlayerCameraPos, [playerid], 2489.105712, 1265.967651, 10.812500
	mov eax, 1
	ret
@@:
	ncall GetPVarInt, [playerid], StrOldclass
	mov [oldclass], eax
	ncall GetPVarInt, [playerid], StrSkin
.cmp_process1_1:
	cmp [classid], 0
	jne .cmp_process2_1
	cmp [oldclass], 2
	jne .cmp_process2_1
.process_1:
	inc eax
	cmp eax, 74
	jne @F
	inc eax
@@:
	cmp eax, 312
	jne .next_step
	mov eax, 0
	jmp .next_step
.cmp_process2_1:
	cmp [classid], 2
	jne .cmp_process1_2
	cmp [oldclass], 0
	jne .cmp_process1_2
.process_2:
	dec eax
	cmp eax, 74
	jne @F
	dec eax
@@:
	cmp eax, -1
	jne .next_step
	mov eax, 311
	jmp .next_step
.cmp_process1_2:
	mov edx, [oldclass]
	cmp [classid], edx
	ja .process_1
.cmp_process2_2:
	mov edx, [oldclass]
	cmp [classid], edx
	jb .process_2
.next_step:
	mov [skin], eax
	ncall SetPVarInt, [playerid], StrOldclass, [classid]
	ncall SetPVarInt, [playerid], StrSkin, [skin]
	ncall SetSpawnInfo, [playerid], 255, [skin], 1958.3783, 1343.1572, 15.3746, 270.1425, 0, 0, 0, 0, 0, 0
	mov eax, 1
	ret
endc

callback OnPlayerRequestSpawn playerid
	ncall GetPVarInt, [playerid], StrAuth
	test eax, eax
	je @F
	ncall SendClientMessage, [playerid], COLOR_RED, StrPleaseLogIn
	xor eax, eax
	ret
@@:
	mov eax, 1
	ret
endc

callback OnPlayerEnterVehicle playerid, vehicleid, ispassenger
	mov eax, 1
	ret
endc

callback OnPlayerExitVehicle playerid, vehicleid
	mov eax, 1
	ret
endc

callback OnPlayerStateChange playerid, newstate, oldstate
	mov eax, 1
	ret
endc

callback OnPlayerInteriorChange playerid, newinteriorid, oldinteriorid
	mov eax, 1
	ret
endc

callback OnPlayerEnterCheckpoint playerid
	mov eax, 1
	ret
endc

callback OnPlayerLeaveCheckpoint playerid
	mov eax, 1
	ret
endc

callback OnPlayerEnterRaceCheckpoint playerid
	mov eax, 1
	ret
endc

callback OnPlayerLeaveRaceCheckpoint playerid
	mov eax, 1
	ret
endc

callback OnPlayerKeyStateChange playerid, newkeys, oldkeys
	test [newkeys], KEY_YES
	je @F
	ncall ShowPlayerDialog, [playerid], 2, DIALOG_STYLE_LIST, StrMenu, StrMenuList, StrSelect, StrClose
@@:
	mov eax, 1
	ret
endc

callback OnRconCommand cmd
	mov eax, 1
	ret
endc

callback OnObjectMoved objectid
	mov eax, 1
	ret
endc

callback OnPlayerObjectMoved playerid, objectid
	mov eax, 1
	ret
endc

callback OnPlayerPickUpPickup playerid, pickupid
local health:DWORD
	ncall GetPVarInt, [playerid], StrOldPickup
	test eax, eax
	je @F
	ret
@@:
	ncall GetPlayerPos, [playerid], PlayerPos.x, PlayerPos.y, PlayerPos.z
	ncall SetPVarInt, [playerid], StrOldPickup, 1
	ncall SetPVarFloat, [playerid], StrOldPos_x, [PlayerPos.x]
	ncall SetPVarFloat, [playerid], StrOldPos_y, [PlayerPos.y]
	ncall SetPVarFloat, [playerid], StrOldPos_z, [PlayerPos.z]
	mov eax, [pickupid]
	cmp eax, [pickups+0]
	jne @F
	ncall ShowPlayerDialog, [playerid], 4, DIALOG_STYLE_TABLIST_HEADERS, StrWeaponPurchase, StrWeaponList, StrBuy, StrCancel
	ret
@@:
	cmp eax, [pickups+4]
	jne @F
	ncall ShowPlayerDialog, [playerid], 5, DIALOG_STYLE_TABLIST_HEADERS, StrDrinkShop, StrDrinkList, StrBuy, StrExit
	ret
@@:
	cmp eax, [pickups+8]
	jne @F
	lea eax, [health]
	ncall GetPlayerHealth, [playerid], eax
	cmp [health], 100.0
	jne .little_health
	ncall SendClientMessage, [playerid], COLOR_CYAN, StrFullHealth
	ret
.little_health:
	ncall GetPlayerMoney, [playerid]
	cmp eax, 50
	jae .enough_money
	ncall SendClientMessage, [playerid], COLOR_CYAN, StrNotEnoughMoney
	ret
.enough_money:
	ncall SetPlayerHealth, [playerid], 100.0
	ncall GivePlayerMoney, [playerid], -50
	ncall SendClientMessage, [playerid], COLOR_CYAN, StrHealthRestored
@@:
	cmp eax, [pickups+12]
	jne @F
	ncall SetPlayerArmour, [playerid], 100.0
	ret
@@:
	mov eax, 1
	ret
endc

callback OnPlayerExitedMenu playerid
	mov eax, 1
	ret
endc

callback OnPlayerSelectedMenuRow playerid, row
	mov eax, 1
	ret
endc

callback OnVehicleRespray playerid, vehicleid, color1, color2
	mov eax, 1
	ret
endc

callback OnVehicleMod playerid, vehicleid, componentid
	mov eax, 1
	ret
endc

callback OnEnterExitModShop playerid, enterexit, interiorid
	mov eax, 1
	ret
endc

callback OnVehiclePaintjob playerid, vehicleid, paintjobid
	mov eax, 1
	ret
endc

callback OnScriptCash playerid, arg1, arg2
	mov eax, 1
	ret
endc

callback OnRconLoginAttempt ip, password, success
	mov eax, 1
	ret
endc

callback OnPlayerUpdate playerid
	ncall GetPVarInt, [playerid], StrOldPickup
	test eax, eax
	je @F
	ncall GetPVarFloat, [playerid], StrOldPos_x
	mov [PlayerPos.x], eax
	ncall GetPVarFloat, [playerid], StrOldPos_y
	mov [PlayerPos.y], eax
	ncall GetPVarFloat, [playerid], StrOldPos_z
	mov [PlayerPos.z], eax
	ncall IsPlayerInRangeOfPoint, [playerid], 2.0, [PlayerPos.x], [PlayerPos.y], [PlayerPos.z]
	test eax, eax
	jne @F
	ncall SetPVarInt, [playerid], StrOldPickup, 0
@@:
	mov eax, 1
	ret
endc

callback OnPlayerStreamIn playerid, forplayerid
	mov eax, 1
	ret
endc

callback OnPlayerStreamOut playerid, forplayerid
	mov eax, 1
	ret
endc

callback OnVehicleStreamIn vehicleid, forplayerid
	mov eax, 1
	ret
endc

callback OnVehicleStreamOut vehicleid, forplayerid
	mov eax, 1
	ret
endc

callback OnActorStreamIn actorid, forplayerid
	mov eax, 1
	ret
endc

callback OnActorStreamOut actorid, forplayerid
	mov eax, 1
	ret
endc

callback OnDialogResponse playerid, dialogid, response, listitem, inputtext
local skin:DWORD, result:DWORD
.dialog_register:
	cmp [dialogid], 0
	jne .dialog_login
	cmp [response], 0
	jne @F
	ncall Kick, [playerid]
	ret
@@:
	stdcall ConvertToAMXStr, temp2, [inputtext]
	ncall strlen, temp2
	test eax, eax
	jne @F
	stdcall ShowAuthProcess, [playerid]
	ret
@@:
	stdcall GenRandomAMXStr, psalt, 15
	ncall SHA256_PassHash, temp2, psalt, password, 65
	ncall GetPlayerName, [playerid], name, 24
	ncall sformat, temp, 256, FormatStrSqlRegister, name, password, psalt
	ncall db_query, [database], temp
	ncall db_free_result, eax
	stdcall ZeroMemory, password, 256
	stdcall ZeroMemory, psalt, 64
	ncall SetPVarInt, [playerid], StrAuth, 0
	ncall sformat, temp, 256, FormatStrRegistrationSuccess, temp2
	ncall SendClientMessage, [playerid], -1, temp
	stdcall SetPlayerRandomColor, [playerid]
	jmp .finish
.dialog_login:
	cmp [dialogid], 1
	jne .dialog_2
	stdcall ConvertToAMXStr, temp2, [inputtext]
	ncall strlen, temp2
	test eax, eax
	jne @F
	stdcall ShowAuthProcess, [playerid]
	ret
@@:
	cmp [response], 0
	jne @F
	ncall Kick, [playerid]
	ret
@@:
	ncall GetPVarString, [playerid], StrPsalt, psalt, 16
	ncall SHA256_PassHash, temp2, psalt, password, 65
	ncall GetPlayerName, [playerid], name, 24
	ncall sformat, temp, 256, FormatStrSqlLogin, name, password
	ncall db_query, [database], temp
	mov [result], eax
	stdcall ZeroMemory, password, 256
	stdcall ZeroMemory, psalt, 64
	ncall db_num_rows, [result]
	test eax, eax
	je @F
	ncall db_get_field_assoc_int, [result], StrKills
	ncall SetPlayerScore, [playerid], eax
	ncall db_get_field_assoc_int, [result], StrDeaths
	ncall SetPVarInt, [playerid], StrDeaths, eax
	ncall db_get_field_assoc_int, [result], StrMoney
	ncall GivePlayerMoney, [playerid], eax
	ncall db_get_field_assoc_int, [result], StrSkin
	mov [skin], eax
	ncall SetPVarInt, [playerid], StrSkin, [skin]
	ncall SetSpawnInfo, [playerid], 255, [skin], 1958.3783, 1343.1572, 15.3746, 270.1425, 0, 0, 0, 0, 0, 0
	ncall SetPlayerSkin, [playerid], [skin]
	ncall db_get_field_assoc_int, [result], StrColor
	ncall SetPlayerColor, [playerid], eax
	ncall SendClientMessage, [playerid], -1, StrLogInSuccess
	ncall SetPVarInt, [playerid], StrAuth, 0
	jmp .endif
@@:
	ncall SendClientMessage, [playerid], -1, StrLogInFail
	stdcall ShowAuthProcess, [playerid]
.endif:
	ncall db_free_result, [result]
	jmp .finish
.dialog_2:
	cmp [dialogid], 2
	jne .dialog_4
	cmp [response], 0
	je .dialog_4
	cmp [listitem], 0
	jne @F
	ncall ShowPlayerDialog, [playerid], 111, DIALOG_STYLE_MSGBOX, StrHelp, StrHelpText, StrClose, StrNULL
	jmp .enditems
@@:
	cmp [listitem], 1
	jne @F
	stdcall ShowPlayerStatsForPlayer, [playerid], [playerid]
	jmp .enditems
@@:
	cmp [listitem], 2
	jne @F
	ncall SetPlayerHealth, [playerid], 0.0
@@:
.enditems:
	jmp .finish
.dialog_4:
	cmp [dialogid], 4
	jne .dialog_5
	cmp [response], 0
	jne @F
	mov eax, 1
	ret
@@:
	ncall GetPlayerMoney, [playerid]
	mov ecx,[listitem]
	lea ecx, [ecx*2+ecx]
	cmp eax, [ecx*4+WeaponsData+2*4]
	jae @F
	ncall SendClientMessage, [playerid], COLOR_RED, StrNotEnoughMoney
	ret
@@:
	mov eax,[listitem]
	lea eax, [eax*2+eax]
	ncall GivePlayerWeapon, [playerid], [eax*4+WeaponsData+0*4], [eax*4+WeaponsData+1*4]
	mov eax,[listitem]
	lea eax, [eax*2+eax]
	mov eax, [eax*4+WeaponsData+2*4]
	neg eax
	ncall GivePlayerMoney, [playerid], eax
	stdcall ConvertToAMXStr, temp2, [inputtext]
	ncall sformat, temp, 256, FormatStrYouHaveBought, temp2
	ncall SendClientMessage, [playerid], COLOR_CYAN, temp
	jmp .finish
.dialog_5:
	cmp [dialogid], 5
	jne .dialog_6
	cmp [response], 0
	jne @F
	mov eax, 1
	ret
@@:
	ncall GetPlayerMoney, [playerid]
	mov ecx,[listitem]
	cmp eax, [ecx*8+DrinksData+0*4]
	jae @F
	ncall SendClientMessage, [playerid], COLOR_RED, StrNotEnoughMoney
	ret
@@:
	cmp [listitem], 4
	jae @F
	mov eax, [listitem]
	ncall SetPlayerSpecialAction, [playerid], [eax*8+DrinksData+1*4]
@@:
	cmp [listitem], 4
	jne @F
	ncall SetPlayerDrunkLevel, [playerid], 0
@@:
	mov eax,[listitem]
	mov eax, [eax*8+DrinksData+0*4]
	neg eax
	ncall GivePlayerMoney, [playerid], eax
	stdcall ConvertToAMXStr, temp2, [inputtext]
	ncall sformat, temp, 256, FormatStrYouHaveBought, temp2
	ncall SendClientMessage, [playerid], COLOR_CYAN, temp
	jmp .finish
.dialog_6:
	; ...
	
.finish:
	mov eax, 1
	ret
endc

callback OnPlayerClickPlayer playerid, clickedplayerid, source
	stdcall ShowPlayerStatsForPlayer, [playerid], [clickedplayerid]
	mov eax, 1
	ret
endc

callback OnPlayerTakeDamage playerid, issuerid, amount, weaponid, bodypart
	mov eax, 1
	ret
endc

callback OnPlayerGiveDamage playerid, damagedid, amount, weaponid, bodypart
	mov eax, 1
	ret
endc

callback OnPlayerGiveDamageActor playerid, damaged_actorid, amount, weaponid, bodypart
	mov eax, 1
	ret
endc

callback OnVehicleDamageStatusUpdate vehicleid, playerid
	mov eax, 1
	ret
endc

callback OnUnoccupiedVehicleUpdate vehicleid, playerid, passenger_seat, unused, newpos, vel
	mov eax, 1
	ret
endc

callback OnPlayerClickMap playerid, x, y, z
	mov eax, 1
	ret
endc

callback OnPlayerEditAttachedObject playerid, index, response, EditObject
	mov eax, 1
	ret
endc

callback OnPlayerEditObject playerid, playerobject, objectid, response, fX, fY, fZ, fRotX, fRotY, fRotZ
	mov eax, 1
	ret
endc

callback OnPlayerSelectObject playerid, type, objectid, modelid, fX, fY, fZ
	mov eax, 1
	ret
endc

callback OnPlayerClickTextDraw playerid, clickedid
	mov eax, 1
	ret
endc

callback OnPlayerClickPlayerTextDraw playerid, playertextid
	mov eax, 1
	ret
endc

callback OnPlayerWeaponShot playerid, weaponid, hittype, hitid, pos
	mov eax, 1
	ret
endc

callback OnIncomingConnection playerid, ip_address, port
	mov eax, 1
	ret
endc

callback OnTrailerUpdate playerid, vehicleid
	mov eax, 1
	ret
endc

callback OnVehicleSirenStateChange playerid, vehicleid, newstate
	mov eax, 1
	ret
endc


proc ShowAuthProcess playerid
local result:DWORD
	ncall GetPlayerName, [playerid], name, 24
	ncall GetPVarInt, [playerid], StrAuth
	cmp eax, -1
	jne @F
	ncall sformat, temp, 256, FormatStrWelcomeReg, name
	ncall ShowPlayerDialog, [playerid], 0, DIALOG_STYLE_INPUT, StrRegistration, temp, StrRegister, StrNULL
	jmp .finish
@@:
	cmp eax, 1
	jne .finish
	ncall sformat, temp, 256, FormatStrWelcomeLogin, name
	ncall ShowPlayerDialog, [playerid], 1, DIALOG_STYLE_PASSWORD, StrAuthorization, temp, StrLogIn, StrNULL
.finish:
	mov eax, 1
	ret
endp

proc SavePlayerData playerid
local color:DWORD, skin:DWORD, money:DWORD, deaths:DWORD, score:DWORD
	ncall GetPVarInt, [playerid], StrAuth
	test eax, eax
	je @F
	ret
@@:
	ncall GetPlayerName, [playerid], name, 24
	push name
	ncall GetPlayerColor, [playerid]
	mov [color], eax
	lea eax, [color]
	push eax
	ncall GetPlayerSkin, [playerid]
	mov [skin], eax
	lea eax, [skin]
	push eax
	ncall GetPlayerMoney, [playerid]
	mov [money], eax
	lea eax, [money]
	push eax
	ncall GetPVarInt, [playerid], StrDeaths
	mov [deaths], eax
	lea eax, [deaths]
	push eax
	ncall GetPlayerScore, [playerid]
	mov [score], eax
	lea eax, [score]
	push eax
	push FormatStrSqlSavePlayer
	push 256
	push temp
	push 36
	push esp
	push famx
	mov eax, sformat
	call eax
	add esp, 48
	ncall db_query, [database], temp
	ncall db_free_result, eax
	ret
endp

proc ShowPlayerStatsForPlayer, forplayerid, ofplayerid
local money:DWORD, deaths:DWORD, score:DWORD
	ncall GetPlayerMoney, [ofplayerid]
	mov [money], eax
	lea eax, [money]
	push eax
	ncall GetPVarInt, [ofplayerid], StrDeaths
	mov [deaths], eax
	lea eax, [deaths]
	push eax
	ncall GetPlayerScore, [ofplayerid]
	mov [score], eax
	lea eax, [score]
	push eax
	ncall GetPlayerName, [ofplayerid], name, 24
	push name
	push FormatStrStats
	push 256
	push temp
	push 28
	push esp
	push famx
	mov eax, sformat
	call eax
	add esp, 40
	ncall ShowPlayerDialog, [forplayerid], 111, DIALOG_STYLE_MSGBOX, StrPlayerStats, temp, StrClose, StrNULL
	ret
endp

proc SetPlayerRandomColor playerid
local color:DWORD
	mov [color], 0ffh
	ncall random, 200
	add eax, 50
	shl eax, 24
	or [color], eax
	ncall random, 200
	add eax, 50
	shl eax, 16
	or [color], eax
	ncall random, 200
	add eax, 50
	shl eax, 8
	or [color], eax
	ncall SetPlayerColor, [playerid], [color]
	ret
endp

proc ConvertToAMXStr uses esi edi, dest, source
	xor eax, eax
	xor ecx, ecx
	mov esi, [source]
	mov edi, [dest]
@@:
	mov al, byte [esi+ecx]
	cmp al, 0
	je @F
	mov [edi+ecx*4], eax
	inc ecx
	jmp @B
@@:
	mov dword [edi+ecx*4], 0
	ret
endp

proc GenRandomAMXStr uses esi edi, str, len
	mov esi, symbs
	mov edi, [str]
	xor ecx, ecx
@@:
	cmp ecx, [len]
	jae @F
	push ecx
	ncall random, 62
	pop ecx
	mov eax, [esi+eax*4]
	mov [edi+ecx*4], eax
	inc ecx
	jmp @B
@@:
	mov dword [edi+ecx*4], 0
	ret
endp

proc ZeroMemory uses edi, address, len
	mov edi, [address]
	mov ecx, [len]
	xor eax, eax
	rep stosb
	ret
endp