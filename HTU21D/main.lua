--main.lua
print("Hello HTU21D")
require('htu21d')
sda, scl = 6, 7 
htu21d:init(sda, scl) 
var, temp = 0, 0
srv=net.createServer(net.TCP,15)
srv:listen(8080, function(c)
   c:on("receive", function(b, pl) 
	var=htu21d:strTemp()

	if (string.find(pl,"sleep")) then
		print(pl)
		node.dsleep(5000000); 
	else
		c:send(string.format("%.2f", var))
	end			
	end)
end)
