goo.chip = class('goo chip', goo.button)
function goo.chip:initialize(...)
	super.initialize(self,...)
end
function goo.chip:setChip(c)
	self.c = c
	self:setPos((c.x-c.w/2)*10,(c.y-c.h/2)*10)
	self:setSize(c.w*10,c.h*10)
end
function goo.chip:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.print(string.format("%d",self.c.force),0,0)
--	love.graphics.circle('fill',self.x,self.y,10)
	--print (tostring(self.c.force),self.x,self.y)
end

return goo.chip