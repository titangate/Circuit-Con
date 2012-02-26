
require 'MiddleClass'
goo=require 'goo.goo'
require 'circuitcon.board'
require 'circuitcon.elc'
require 'circuitcon.style'

function generateBoard()
	local chips = {}
	b = elc.Board(80,60)
	local placementgrid = {}
	for i=1,4 do
		table.insert(placementgrid,{})
	end
	placementgrid[-1] = {[-1]=true}

	for i=1,10 do
		local x,y = -1,-1
		while placementgrid[x][y]==true do
			x = math.random(1,4)
			y = math.random(1,3)
		end
		local w,h = math.random(5,10),math.random(5,10)
		placementgrid[x][y] = true
		local c = elc.Chip(x*20-15+math.random(10),y*20-15+math.random(10),w,h)
		table.insert(chips,c)
		b:addChip(c)
		c.force = math.random(300)
		local cb = goo.chip()
		cb:setChip(c)
		cb.onClick = function(object,button)
			print (button)
			if button == 'l' then
				object.c:highLight(not object.c.highlight)
			elseif button == 'r' then
				
				
			end
		end
	end

	b:generateConnection()
end

local bg = love.graphics.newImage'circuitboard.png'
bg:setWrap('repeat','repeat')
local q = love.graphics.newQuad(0,0,4000,4000,256,256)
function love.load()
	goo:load()
	generateBoard()
end
function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.drawq(bg,q,0,0)
--	love.graphics.setColor(0,255,0)
	
	b:draw()
	goo:draw()
end

function love.update(dt)
	b:update(dt)
	goo:update(dt)
end

function love.keypressed(k,unicode)
	goo:keypressed(k,unicode)
end

function love.keyreleased(k,unicode)
	goo:keyreleased(k,unicode)
end

function love.mousepressed(x,y,k)
	goo:mousepressed(x,y,k)
end

function love.mousereleased(x,y,k)
	goo:mousereleased(x,y,k)
end