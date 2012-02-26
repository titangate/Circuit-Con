
local dot = love.graphics.newImage'dot.png'
elc = {
	highlightObject = 'cursor',
	highlightRange = 100,
}
function elc:setHighLight(object,range)
	self.highlightObject = object
	self.highlightRange = range
end
elc.Board = class('elc Board',Board)
function elc.Board:initialize(...)
	super.initialize(self,...)
	self.p = love.graphics.newParticleSystem(dot,128)
	self.p:setParticleLife(1)
	self.p:setLifetime(3600)
	self.p:setSize(0.5,0.25)
	self.p:setColor(255,255,255,255,255,255,255,0)
	self.p:setEmissionRate(64)
	self.p:start()
	self.r = 0
end
function elc.Board:update(dt)
	super.update(self,dt)
	if elc.highlightObject then
		local x,y
		if elc.highlightObject=='cursor' then
			x,y = love.mouse.getPosition()
		else
			x,y = elc.highlightObject.x*10,elc.highlightObject.y*10
		end
		self.r = (self.r+dt*3 % (math.pi*2))
		local hx,hy = x+math.cos(self.r)*elc.highlightRange,y+math.sin(self.r)*elc.highlightRange
		self.p:setPosition(hx,hy)
		self.p:update(dt)
--		print (hx,hy)
	end
end
function elc.Board:draw()
	love.graphics.push()
	love.graphics.scale(10)
	super.draw(self)
	love.graphics.pop()
--	if self.highlightObject then
	love.graphics.draw(self.p)
--	end
end

elc.Chip = class('elc Chip',Chip)
function elc.Chip:initialize(...)
	super.initialize(self,...)
	self.owner = 'neutral'
	self.style = elc.style.neutral
end


function elc.Chip:connect(b)
	local a = self
	local ax,ay = a.x,a.y
	ax  = ax + math.random(-5,5)
	ay  = ay + math.random(-5,5)
	local w = elc.Wire(self,b)
	local dx = b.x-ax
	local dy = b.y-ay
	table.insert(w.segment,{x=ax,y=ay})
	local sx,sy = ax,ay
	while true do
		if dx==0 or dy==0 then
			table.insert(w.segment,b)
			self.connection[b] = w
			break
		end
		
		if dx > 0 then
			dx = dx - 1
			sx = sx + 1
		else
			dx = dx + 1
			sx = sx - 1
		end
		
		if dy > 0 then
			dy = dy - 1
			sy = sy + 1
		else
			dy = dy + 1
			sy = sy - 1
		end
		local c = {x=sx,y=sy}
		table.insert(w.segment,c)
	end
end

function elc.Chip:setStyle()
	assert(elc.style[self.owner],self.owner.." does not apply to a style.")
	self.style = elc.style[self.owner]
end

function elc.Chip:highLight(state)
	self.highlight = state
	if state == true then
		elc:setHighLight(self,math.max(self.w,self.h)*10)
	else
		elc:setHighLight('cursor',100)
	end
end

function elc.Chip:draw()
	for chip,wire in pairs(self.connection) do
		wire:draw()
	end
	elc.drawchip(self.x,self.y,self.w,self.h)
	--love.graphics.rectangle('fill',self.x-self.w/2,self.y-self.h/2,self.w,self.h)
end

elc.Current = class('elc Current',Current)
function elc.Current:initialize(...)
	super.initialize(self,...)
	self.p = love.graphics.newParticleSystem(dot,32)
	self.p:setParticleLife(1)
	self.p:setLifetime(3600)
	self.p:setSize(0.03,0.01)
	self.p:setColor(255,255,255,255,255,255,255,0)
	self.p:setEmissionRate(32)
	self.p:start()
end

function elc.Current:setColor(r,g,b)
	self.p:setColor(r,g,b,255,r,g,b,0)
end

function elc.Current:update(dt)
	super.update(self,dt)
	self.p:setPosition(self.x,self.y)
	self.p:update(dt)
end

function elc.Current:draw()
	love.graphics.draw(self.p)
end

elc.Wire = class('elc Wire',Wire)

function elc.Wire:draw()
	for i = 2,#self.segment do
		local v1,v2 = self.segment[i-1],self.segment[i]
		love.graphics.setColor(self.a.style.linebg)
		love.graphics.setLineWidth(5)
		love.graphics.line(v1.x,v1.y,v2.x,v2.y)
		love.graphics.setColor(self.a.style.color)
		love.graphics.setLineWidth(1)
		love.graphics.line(v1.x,v1.y,v2.x,v2.y)
	end
	for i,v in ipairs(self.current) do
		v:draw()
	end
end


function elc.Wire:sendCurrent(speed,strength)
	local c = elc.Current(self,speed,strength)
	c:setColor(unpack(self.a.style.color))
	table.insert(self.current,c)
	
end