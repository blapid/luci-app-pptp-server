
--require("luci.tools.webadmin")

mp = Map("pptpd", "PPTP Server","")

s = mp:section(NamedSection, "pptpd", "service", "PPTP Service")
s.anonymouse = true
--s.addremove = true

s:option(Flag, "enabled", translate("Enable"))

localip = s:option(Value, "localip", translate("Local IP"))
localip.datatype = "ip4addr"

remoteip = s:option(Value, "remoteip", translate("Remote IP"))
remoteip.datatype = "string"


logins = mp:section(TypedSection, "login", "PPTP Logins")
logins.addremove = true
logins.anonymouse = true

username = logins:option(Value, "username", translate("User name"))
username.datatype = "string"

password = logins:option(Value, "password", translate("Password"))
password.datatype = "string"

function mp.on_save(self)
    require "luci.model.uci"
    require "luci.sys"

	local have_pptp_rule = false
	local have_gre_rule = false

    luci.model.uci.cursor():foreach('firewall', 'rule',
        function (section)
			if section._name == 'pptp' then
				have_pptp_rule = true
			end
			if section._name == 'gre' then
				have_gre_rule = true
			end
        end
    )

	if not have_pptp_rule then
		local cursor = luci.model.uci.cursor()
		local pptp_rule_name = cursor:add('firewall','rule')
		cursor:tset('firewall', pptp_rule_name, {
			['_name'] = 'pptp',
			['target'] = 'ACCEPT',
			['src'] = 'wan',
			['proto'] = 'tcp',
			['dest_port'] = 1723
		})
		cursor:save('firewall')
		cursor:commit('firewall')
	end
	if not have_gre_rule then
		local cursor = luci.model.uci.cursor()
		local gre_rule_name = cursor:add('firewall','rule')
		cursor:tset('firewall', gre_rule_name, {
			['_name'] = 'gre',
			['target'] = 'ACCEPT',
			['src'] = 'wan',
			['dest_port'] = 47
		})
		cursor:save('firewall')
		cursor:commit('firewall')
	end
		
end


local pid = luci.util.exec("/usr/bin/pgrep pptpd")

function pptpd_process_status()
  local status = "PPTPD is not running now and "

  if pid ~= "" then
      status = "PPTPD is running with the PID " .. pid .. "and "
  end

  if nixio.fs.access("/etc/rc.d/S60pptpd") then
    status = status .. "it's enabled on the startup"
  else
    status = status .. "it's disabled on the startup"
  end

  local status = { status=status }
  local table = { pid=status }
  return table
end

t = mp:section(Table, pptpd_process_status())
t.anonymous = true

t:option(DummyValue, "status", translate("PPTPD status"))

if pid == "" then
  start = t:option(Button, "_start", translate("Start"))
  start.inputstyle = "apply"
  function start.write(self, section)
        message = luci.util.exec("/etc/init.d/pptpd start 2>&1")
        luci.util.exec("sleep 4")
        luci.http.redirect(
                luci.dispatcher.build_url("admin", "services", "pptp-server") .. "?message=" .. message
        )
  end
else
  stop = t:option(Button, "_stop", translate("Stop"))
  stop.inputstyle = "reset"
  function stop.write(self, section)
        luci.util.exec("/etc/init.d/pptpd stop")
        luci.util.exec("sleep 4")
        luci.http.redirect(
                luci.dispatcher.build_url("admin", "services", "pptp-server")
        )
  end
end

if nixio.fs.access("/etc/rc.d/S60pptpd") then
  disable = t:option(Button, "_disable", translate("Disable from startup"))
  disable.inputstyle = "remove"
  function disable.write(self, section)
        luci.util.exec("/etc/init.d/pptpd disable")
        luci.util.exec("sleep 1")
        luci.http.redirect(
                luci.dispatcher.build_url("admin", "services", "pptp-server")
        )
  end
else
  enable = t:option(Button, "_enable", translate("Enable on startup"))
  enable.inputstyle = "apply"
  function enable.write(self, section)
        luci.util.exec("/etc/init.d/pptpd enable")
        luci.util.exec("sleep 1")
        luci.http.redirect(
                luci.dispatcher.build_url("admin", "services", "pptp-server")
        )
  end
end

return mp
