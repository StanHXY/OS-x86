nasm -f bin -o boot.bin boot.asm
# write binary file into boot image
dd if=boot.bin of=boot.img bs=512 count=1 conv=notrunc