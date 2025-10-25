-- references:
-- https://tamerlan.dev/a-guide-to-debugging-applications-in-neovim/

return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      -- "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function ()
      local dap = require("dap")
      local ui = require("dapui")
      local dap_virtual_text = require("nvim-dap-virtual-text")

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

      dap_virtual_text.setup({})
      ui.setup()
      dap.listeners.before.attach["dapui_config"] = function()
        ui.open()
      end
      dap.listeners.before.launch["dapui_config"] = function()
        ui.open()
      end
      dap.listeners.after.event_initialized["dapui_config"] = function()
        ui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        ui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        ui.close()
      end

      vim.keymap.set("n", "<leader>dbb", function()
        dap.toggle_breakpoint()
      end, { desc = "toggle [b]reakpoint" })
      vim.keymap.set("n", "<leader>dbc", function()
        dap.continue()
      end, { desc = "[c]ontinue" })
      vim.keymap.set("n", "<leader>dbo", function()
        dap.step_over()
      end, { desc = "step [o]ver" })
      vim.keymap.set("n", "<leader>dbO", function()
        dap.step_out()
      end, { desc = "Step Out" })
      vim.keymap.set("n", "<leader>dbi", function()
        dap.step_into()
      end, { desc = "Step into" })
      vim.keymap.set("n", "<leader>dbq", function()
        dap.terminate()
      end, { desc = "Quit" })
      vim.keymap.set("n", "<leader>dbu", function()
        ui.toggle()
      end, { desc = "Toggle UI" })
      -- vim.keymap.set("n", "<leader>dbt", function()
      --   dap.toggle_breakpoint({ condition = "condition" })
      -- end, { desc = "Toggle Breakpoint with Condition" })

    end
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      require("dap-python").setup("uv")
    end
  },
}
