return {
  "folke/snacks.nvim",
  -- enabled = false,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
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
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      right = { "fold", "git" }, -- priority of signs on the right (high to low)
      folds = {
        open = true, -- show open fold icons
        git_hl = false, -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { "GitSign", "MiniDiffSign" },
      },
      refresh = 50, -- refresh at most every 50ms
    },
    words = { enabled = true },
    zen = {
      toggles = {
        git_signs = true,
        mini_diff_signs = true,
        diagnostics = true
      },
      show = {
        statusline = true,
        tabline = true
      }
    }
  },
  keys = {
    { "<leader>bf", function() Snacks.picker.buffers() end, desc = "[b]uffers [f]ind" },
    { "<leader>bd", function() Snacks.bufdelete(0) end, desc = "[b]uffer current [d]elete" },
    { "<leader>bD", function() Snacks.bufdelete.other() end, desc = "[b]uffers other [D]elete" },
    { "<leader>ff", function() Snacks.picker.files({hidden=true}) end, desc = "[f]ind [f]files" },
    { "<leader>fm", function() Snacks.picker.marks() end, desc = "[f]ind [m]arks" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    -- { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    { "<leader>dga", function() Snacks.picker.diagnostics() end, desc = "[d]ia[g]nostics" },
    { "<leader>dgb", function() Snacks.picker.diagnostics_buffer() end, desc = "[d]ia[g]nostics [b]uffer" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "[g]it [s]tatus" },
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "[g]it [b]ranch" },
    { "<leader>gl", function() Snacks.git.blame_line() end, desc = "[g]it b[l]ame" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "[g]it b[l]ame" },
    { "<leader>tt", function() Snacks.terminal("pwsh") end, desc = "[t]oggle [t]erminal" },
    { "<leader>tz", function() Snacks.zen() end, desc = "[t]oggle [z]en" },
  },
  init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function ()
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>trn")
          Snacks.toggle.inlay_hints():map("<leader>tih")
          Snacks.toggle.diagnostics():map("<leader>td")
        end,
      })
  end
}
