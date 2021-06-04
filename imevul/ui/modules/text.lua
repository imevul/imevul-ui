local args = { ... }
local ui = args[1]

local Text = ui.lib.class(ui.modules.Object,function(this, data)
	data = data or {}
	this.text = data.text or ''

	this.width = string.len(this.text)
	if data.width ~= nil then
		this.width = data.width
	end

	this.height = 1
end)

function Text:_draw()
	this.canvas:renderTo(function()
		ui.lib.cobalt.graphics.print(this.text, 0, 0)
	end)
end

return Text
