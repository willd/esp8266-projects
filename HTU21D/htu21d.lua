-- htu21d.lua - NodeMCU Library for HTU21D i2c temperature and humidity sensors
-- version 0.1, Hessel Schut, hessel@isquared.nl, 2015-01-03 (https://github.com/hessch/lm75lib/blob/master/lm75.lua)
-- version 0.2, Wilhelm Westermark, willd@kth.se, 2015-03-11 
-- Changes made for HTU21D



htu21d = {
	address = 64,
	temp_reg = 243,

	init = function (self, sda, scl)
		self.bus = 0
		i2c.setup(self.bus, sda, scl, i2c.SLOW)
	end,

	read = function (self)
		i2c.start(self.bus)
		i2c.address(self.bus, self.address, i2c.TRANSMITTER)
		i2c.write(self.bus, self.temp_reg)
		i2c.stop(self.bus)
		tmr.delay(50000)
		i2c.start(self.bus)
		i2c.address(self.bus, self.address  , i2c.RECEIVER)
		c=i2c.read(self.bus, 3)
		i2c.stop(self.bus)
		return c
	end,

	convert = function (self, msb, lsb, chksum)
		raw = bit.bor(bit.lshift(msb,8),lsb)
		raw = bit.band(raw,0xFFFC)
		temp = raw/65535
		real = -46.85+(172.72*temp)
		return real
	end,

	strTemp = function (self)
		local h, l, c 
		h, l, c = string.byte(self:read(), 1, 2, 3)
		
		--return string.format("%d",self:convert(h, l, c))
		return self:convert(h, l, c)
	end,

	intTemp = function (self)
		local h, l 
		h, l = string.byte(self:read(), 1, 2, 3)
		return tonumber(string.format("%d%d", self:convert(h, l)))
	end
}
