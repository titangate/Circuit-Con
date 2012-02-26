WIRE_SCALE = 15
function distancebetween(a,b)
	return ((a.x-b.x)^2+(a.y-b.y)^2)^0.5
end
Board = Object:subclass'Board'
function Board:initialize(w,h)
	self.w,self.h=w,h
	self.chip = {}
	self.map = {}
	for i=1,w do
		table.insert(self.map,{})
	end
end

function Board:attach(a,b)
	local fscore = {}
	local gscore = {}
	local openset = {a:getAvailablePort(),b:getAvailablePort()}
	while #openset>0 do
		n=heappop(openset)
		
	end
end

function Board:generateConnection()
	for i,v in ipairs(self.chip) do
		for k,b in ipairs(self.chip) do
			if v~=b then
				v:connect(b)
				b:connect(v)
			end
		end
	end
end

function Board:addChip(...)
	for i,v in ipairs(arg) do
		
		table.insert(self.chip,v)
	end
end

function Board:update(dt)
	for k,v in pairs(self.chip) do
		v:update(dt)
	end
end

function Board:draw()
	for k,v in pairs(self.chip) do
		v:draw()
	end
end

Chip = Object:subclass'Chip'
function Chip:initialize(x,y,w,h)
	self.x,self.y=x,y
	self.w,self.h = w,h
	self.connection = {}
end

function Chip:connect(b)
	local a = self
	local ax,ay = a.x,a.y
	ax  = ax + math.random(-5,5)
	ay  = ay + math.random(-5,5)
	local w = Wire(self,b)
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

function Chip:sendCurrent(target,speed,strength)
	assert(target)
	self.connection[target]:sendCurrent(speed,strength)
end


function Chip:update(dt)
	
	for chip,wire in pairs(self.connection) do
		wire:update(dt)
	end
end

function Chip:getStyle()
end

function Chip:setStyle(style)
end


function Chip:draw()
	
	for chip,wire in pairs(self.connection) do
		wire:draw()
	end
	love.graphics.rectangle('fill',self.x-self.w/2,self.y-self.h/2,self.w,self.h)
end

Wire = Object:subclass'Wire'
function Wire:initialize(a,b)
	self.a,self.b = a,b
	self.segment = {}
	self.current = {}
end

function Wire:sendCurrent(speed,strength)
	local c = Current(self,speed,strength)
	table.insert(self.current,c)
	
end

function Wire:update(dt)
	
	for i,v in ipairs(self.current) do
		v:update(dt)
	end
end

function Wire:draw()
	for i = 2,#self.segment do
		local v1,v2 = self.segment[i-1],self.segment[i]
		love.graphics.line(v1.x,v1.y,v2.x,v2.y)
	end
	for i,v in ipairs(self.current) do
		v:draw()
	end
end

function Wire:terminate(current)
	for i=1,#self.current do
		if self.current[i]==current then
			table.remove(self.current,i)
			return
		end
	end
end


Current = Object:subclass'Current'
function Current:initialize(wire,speed,strength)
	self.w = wire
	self.origin = wire.a
	self.path = wire.segment
	self.targetindex = 1
	self.time = distancebetween(self.path[1],self.origin)/speed
	self.speed = speed
	self.dt = 0
	self.x,self.y = self.origin.x,self.origin.y
	self.strength = strength
	self.source = wire.a.owner
end

function Current:finish()
	self.w:terminate(self)
	self:strength(self.w.a,self.w.b)
end

function Current:update(dt)
	self.dt = self.dt + dt
	if self.dt > self.time then
		self.origin = self.path[self.targetindex]
		self.targetindex = self.targetindex + 1
		if self.targetindex>#self.path then
			self:finish()
			return
		end
		self.time = distancebetween(self.path[self.targetindex],self.origin)/self.speed
		self.dt = 0
	end
	local pc = self.dt/self.time
	self.x,self.y = self.origin.x+pc*(self.path[self.targetindex].x-self.origin.x),self.origin.y+pc*(self.path[self.targetindex].y-self.origin.y)

end

currentstrength = {
	simple = function(strength)
		--local owner = current.source.a.owner
		return function(current,start,finish)
			local owner = current.source
			if finish.force > strength then
				finish.force = finish.force - strength
			elseif finish.force == strength then
				finish.force = 0
				finish.owner = 'neutral'
			else
				finish.force = strength - finish.force
				finish.owner = owner
			end
			print (finish.owner,'new owner')
			finish:setStyle()
		end
	end
}