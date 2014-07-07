--[[
LuCI - Lua Configuration Interface

Copyright 2014 Nikos Mavrogiannopoulos <nmav@gnutls.org>
Copyright 2014 Matthew Sykes <matthew.sykes@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--

local map, section, net = ...

local server, port, username, password, cert, key, ca, ta
local ovpn_cert_file, ovpn_key_file, ovpn_ca_file, ovpn_ta_file

-- local ifc = net:get_interface():name()
local ifc = arg[1]

ovpn_cert_file = "/etc/openvpn/" .. ifc .. ".pem"
ovpn_key_file = "/etc/openvpn/" .. ifc .. ".key"
ovpn_ca_file = "/etc/openvpn/" .. ifc .. "-ca.pem"
ovpn_ta_file = "/etc/openvpn/" .. ifc .. "-ta.key"

server = section:taboption("general", Value, "server", translate("VPN server host"))
server.datatype = "host"

port = section:taboption("general", Value, "port", translate("VPN server port"))
port.placeholder = "1194"
port.datatype    = "port"

username = section:taboption("general", Value, "username", translate("Username"))
password = section:taboption("general", Value, "password", translate("Password"))
password.password = true


cert = section:taboption("advanced", Value, "usercert", translate("User certificate (PEM encoded)"))
cert.template = "cbi/tvalue"
cert.rows = 10

function cert.cfgvalue(self, section)
	return nixio.fs.readfile(ovpn_cert_file)
end

function cert.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile(ovpn_cert_file, value)
end


key = section:taboption("advanced", Value, "userkey", translate("User key (PEM encoded)"))
key.template = "cbi/tvalue"
key.rows = 10

function key.cfgvalue(self, section)
	return nixio.fs.readfile(ovpn_key_file)
end

function key.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile(ovpn_key_file, value)
end


ca = section:taboption("advanced", Value, "ca", translate("CA certificate (PEM encoded)"))
ca.template = "cbi/tvalue"
ca.rows = 10

function ca.cfgvalue(self, section)
	return nixio.fs.readfile(ovpn_ca_file)
end

function ca.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile(ovpn_ca_file, value)
end


ta = section:taboption("advanced", Value, "ta", translate("TLS-auth key"))
ta.template = "cbi/tvalue"
ta.rows = 10

function ta.cfgvalue(self, section)
	return nixio.fs.readfile(ovpn_ta_file)
end

function ta.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile(ovpn_ta_file, value)
end
