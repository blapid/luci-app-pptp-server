
module("luci.controller.pptp-server", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pptpd") then
		return
	end
	
	local page

	entry({"admin", "services", "pptp-server"}, cbi("pptp-server/pptp-server"), _("PPTP Server"), 80).dependent=false
end
