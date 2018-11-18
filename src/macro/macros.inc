; taken from fasm includes
include 'struct.inc'
include 'proc32.inc'
match =windows, target_system
{
	include 'import32.inc'
	include 'export.inc'
}

macro ncall proc,[arg]
{
	common
		size@ncall = 0
		if ~ arg eq
		reverse
			pushd arg
			size@ncall = size@ncall + 4
		common
		end if
		pushd size@ncall
		pushd esp
		pushd famx
		mov eax, proc
		call eax
		add esp,size@ncall + 12
}
; fuck fasm
match =windows, target_system { include 'samp_windows.inc' }
match =linux, target_system { include 'samp_linux.inc' }

macro endc { endp }

macro codeseg
{
	match =windows, target_system \{ section '.text' code readable executable \}
	match =linux, target_system \{ section '.text' executable \}
}

macro dataseg
{
	match =windows, target_system \{ section '.data' data readable writeable \}
	match =linux, target_system \{ section '.data' writeable \}
}

macro declare_format
{
	match =windows, target_system \{ format MS COFF \}
	match =linux, target_system \{ format ELF \}
}