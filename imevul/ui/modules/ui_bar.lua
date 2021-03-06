local args = { ... }
local ui = args[1]
assert(ui, 'Imevul UI library not found')
local gfx = ui.lib.cobalt.graphics

---@class Bar : Object Basic "progress bar" style meter
---@field public value number
---@field public minValue number
---@field public maxValue number
---@field public color string
---@field public gradient number Keep at 0 for no gradient, 1 for red->green, and -1 for green->red
---@field public reverse boolean True to reverse fill direction
---@field public direction number
local Bar = ui.lib.class(ui.modules.Object, function(this, data)
	ui.modules.Object.init(this, data)

	data = data or {}
	data.value = data.value or 0
	data.minValue = 0
	data.maxValue = data.maxValue or 100
	data.color = data.color or nil
	data.gradient = data.gradient or 0
	assert(data.maxValue >= data.minValue, 'maxValue (' .. data.maxValue .. ') must be >= minValue (' .. data.minValue .. ')')
	data.reverse = data.reverse or false

	this.value = data.value
	this.minValue = data.minValue
	this.maxValue = data.maxValue
	this:setMaxValue(this.maxValue)

	this.color = data.color
	this.gradient = data.gradient
	this.direction = data.direction or ui.modules.Direction.HORIZONTAL
	this.reverse = data.reverse
	this.type = 'Bar'
end)

---@see Object#_draw
function Bar:_draw()
	local fillPercent = math.min(1.0, math.max(0.0, self.value * 1.0 / self.maxValue))

	gfx.setBackgroundColor(self.background or self.config.theme.blurredBackground or colors.lightGray)
	gfx.clear()

	local color = self.color or self.config.theme.primary
	if self.gradient > 0 then
		if fillPercent < 0.3 then
			color = colors.red
		elseif fillPercent < 0.5 then
			color = colors.orange
		elseif fillPercent < 0.8 then
			color = colors.yellow
		else
			color = colors.lime
		end
	elseif self.gradient < 0 then
		if fillPercent > 0.7 then
			color = colors.red
		elseif fillPercent > 0.5 then
			color = colors.orange
		elseif fillPercent > 0.3 then
			color = colors.yellow
		else
			color = colors.lime
		end
	end

	gfx.setColor(color)

	if self.direction == ui.modules.Direction.HORIZONTAL then
		if self.reverse then
			gfx.rect('fill', self.width - math.floor(self.width * fillPercent), 0, math.floor(self.width * fillPercent), self.height)
		else
			gfx.rect('fill', 0, 0, math.floor(self.width * fillPercent), self.height)
		end
	else
		if self.reverse then
			gfx.rect('fill', 0, self.height - math.floor(self.height * fillPercent), self.width, math.floor(self.height * fillPercent))
		else
			gfx.rect('fill', 0, 0, self.width, math.floor(self.height * fillPercent))
		end
	end

	gfx.setBackgroundColor(self.config.theme.background or colors.black)
end

---Set the value of the Bar
---@public
---@param value number The new value. It will be clamped to [minValue, maxValue]
---@param noEvent boolean True to not trigger an onChange event
function Bar:setValue(value, noEvent)
	self.value = math.min(self.maxValue, math.max(self.minValue, value))

	if self.callbacks.onChange and not noEvent then
		self.callbacks.onChange(self, self.value)
	end
end

---Set the maxValue of the Bar
---@public
---@param maxValue number The new maxValue. Also clamps the current Bar value between the new [minValue, maxValue]
function Bar:setMaxValue(maxValue)
	self.maxValue = math.max(self.minValue, maxValue)
	self:setValue(self.value)
end

return Bar
