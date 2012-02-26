elc.style = {
	scale = 0.03,
}
elc.style.player = {
	color = {0,255,0},
	linebg = {0,255,0,100},
}

elc.style.enemy = {
	color = {255,0,0},
	linebg = {255,0,0,100},
}

elc.style.neutral = {
	color = {125,125,125},
	linebg = {125,125,125,100},
}
local chip = love.graphics.newImage'chip.png'
local rw,rh = chip:getWidth(),chip:getHeight()
local pw,ph = rw/3,rh/3
local tl = love.graphics.newQuad(0,0,pw,ph,rw,rh)
local tr = love.graphics.newQuad(pw*2,0,pw,ph,rw,rh)
local bl = love.graphics.newQuad(0,pw*2,pw,ph,rw,rh)
local br = love.graphics.newQuad(pw*2,ph*2,pw,ph,rw,rh)
local l = love.graphics.newQuad(0,ph,pw,ph,rw,rh)
local r = love.graphics.newQuad(pw*2,ph,pw,ph,rw,rh)
local t = love.graphics.newQuad(pw,0,pw,ph,rw,rh)
local b = love.graphics.newQuad(pw,ph*2,pw,ph,rw,rh)
local center = love.graphics.newQuad(pw,ph,pw,ph,rw,rh)
function elc.drawchip(x,y,w,h)
	local scale = elc.style.scale
	x = x-w/2
	y = y-h/2
	-- top left
	love.graphics.drawq(chip,tl,x,y,0,scale,scale,pw/2,ph/2)
	-- top right
	love.graphics.drawq(chip,tr,x+w,y,0,scale,scale,pw/2,ph/2)
	-- bot left
	love.graphics.drawq(chip,bl,x,y+h,0,scale,scale,pw/2,ph/2)
	-- bot right
	love.graphics.drawq(chip,br,x+w,y+h,0,scale,scale,pw/2,ph/2)
	for i=y+1,y+h-1 do
		-- left
		love.graphics.drawq(chip,l,x,i,0,scale,scale,pw/2,ph/2)
		-- right
		love.graphics.drawq(chip,r,x+w,i,0,scale,scale,pw/2,ph/2)
	end
	for i=x+1,x+w-1 do
		-- top
		love.graphics.drawq(chip,t,i,y,0,scale,scale,pw/2,ph/2)
		-- bot
		love.graphics.drawq(chip,b,i,y+h,0,scale,scale,pw/2,ph/2)
	end
	for j=y+1,y+h-1 do
		for i=x+1,x+w-1 do
			love.graphics.drawq(chip,center,i,j,0,scale,scale,pw/2,ph/2)
		end
	end
end