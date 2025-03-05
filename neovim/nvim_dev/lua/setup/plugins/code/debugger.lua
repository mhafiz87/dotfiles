local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    {
      enabled = args.enable,
      "mfussenegger/nvim-dap",
    },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "nvim-neotest/nvim-nio"
      },
      requires = { "mfussenegger/nvim-dap" },
      config = function()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup({})
        dap.listeners.before.attach.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close()
        end
        vim.keymap.set("n", "<leader>dbb", dap.toggle_breakpoint, { desc = "[d]e[b]ugger [b]reakpoint" })
        vim.keymap.set("n", "<leader>dbc", dap.continue, { desc = "[d]e[b]ugger [c]ontinue" })
        vim.keymap.set("n", "<leader>dbt", dapui.toggle, { desc = "[d]e[b]ugger [t]oggle" })
      end,
    },
    {
      enabled = args.enable,
      "mfussenegger/nvim-dap-python",
      ft = "python",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
      config = function()
        local global = require("global")
        local dap_python = require("dap-python")
        if global.is_windows then
          local path = os.getenv("localappdata") .. "\\nvim_dev-data\\mason\\packages\\debugpy\\venv\\Scripts\\python.exe"
          dap_python.setup(path)
        else
          dap_python.setup()
        end
        vim.keymap.set("n", "<leader>dbr", dap_python.test_method, { desc = "[d]e[b]ugger [r]un" })
      end,
    },
  }
  return data
end

return M
