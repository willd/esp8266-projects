--init.lua
print("Setting wifi configuration")
wifi.setmode(wifi.STATION)
wifi.sta.config("SW","4815162342")
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function()
    if wifi.sta.getip()== nil then
        print("IP unavaliable, Waiting...")
    else
        tmr.stop(1)
        print("Config done, IP is "..wifi.sta.getip())
	dofile("main.lua")
    end
 end)


