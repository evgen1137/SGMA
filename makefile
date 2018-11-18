FASM=~/Рабочий\ стол/fasm/fasm
COMPILE_FLAGS=-d target_system=linux
OUTFILE=./bin/sgma.so

all:
	$(FASM) ./src/main.asm ./tmp/main.o $(COMPILE_FLAGS)
	$(FASM) ./src/gamemode/gamemode.asm ./tmp/gamemode.o $(COMPILE_FLAGS)
	ld -melf_i386 -shared -o $(OUTFILE) ./tmp/*.o
	rm ./tmp/*.o