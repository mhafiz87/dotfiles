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
        "nvim-neotest/nvim-nio",
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim"
      },
      requires = { "mfussenegger/nvim-dap" },
      config = function()
        local dap, dapui = require("dap"), require("dapui")
        local mason, mason_dap = require("mason"), require("mason-nvim-dap")
        mason.setup()
        mason_dap.setup({
          ensure_installed = {
            "python"
          }
        })
        dapui.setup({})
        vim.fn.sign_define("DapBreakpoint", {
          text = "",
          texthl = "DiagnosticSignError",
          linehl = "",
          numhl = "",
        })

        vim.fn.sign_define("DapBreakpointRejected", {
          text = "", -- or "❌"
          texthl = "DiagnosticSignError",
          linehl = "",
          numhl = "",
        })

        vim.fn.sign_define("DapStopped", {
          text = "", -- or "→"
          texthl = "DiagnosticSignWarn",
          linehl = "Visual",
          numhl = "DiagnosticSignWarn",
        })
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
        vim.keymap.set("n", "<leader>dbB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "[d]e[b]ugger [B]reakpoint condition" })
        vim.keymap.set("n", "<leader>dbc", dap.continue, { desc = "[d]e[b]ugger [c]ontinue" })
        vim.keymap.set("n", "<leader>dbC", dap.run_to_cursor, { desc = "[d]e[b]ugger run to [C]ursor" })
        vim.keymap.set("n", "<leader>dbt", dapui.toggle, { desc = "[d]e[b]ugger [t]oggle" })
        vim.keymap.set("n", "<leader>dbo", dap.step_over, { desc = "[d]e[b]ugger step [o]ver" })
        vim.keymap.set("n", "<leader>dbi", dap.step_over, { desc = "[d]e[b]ugger step [i]nto" })
        vim.keymap.set("n", "<leader>dbO", dap.step_out, { desc = "[d]e[b]ugger step [O]ut" })
        vim.keymap.set("n", "<leader>dbq", dap.terminate, { desc = "[d]e[b]ugger [q]uit" })
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
        local utils = require("utils")
        local dap_python = require("dap-python")
        if utils.is_windows() then
          local path = vim.fn.stdpath("data") .. "\\mason\\packages\\debugpy\\venv\\Scripts\\python.exe"
          dap_python.setup(path)
        else
          dap_python.setup()
        end
        dap_python.setup("python")
        vim.keymap.set("n", "<leader>dbr", dap_python.test_method, { desc = "[d]e[b]ugger [r]un" })
      end,
    },
  }
  return data
end

return M
