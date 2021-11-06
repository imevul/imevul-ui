local args = { ... }
local ui = args[1]
local gfx = ui.lib.cobalt.graphics

--[[
Class Image
Draws an image (Cobalt 2 Drawable)
]]--
local Image = ui.lib.class(ui.modules.Object, function(this, data)
	ui.modules.Object.init(this, data)

	data = data or {}
	this.source = data.source or nil
	this.image = nil

	if this.source then
		this.image = gfx.newImage(this.source)
		assert(this.image)
	else
		if data.image and data.image.typeOf and data.image:typeOf('Drawable') then
			this.image = data.image
		end
	end

	if this.image then
		this:resize(this.image:getWidth(), this.image:getHeight())
	end

	this.type = 'Image'
end)

function Image:_draw()
	gfx.setBackgroundColor(self.config.theme.background or colors.black)
	gfx.clear()
	ui.modules.Object._draw(self)

	if self.image then
		gfx.draw(self.image)
	end
end

return Image
