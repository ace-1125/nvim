local function pad(desc, fill, width)
	width = width or 70
	local gap = width - #desc
	if gap <= 2 then
		return desc
	end
	return desc .. " " .. string.rep(fill, gap - 2) .. " "
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = false },
    dashboard = { 
      enabled = true,
  width = 75,
  row = nil, -- dashboard position. nil for center
  col = nil, -- dashboard position. nil for center
  pane_gap = 4, -- empty columns between vertical panes
  autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
  preset = {
    ---@type fun(cmd:string, opts:table)|nil
    pick = nil,
    keys = {
      { icon = " ", key = "f", desc = pad("Find File", "·"), action = ":lua Snacks.dashboard.pick('files')" },
      { icon = " ", key = "t", desc = pad("Open Tree", "·"), action = ":Neotree" },
      { icon = " ", key = "g", desc = pad("Find Text", "·"), action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = " ", key = "r", desc = pad("Recent Files", "·"), action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = " ", key = "c", desc = pad("Config", "·"), action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
      -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      { icon = " ", key = "q", desc = pad("Quit", "·"), action = ":qa" },
    },
    header = [[
                █████████     █████████  ██████████  ██  █████████           
               ███░░░░░███   ███░░░░░███░░███░░░░░█ ███ ███░░░░░███          
              ░███    ░███  ███     ░░░  ░███  █ ░ ░░░ ░███    ░░░           
              ░███████████ ░███          ░██████       ░░█████████           
              ░███░░░░░███ ░███          ░███░░█        ░░░░░░░░███          
              ░███    ░███ ░░███     ███ ░███ ░   █     ███    ░███          
              █████   █████ ░░█████████  ██████████    ░░█████████           
             ░░░░░   ░░░░░   ░░░░░░░░░  ░░░░░░░░░░      ░░░░░░░░░            
                                                                             
  ██████   █████ ██████████    ███████    █████   █████ █████ ██████   ██████
 ░░██████ ░░███ ░░███░░░░░█  ███░░░░░███ ░░███   ░░███ ░░███ ░░██████ ██████ 
  ░███░███ ░███  ░███  █ ░  ███     ░░███ ░███    ░███  ░███  ░███░█████░███ 
  ░███░░███░███  ░██████   ░███      ░███ ░███    ░███  ░███  ░███░░███ ░███ 
  ░███ ░░██████  ░███░░█   ░███      ░███ ░░███   ███   ░███  ░███ ░░░  ░███ 
  ░███  ░░█████  ░███ ░   █░░███     ███   ░░░█████░    ░███  ░███      ░███ 
  █████  ░░█████ ██████████ ░░░███████░      ░░███      █████ █████     █████
 ░░░░░    ░░░░░ ░░░░░░░░░░    ░░░░░░░         ░░░      ░░░░░ ░░░░░     ░░░░░ ]],
  },
  formats = {
    icon = function(item)
	if item.file and item.icon == "file" or item.icon == "directory" then
		return Snacks.dashboard.icon(item.file, item.icon)
	end
	return { item.icon, width = 2, hl = "icon" }
    end,
    footer = { "%s", align = "center" },
    header = { "%s", align = "center" },
    file = function(item, ctx)
	local fname = vim.fn.fnamemodify(item.file, ":~")
	fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
	if #fname > ctx.width then
		local dir = vim.fn.fnamemodify(fname, ":h")
		local file = vim.fn.fnamemodify(fname, ":t")
		if dir and file then
			file = file:sub(-(ctx.width - #dir - 2))
			fname = dir .. "/…" .. file
		end
	end
	local dir, file = fname:match("^(.*)/(.+)$")
	return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
    end,
  },
  sections = {
    { section = "header" },

    {
      pane = 2,
      section = "terminal",
      cmd = "fastfetch -s none --logo-padding-left 10",
      height = 20,
      padding = 1,
    },
      {
    text = {
      string.format("v%d.%d.%d", vim.version().major, vim.version().minor, vim.version().patch),
      align = "right",
      hl = "Comment",
    },
    padding = 1,
  },
    { section = "keys", gap = 1, padding = 1 },
    { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
    { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    {
      pane = 2,
      icon = " ",
      title = "Git Status",
      section = "terminal",
      enabled = function()
	return Snacks.git.get_root() ~= nil
      end,
      cmd = "git status --short --branch --renames",
      height = 5,
      padding = 1,
      ttl = 5 * 60,
      indent = 3,
    },
    { section = "startup" },
  },
    },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
}
