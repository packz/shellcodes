#!/usr/bin/python2
import os
import re
import argparse

def detect_file_type(path):
  file_type = os.popen("file %s" % path).read(200)
  if "assembler" in file_type:
    return 0
  elif "ELF" in file_type:
    return 1
  else:
    print "Incompatible file type, quitting."
    exit()

def extract(path):
  if not detect_file_type(path):
    orig_path = path
    path = path.split(".")[0] 
    if os.system("as -o %s.o %s" % (path, orig_path)) == 1:
      print " [!] Assembly failed."
      exit()
    if os.system("ld -o %s %s.o" % (path, path)) == 1:
      print " [!] Linking failed."
      exit()

  shellcode = ""
  for line in os.popen("objdump -d %s" % path).readlines():
    for byte in line.split():
      if re.match("^[a-f0-9][a-f0-9]$", byte):
        shellcode += chr(int(byte, 16))

  return shellcode

if __name__=="__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument('--file', required=True)
  parser.add_argument('--hex', action='store_true', help="Output in hex format (\\x0f\\x05)")
  parser.add_argument('--raw', action='store_true', help="Output in raw format")
  parser.add_argument('--var', action='store_true', help="Output as a variable")
  parser.add_argument('--len', action='store_true', help="Output the length")
  args = parser.parse_args()

  shellcode = extract(args.file)

  if args.hex or args.var:
    tmp = ''.join(["\\x%.2x" % ord(byte) for byte in shellcode])

    if args.var:
      tmp2 = "char shellcode[] = {\n"
      for line in re.findall(".?"*64, tmp):
        if line != "":
          tmp2 += "  \"%s\" \n" % line
      tmp = tmp2 + "};"

    print tmp

  elif args.raw:
    print shellcode

  else:
    parser.print_help()
    exit()

  if args.len:
    print " [*] Length: %d bytes" % len(shellcode)

