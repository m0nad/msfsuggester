# Msfsuggester is a tool that parse OpenVAS XML output and suggest an exploit
# form metasploit with a msfcli command line.
# 
require 'nokogiri'

# parse
def parse_openvas_xml(dir)
	f = File.open dir
	xml_doc = Nokogiri::XML(f)
	vulns = []
	xml_doc.css("results").children.each do |result|
		vuln = {}
		vuln[:host] = result.css("host").text
		vuln[:port] = result.css("port").text
		vuln[:port].gsub! '/tcp', ''
		vuln[:port].gsub! '/udp', ''
		cve = result.css("cve").text
		if (cve !~ /NOCVE/)
			cve.gsub! 'CVE-', ''
			vuln[:cve] = cve
		end
		bid = result.css("bid").text
		if (bid !~ /NOBID/) 
			vuln[:bid] = bid
		end
		vulns.push vuln
	end
	f.close
	vulns
end
@msf_exploits = []
def search_msf_dir(dir)
	files = Dir[dir]
	files.each do |file|
		exploit = {}
		if File.directory?(file)
			search_msf_dir file + "/*"
		end
		next unless File.file? file
		f = File.open(file).read
		exploit[:path] = $1 if (file =~ /modules\/(.*?)\.rb/)
		f.each_line do |line|
			if (line =~ /Rank\s*=\s*(\w+)/)
				exploit[:rank] = $1
			end
			if (line =~ /'Name'\s*=>\s*'(.*?)'/)
				exploit[:name] = $1
			end
			if (line =~ /'CVE'\s*,\s*'(\d{4}-\d{4})'/)
				exploit[:cve] = $1
			end
			if (line =~ /'BID'\s*,\s*'(\d+)'/)
				exploit[:bid] = $1
			end
		end
		@msf_exploits.push exploit
	end
	#@msf_exploits
end

def output(vulns, msf)
	rhost = ""
	msf[:rank] = "Unknown" if msf[:rank].nil?
	print "== (#{msf[:rank]}) #{msf[:name]} ==\n"
	if (msf[:path] =~ /exploits/)
		msf[:path].gsub! 'exploits', 'exploit'
		rhost = "RHOST"
	elsif (msf[:path] =~ /scanner/)
		rhost = "RHOSTS"
	end
	print "msfconsole -x \"use #{msf[:path]}; "
	print "set " + rhost + " " + "#{vulns[:host]}; " if vulns[:host]
	print "set RPORT #{vulns[:port]}; run\"\n" if vulns[:port]
	print "Refereces:"
	print " CVE:#{msf[:cve]}" if msf[:cve]
	print " BID:#{msf[:bid]}" if msf[:bid]
	print "\n\n"
end


openvas_xml = ARGV[0]
msf_dir = ARGV[1]
if (openvas_xml.nil? or msf_dir.nil?)
	print "Usage: ruby #{$0} openvas.xml /path/to/metasploit-framework/\n"
	print "Ex: ruby #{$0} OPENVAS.xml /home/user/metasploit-framework/\n"
	exit
end
msf_dir += "/modules/*"
vulns_openvas = parse_openvas_xml openvas_xml

search_msf_dir msf_dir


@msf_exploits.each do |vuln_msf|
	vulns_openvas.each do |vuln_openvas|
		if (not (vuln_openvas[:cve].nil? or vuln_msf[:cve].nil?) and vuln_openvas[:cve] =~ /#{vuln_msf[:cve]}/)
			output vuln_openvas, vuln_msf
		elsif (not(vuln_openvas[:bid].nil? or vuln_msf[:bid].nil?) and vuln_openvas[:bid] =~ /#{vuln_msf[:bid]}/)
			output vuln_openvas, vuln_msf
		end
	end
end


