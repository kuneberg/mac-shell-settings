--- @sync entry
-- Enter on a directory: cd into it and quit, so the shell wrapper (y)
-- lands there. Enter on a file: open it normally.
return {
	entry = function()
		local h = cx.active.current.hovered
		if h and h.cha.is_dir then
			ya.emit("enter", {})
			ya.emit("quit", {})
		else
			ya.emit("open", { hovered = true })
		end
	end,
}
