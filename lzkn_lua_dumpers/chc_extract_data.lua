--lua script for dumping lzkn archives into folders "dumps_dir_lzkn1" ans "dumps_dir_lzkn2"
--author: lab313

require "binio"

local daddr, caddr, time, cnt, typ, logpath, dumpspath
  time = 0
  cnt = 1

memory.registerexec(0x6532, function()
  daddr = memory.getregister("a6")
  caddr = memory.getregister("a5") - 2
  typ = "LZKN1"
  logpath = "dumps_dir_" .. typ .. "\\data_" .. typ .. ".log"
  dumpspath = "dumps_dir_" .. typ .. "\\dump_%06X.bin"
end)

memory.registerexec(0x649E, function()
  daddr = memory.getregister("a6")
  caddr = memory.getregister("a5") - 2
  typ = "LZKN2"
  logpath = "dumps_dir_" .. typ .. "\\data_" .. typ .. ".log"
  dumpspath = "dumps_dir_" .. typ .. "\\dump_%06X.bin"
end)

memory.registerexec(0x6598, function()
local dsize, w, csize

  dsize = memory.getregister("a6") - daddr
  csize = memory.getregister("a5") - caddr

  BinIO.Open(string.format(dumpspath, caddr), "wb")
  w = memory.readbyterange(daddr, dsize)

  BinIO.Write(w, dsize)
  BinIO.Close()

  log = io.open (logpath, "a");
  local pr = string.format("%06X (%05d) / %05X (%05d)\n", caddr,csize,daddr,dsize)
  
  log:write(pr)
  log:close()
  print(pr)
  
  if os.clock() - time > 3 then
    cnt = cnt + 1
    log = io.open (logpath, "a");
    log:write(string.format("\n(%03d)----\n", cnt))
    print("----")
  end  
  
  time = os.clock()
end)

memory.registerexec(0x652A, function()
local dsize, w

  dsize = memory.getregister("a6") - daddr
  csize = memory.getregister("a5") - caddr

  BinIO.Open(string.format(dumpspath, caddr), "wb")
  w = memory.readbyterange(daddr, dsize)

  BinIO.Write(w, dsize)
  BinIO.Close()

  log = io.open (logpath, "a");
  local pr = string.format("%06X (%05d) / %05X (%05d)\n", caddr,csize,daddr,dsize)
  
  log:write(pr)
  log:close()
  print(pr)
  
  if os.clock() - time > 3 then
    cnt = cnt + 1
    log = io.open (logpath, "a");
    log:write(string.format("\n(%03d)----\n", cnt))
    print("----")
  end  
  
  time = os.clock()
end)