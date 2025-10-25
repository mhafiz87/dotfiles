-- references:
-- https://tamerlan.dev/a-guide-to-debugging-applications-in-neovim/

local dap_ui_layout = {
    layouts = { {
        elements = { {
            id = "scopes",
            size = 0.25
          }, {
            id = "breakpoints",
            size = 0.25
          }, {
            id = "stacks",
            size = 0.25
          }, {
            id = "watches",
            size = 0.25
          } },
        position = "left",
        size = 120
      }, {
        elements = { {
            id = "console",
            size = 0.75
          }, {
            id = "repl",
            size = 0.25
          } },
        position = "bottom",
        size = 10
      } },
}

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

      vim.fn.sign_define("DapBreakpointCondition", {
        text = "",
        texthl = "DiagnosticSignWarn",
        linehl = "",
        numhl = "",
      })

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
      ui.setup(dap_ui_layout)
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

      local which_key_exist, which_key = pcall(require, "which-key")
      if which_key_exist then
        vim.keymap.set("n", "<leader>db.", function()
          which_key.show(
            {
              keys = "<leader>db",
              loop = true
            }
          )
        end, { desc = "enable hydra mode" }
        )
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
      vim.keymap.set("n", "<leader>dbB", function()
        local snacks_exist, Snacks = pcall(require, "snacks")
        local condition = nil
        local hit_condition = nil
        local log_message = nil
        if snacks_exist then
          local get_input = function(prompt)
            local co = coroutine.running()
            assert(co, "must be in coroutine")
            Snacks.input({prompt=prompt}, function(data)
              coroutine.resume(co, data)
            end)
            return coroutine.yield()
          end
          coroutine.wrap(function()
            log_message = get_input("Log message (optional): ")
            dap.toggle_breakpoint(condition, hit_condition, log_message)
          end)()
          coroutine.wrap(function()
            hit_condition = get_input("Hit count (optional): ")
          end)()
          coroutine.wrap(function()
            condition = get_input("Breakpoint condition (optional): ")
          end)()
        else
          condition = vim.fn.input("Breakpoint condition (optional): ")
          hit_condition = vim.fn.input("Hit count (optional): ")
          log_message = vim.fn.input("Log message (optional): ")
          -- Convert empty strings to nil
          condition = condition ~= "" and condition or nil
          hit_condition = hit_condition ~= "" and hit_condition or nil
          log_message = log_message ~= "" and log_message or nil
          dap.toggle_breakpoint(condition, hit_condition, log_message)
        end
      end, { desc = "set conditional [b]reakpoint" })
      -- vim.keymap.set("n", "<leader>dbh", function()
      --   dap.toggle_breakpoint({ condition = "condition" })
      -- end, { desc = "toggle breakpoint with [c]ondition" })

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
