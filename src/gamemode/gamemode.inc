extrn famx

dataseg
	database dd ?
	name dd 24 dup(?)
	gamemodetext dd 'S','G','M','A',' ','v','.','1','.','0',0
	temp dd 256 dup(?)
	temp2 dd 256 dup(?)
	password dd 65 dup(?)
	psalt dd 16 dup(?)
	gRandomPlayerSpawns \
		dd 2454.3687,1916.3915,10.8647,0.0 ; [9][4]
		dd 2405.5835,1878.7028,6.0156,8.1797
		dd 2382.5117,1940.2798,6.0156,270.1054
		dd 2470.5654,1904.4154,10.0,353.1396
		dd 2475.3967,1918.5911,11.0,0.0
		dd 2479.4321,1919.6423,10.4690,0.0
		dd 2478.2734,1860.4120,11.0,0.0
		dd 2478.0894,1922.1348,13.4848,8.4697
		dd 2467.0647,1963.1084,11.0,172.4239
	pickups dd 4 dup(?)
	WeaponsData \
		dd 4, 1, 20
		dd 24, 50, 200
		dd 26, 80, 300
		dd 27, 80, 400
		dd 31, 100, 550
		dd 32, 150, 300
		dd 34, 100, 900
	DrinksData \
		dd 10, SPECIAL_ACTION_DRINK_SPRUNK
		dd 50, SPECIAL_ACTION_DRINK_BEER
		dd 100, SPECIAL_ACTION_DRINK_WINE
		dd 10, SPECIAL_ACTION_SMOKE_CIGGY
		dd 100, SPECIAL_ACTION_NONE
	struct Coord
		x dd ?
		y dd ?
		z dd ?
	ends
	PlayerPos Coord <>
	; strings
	StrSGMA dd 'S','G','M','A',' ','L','o','a','d','e','d','!',0 ; SGMA Loaded!
	StrStripLine dd '-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-',0 ; ---------------------------------
	StrWelcome dd 'W','e','l','c','o','m','e',' ','t','o',' ','S','G','M','A','!',' ','P','r','e','s','s',' ','~','k','~','~','C','O','N','V','E','R','S','A','T','I','O','N','_','Y','E','S','~',' ','t','o',' ','o','p','e','n',' ','m','e','n','u',0 ; Welcome to SGMA! Press ~k~~CONVERSATION_YES~ to open menu
	FormatStrPlayerJoined dd 'P','l','a','y','e','r',' ','%','s',' ','[','I','D',':','%','d',']',' ','h','a','s',' ','j','o','i','n','e','d',' ','t','h','e',' ','s','e','r','v','e','r',0 ; Player %s [ID:%d] has joined the server
	FormatStrPlayerLeft dd 'P','l','a','y','e','r',' ','%','s',' ','[','I','D',':','%','d',']',' ','h','a','s',' ','l','e','f','t',' ','t','h','e',' ','s','e','r','v','e','r',' ','(','%','s',')',0 ; Player %s [ID:%d] has left the server (%s)
	FormatStrPlayerText dd '%','s',' ','[','%','d',']',':',' ','{','f','f','f','f','f','f','}','%','s',0 ; %s [%d]: {ffffff}%s
	FormatStrWelcomeReg dd 'W','e','l','c','o','m','e',' ','t','o',' ','t','h','e',' ','s','e','r','v','e','r',',',' ','%','s','!',0ah,'T','h','i','s',' ','a','c','c','o','u','n','t',' ','i','s','n','''','t',' ','r','e','g','i','s','t','e','r','e','d','.',0ah,'P','l','e','a','s','e',',',' ','r','e','g','i','s','t','e','r',':',0 ; Welcome to the server, %s!\nThis account isn't registered.\nPlease, register:
	FormatStrWelcomeLogin dd 'W','e','l','c','o','m','e',' ','t','o',' ','t','h','e',' ','s','e','r','v','e','r',',',' ','%','s','!',0ah,'T','h','i','s',' ','a','c','c','o','u','n','t',' ','i','s',' ','r','e','g','i','s','t','e','r','e','d','.',0ah,'P','l','e','a','s','e',',',' ','l','o','g',' ','i','n',':',0 ; Welcome to the server, %s!\nThis account is registered.\nPlease, log in:
	StrRegistration dd 'R','e','g','i','s','t','r','a','t','i','o','n',0 ; Registration
	StrAuthorization dd 'A','u','t','h','o','r','i','z','a','t','i','o','n',0 ; Authorization
	StrRegister dd 'R','e','g','i','s','t','e','r',0 ; Register
	StrLogIn dd 'L','o','g',' ','I','n',0 ; Log In
	StrNULL dd 0 ; 
	FormatStrRegistrationSuccess dd 'Y','o','u','''','r','e',' ','s','u','c','c','e','s','s','f','u','l','l','y',' ','r','e','g','i','s','t','e','r','e','d',' ','a','n','d',' ','l','o','g','g','e','d',' ','i','n','.',' ','D','o','n','''','t',' ','f','o','r','g','e','t',' ','y','o','u','r',' ','p','a','s','s','w','o','r','d',':',' ','%','s',0 ; You're successfully registered and logged in. Don't forget your password: %s
	StrLogInSuccess dd 'Y','o','u','''','r','e',' ','s','u','c','c','e','s','s','f','u','l','l','y',' ','l','o','g','g','e','d',' ','i','n','.',0 ; You're successfully logged in.
	StrLogInFail dd 'E','R','R','O','R',':',' ','W','r','o','n','g',' ','p','a','s','s','w','o','r','d',0 ; ERROR: Wrong password
	FormatStrYouHaveBought dd 'Y','o','u',' ','h','a','v','e',' ','b','o','u','g','h','t',' ','%','s',0 ; You have bought %s
	StrReasonLost dd 'L','o','s','t',' ','c','o','n','n','e','c','t','i','o','n',0 ; Lost connection
	StrReasonExit dd 'E','x','i','t',0 ; Exit
	StrReasonKick dd 'K','i','c','k','e','d','/','B','a','n','n','e','d',0 ; Kicked/Banned
	StrKills dd 'k','i','l','l','s',0 ; kills
	StrDeaths dd 'd','e','a','t','h','s',0 ; deaths
	StrMoney dd 'm','o','n','e','y',0 ; money
	StrSkin dd 's','k','i','n',0 ; skin
	StrAuth dd 'a','u','t','h',0 ; auth
	StrColor dd 'c','o','l','o','r',0 ; color
	StrPsalt dd 'p','s','a','l','t',0 ; psalt
	StrOldclass dd 'o','l','d','c','l','a','s','s',0 ; oldclass
	StrOldPickup dd 'o','l','d','p','i','c','k','u','p',0 ; oldpickup
	StrOldPos_x dd 'o','l','d','p','o','s','_','x',0 ; oldpos_x
	StrOldPos_y dd 'o','l','d','p','o','s','_','y',0 ; oldpos_y
	StrOldPos_z dd 'o','l','d','p','o','s','_','z',0 ; oldpos_z
	StrMenu dd 'M','e','n','u',0 ; Menu
	StrMenuList dd 'G','e','t',' ','h','e','l','p',0ah,'M','y',' ','s','t','a','t','s',0ah,'S','u','i','c','i','d','e',0 ; Get help\nMy stats\nSuicide
	StrHelp dd 'H','e','l','p',0 ; Help
	StrHelpText dd 'T','h','i','s',' ','i','s',' ','a',' ','s','i','m','p','l','e',' ','d','e','a','t','h','m','a','t','c','h',' ','g','a','m','e','m','o','d','e','.',' ','Y','o','u',' ','g','e','t',' ','$','1','0','0','0',' ','o','n',' ','s','p','a','w','n',0ah,'a','n','d',' ','l','o','s','e',' ','5','0','%',' ','o','f',' ','y','o','u','r',' ','m','o','n','e','y',' ','o','n',' ','d','e','a','t','h','.',' ','C','o','n','v','e','r','s','e','l','y',',',' ','y','o','u',' ','g','e','t',' ','5','0','%',0ah,'o','f',' ','y','o','u','r',' ','v','i','c','t','i','m','''','s',' ','m','o','n','e','y',' ','a','f','t','e','r',' ','a',' ','k','i','l','l','.',' ','A','t',' ','t','h','e',' ','c','o','n','s','t','r','u','c','t','i','o','n',' ','s','i','t','e',0ah,'y','o','u','''','l','l',' ','f','i','n','d',' ','h','e','a','l','t','h',',',' ','a','r','m','o','r',',',' ','a',' ','w','e','a','p','o','n',' ','s','t','o','r','e',' ','a','n','d',' ','a',' ','l','i','q','u','o','r',' ','s','t','o','r','e',0 ; This is a simple deathmatch gamemode. You get $1000 on spawn\nand lose 50% of your money on death. Conversely, you get 50%\nof your victim's money after a kill. At the construction site\nyou'll find health, armor, a weapon store and a liquor store
	StrSelect dd 'S','e','l','e','c','t',0 ; Select
	StrClose dd 'C','l','o','s','e',0 ; Close
	StrPlayerStats dd 'P','l','a','y','e','r',' ','s','t','a','t','s',0 ; Player stats
	FormatStrStats dd 'N','a','m','e',':',' ','%','s',0ah,'K','i','l','l','s',':',' ','%','d',0ah,'D','e','a','t','h','s',':',' ','%','d',0ah,'M','o','n','e','y',':',' ','%','d',0 ; Name: %s\nKills: %d\nDeaths: %d\nMoney: %d
	StrWeapons dd 'W','e','a','p','o','n','s',0 ; Weapons
	StrDrinks dd 'D','r','i','n','k','s',0 ; Drinks
	StrWeaponPurchase dd 'W','e','a','p','o','n',' ','p','u','r','c','h','a','s','e',0 ; Weapon purchase
	StrWeaponList dd 'W','e','a','p','o','n',09h,'C','o','s','t',0ah,'K','n','i','f','e',09h,'$','2','0',0ah,'D','e','s','e','r','t',' ','D','e','a','g','l','e',09h,'$','2','0','0',0ah,'S','a','w','n','o','f','f',' ','S','h','o','t','g','u','n',09h,'$','3','0','0',0ah,'C','o','m','b','a','t',' ','S','h','o','t','g','u','n',09h,'$','4','0','0',0ah,'M','4',09h,'$','5','5','0',0ah,'T','e','c','9',09h,'$','3','0','0',0ah,'S','n','i','p','e','r',' ','R','i','f','l','e',09h,'$','9','0','0',0
	StrDrinkShop dd 'D','r','i','n','k',' ','S','h','o','p',0 ; Drink Shop
	StrDrinkList dd 'N','a','m','e',09h,'C','o','s','t',0ah,'S','p','r','u','n','k',09h,'(','$','1','0',')',0ah,'B','e','e','r',09h,'(','$','5','0',')',0ah,'W','i','n','e',09h,'(','$','1','0','0',')',0ah,'C','i','g','a','r','e','t','t','e',09h,'(','$','1','0',')',0ah,'A','s','p','i','r','i','n',09h,'(','$','1','0','0',')',0 ; 
	StrBuy dd 'B','u','y',0 ; Buy
	StrCancel dd 'C','a','n','c','e','l',0 ; Cancel
	StrExit dd 'E','x','i','t',0 ; Exit
	StrFullHealth dd 'Y','o','u','r',' ','h','e','a','l','t','h',' ','i','s',' ','f','u','l','l',0 ; Your health is full
	StrNotEnoughMoney dd 'Y','o','u',' ','h','a','v','e',' ','n','o','t',' ','e','n','o','u','g','h',' ','m','o','n','e','y',0 ; You have not enough money
	StrHealthRestored dd 'Y','o','u','r',' ','h','e','a','l','t','h',' ','i','s',' ','r','e','s','t','o','r','e','d',0 ; Your health is restored
	StrPleaseLogIn dd 'P','l','e','a','s','e',' ','l','o','g',' ','i','n',' ','f','i','r','s','t','!',0 ; Please log in first!
	symbs dd 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9',0 ; abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
	StrBaseName dd 's','g','m','a','.','d','b',0 ; sgma.db
	StrSqlCreateDb dd 'C','R','E','A','T','E',' ','T','A','B','L','E',' ','u','s','e','r','s',' ','(','n','a','m','e',' ','V','A','R','C','H','A','R',',',' ','p','a','s','s','w','o','r','d',' ','V','A','R','C','H','A','R',',',' ','p','s','a','l','t',' ','V','A','R','C','H','A','R',',',' ','k','i','l','l','s',' ','I','N','T',',',' ','d','e','a','t','h','s',' ','I','N','T',',',' ','m','o','n','e','y',' ','I','N','T',',',' ','s','k','i','n',' ','I','N','T',',',' ','c','o','l','o','r',' ','I','N','T',')',0 ; CREATE TABLE users (name VARCHAR, password VARCHAR, psalt VARCHAR, kills INT, deaths INT, money INT, skin INT, color INT)
	FormatStrSqlCheckReg dd 'S','E','L','E','C','T',' ','p','s','a','l','t',' ','F','R','O','M',' ','u','s','e','r','s',' ','W','H','E','R','E',' ','n','a','m','e',' ','=',' ','''','%','s','''',' ','L','I','M','I','T',' ','1',0 ; SELECT psalt FROM users WHERE name = '%s' LIMIT 1
	FormatStrSqlRegister dd 'I','N','S','E','R','T',' ','I','N','T','O',' ','u','s','e','r','s',' ','(','n','a','m','e',',',' ','p','a','s','s','w','o','r','d',',',' ','p','s','a','l','t',',',' ','k','i','l','l','s',',',' ','d','e','a','t','h','s',',',' ','m','o','n','e','y',',',' ','s','k','i','n',',',' ','c','o','l','o','r',')',' ','V','A','L','U','E','S',' ','(','''','%','s','''',',',' ','''','%','s','''',',',' ','''','%','s','''',',',' ','0',',',' ','0',',',' ','0',',',' ','0',',',' ','-','1',')',0 ; INSERT INTO users (name, password, psalt, kills, deaths, money, skin, color) VALUES ('%s', '%s', '%s', 0, 0, 0, 0, -1)
	FormatStrSqlLogin dd 'S','E','L','E','C','T',' ','*',' ','F','R','O','M',' ','u','s','e','r','s',' ','W','H','E','R','E',' ','n','a','m','e',' ','=',' ','''','%','s','''',' ','A','N','D',' ','p','a','s','s','w','o','r','d',' ','=',' ','''','%','s','''',' ','L','I','M','I','T',' ','1',0 ; SELECT * FROM users WHERE name = '%s' AND password = '%s' LIMIT 1
	FormatStrSqlSavePlayer dd 'U','P','D','A','T','E',' ','u','s','e','r','s',' ','S','E','T',' ','k','i','l','l','s',' ','=',' ','%','d',',',' ','d','e','a','t','h','s',' ','=',' ','%','d',',',' ','m','o','n','e','y',' ','=',' ','%','d',',',' ','s','k','i','n',' ','=',' ','%','d',',',' ','c','o','l','o','r',' ','=',' ','%','d',' ','W','H','E','R','E',' ','n','a','m','e',' ','=',' ','''','%','s','''',0 ; UPDATE users SET kills = %d, deaths = %d, money = %d, skin = %d, color = %d WHERE name = '%s'
	