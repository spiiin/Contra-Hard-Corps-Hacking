#script open all lzkn archives in Contra Hard Corps ROM and calculate their sizes
#it uses lzkn1.dll lib https://github.com/spiiin/lzkn to calculate sizes or archives and file lzkn1_list.txt to read addresses of all arrays.
#(addresses was collected with lua-script, that dumps addressess while decompressing data in emulator)

from ctypes import *

ROM_NAME = "Contra - Hard Corps (U) [!].gen"
TXT_NAME = "lzkn1_list.txt"

CHUNK_SIZE = 8192
MAX_OUT_SIZE = 10**6

lzkn1 = cdll.LoadLibrary("lzkn1.dll")

with open(ROM_NAME, "rb") as f:
    data = f.read()
data = map(ord, data)

with open(TXT_NAME, "rt") as f:
    lines = f.readlines()
lines = list(x.strip() for x in lines)

for line in lines:
    curAddres = int(line, 16)
    chunkData = data[curAddres:curAddres+CHUNK_SIZE]
    compressedSize = c_int()
    c_data = (c_ubyte * len(chunkData)) (*chunkData)
    c_data_p = POINTER(c_ubyte) (c_data)
    c_uncompressedData = create_string_buffer(MAX_OUT_SIZE)
    decompressedSize = lzkn1.decompress(c_data_p, byref(c_uncompressedData), byref(compressedSize))
    print "Lzkn address: ", hex(curAddres),
    print " Decompressed size: ", decompressedSize,
    print " Compressed size: ", compressedSize.value

