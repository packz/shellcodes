#!/usr/bin/python2
import re

print("shellcode_1 = \\")
for lin in re.findall(".?"*65, input()):
  if "\\\\x80\\\\xff\\\\xff\\\\xfe" in lin:
    tmp = lin.split("\\\\x80\\\\xff\\\\xff\\\\xfe")[0]
    tmp2 = lin.split("\\\\x80\\\\xff\\\\xff\\\\xfe")[1]
    print("\"" + tmp + "\"\n")
    print("shellcode_2 =\\")
    print("\"" + tmp2 + "\"\\")

  elif "\\\\xfb\\\\x2d" in lin:
    tmp = lin.split("\\\\xfb\\\\x2d")[0]
    tmp2 = lin.split("\\\\xfb\\\\x2d")[1]
    print("\"" + tmp + "\"\n")
    print("shellcode_3 =\\")
    print("\"" + tmp2 + "\"\\")

  elif lin == "":
    continue

  else:
    print("\"" + lin + "\" \\")

