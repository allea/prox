class = require("prox.middleclass.middleclass")
require("prox.slam.slam")

local gamestate = require("prox.hump.gamestate")
local window = require("prox.window")
local keyboard = require("prox.input.keyboard")
local mouse = require("prox.input.mouse")
local joystick = require("prox.input.joystick")

local prox = {
	load = function() end,
	quit = function() end,

	-- core modules

	gamestate = require("prox.hump.gamestate"),
	joystick = require("prox.input.joystick"),
	keyboard = require("prox.input.keyboard"),
	mouse = require("prox.input.mouse"),
	resources = require("prox.resources"),
	window = require("prox.window"),
	timer = require("prox.hump.timer"),

	-- Base classes
	Entity = require("prox.Entity"),
	Scene = require("prox.Scene"),

	-- Renderers
	Animation = require("prox.renderer.Animation"),
	Animator = require("prox.renderer.Animator"),
	Sprite = require("prox.renderer.Sprite"),

	-- Colliders
	BoxCollider = require("prox.collider.BoxCollider"),

	-- Input
	KeyboardBinding = require("prox.input.KeyboardBinding"),
	MouseBinding = require("prox.input.MouseBinding"),
	JoystickBinding = require("prox.input.JoystickBinding")
}

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	prox.load()
end

function love.update(dt)
	gamestate.current():update(dt)
end

function love.draw()
	gamestate.current():draw()
end

function love.gui()
	gamestate.current():gui()
end

function love.quit()
	return prox.quit()
end

function love.run()
	if love.math then
		love.math.setRandomSeed(os.time())
	end
 
	love.load(arg)
 
	-- We don't want the first frame's dt to include time taken by love.load.
	love.timer.step()
 
	local dt = 0

	window.apply()
 
	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		-- Update dt, as we'll be passing it to update
		love.timer.step()
		dt = love.timer.getDelta()
 
		-- Call update and draw
		love.update(dt)

		keyboard.clear()
		mouse.clear()
		joystick.clear()
 
		if love.graphics.isActive() then
			love.graphics.origin()

			love.graphics.clear()
			love.graphics.setCanvas(window.getCanvas())
			love.graphics.clear(gamestate.current():getBackgroundColor())

			love.draw()
			love.gui()

			love.graphics.setCanvas()
			love.graphics.push()
			love.graphics.scale(window.getScale())
			love.graphics.draw(canvas, 0, 0)
			love.graphics.pop()

			love.graphics.present()
		end
 
		love.timer.sleep(0.001)
	end
end

function love.keypressed(k) keyboard.keypressed(k) end
function love.keyreleased(k) keyboard.keyreleased(k) end
function love.mousepressed(x, y, k) mouse.keypressed(k) end
function love.mousereleased(x, y, k) mouse.keyreleased(k) end
function love.gamepadpressed(joy, k) joystick.keypressed(joy, k) end
function love.gamepadreleased(joy, k) joystick.keyreleased(joy, k) end

return prox
