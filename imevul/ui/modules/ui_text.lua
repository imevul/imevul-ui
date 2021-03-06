local args = { ... }
local ui = args[1]
assert(ui, 'Imevul UI library not found')
local gfx = ui.lib.cobalt.graphics

---@class Text : Object Text object for displaying a string. Can be changed later via setText(). If the text is changed directly via .text field, the width will not be recalculated.
local Text = ui.lib.class(ui.modules.Object, function(this, data)
	data = data or {}

	data.text = data.text or ''

	if data.width and data.width > 0 then
		this.fixedWidth = true
		data.width = data.width or 1
	else
		this.fixedWidth = false
		data.width = string.len(data.text) or 1
	end

	data.height = data.height or 1

	data.padding = data.padding or 0
	data.align = data.align or 'left'

	if data.padding > 0 then
		data.width = data.width + math.ceil(data.padding * 2)
		data.height = data.height + math.ceil(data.padding * 2)
	end

	this.text = data.text
	this.width = data.width
	this.padding = data.padding
	this.align = data.align
	this.color = data.color or nil

	ui.modules.Object.init(this, data)
	this.type = 'Text'
end)

---Update the text value
---@public
---@param newText string New text value
function Text:setText(newText)
	if self.text == newText then
		return
	end

	self.text = newText
	self:_resizeForText(self.text)

	if self.callbacks.onChange then
		self.callbacks.onChange(self)
	end
end

---Resize the object based on the size of the new text value
---@protected
---@param newText string New text value
function Text:_resizeForText(newText)
	if not self.fixedWidth then
		self.width = string.len(newText) + math.ceil(self.padding * 2)
		self.canvas = gfx.newCanvas(self.width, self.height)
	end
end

---@see Object#_draw
function Text:_draw()
	ui.modules.Object._draw(self)

	gfx.setColor(self.color or self.config.theme.text or colors.white)
	local tx
	local ty = math.floor(self.height / 2)

	if self.align == 'left' then
		tx = math.ceil(self.padding / 2)
	elseif self.align == 'center' then
		tx = math.floor((self.width - string.len(self.text)) / 2)
	elseif self.align == 'right' then
		tx = math.floor(self.width - self.padding / 2 - string.len(self.text))
	end

	gfx.print(self.text, tx, ty)
end

return Text
