local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "danymat/neogen",
    config = function()
      local i = require("neogen.types.template").item
      require('neogen').setup({
        snippet_engine = "luasnip",
        languages = {
          python = {
            template = {
              -- annotation_convention = "google_docstrings",
              annotation_convention = "orbital",
              orbital = {
                { nil,                     '"""$1"""',                { no_results = true, type = { "class", "func" } } },
                { nil,                     '"""$1',                   { no_results = true, type = { "file" } } },
                { nil,                     "",                        { no_results = true, type = { "file" } } },
                { nil,                     "$1",                      { no_results = true, type = { "file" } } },
                { nil,                     '"""',                     { no_results = true, type = { "file" } } },
                { nil,                     "",                        { no_results = true, type = { "file" } } },

                { nil,                     "# $1",                    { no_results = true, type = { "type" } } },

                { nil,                     '"""' },
                { nil,                     'Summary:',                { type = { "func" } } },
                { nil,                     '\t$1',                    { type = { "func" } } },
                { nil,                     "",                        { type = { "func" } } },
                { nil,                     'Description:',            { type = { "func" } } },
                { nil,                     '\t$1',                    { type = { "func" } } },
                { nil,                     "",                        { type = { "func" } } },
                { nil,                     'Args:',                   { type = { "func" } } },
                { i.Parameter,             "\t%s: $1",                { type = { "func" } } },
                { { i.Parameter, i.Type }, "\t%s (%s): $1",           { required = i.Tparam, type = { "func" } } },
                { i.ArbitraryArgs,         "\t%s: $1",                { type = { "func" } } },
                { i.Kwargs,                "\t%s: $1",                { type = { "func" } } },
                { i.ClassAttribute,        "\t%s: $1",                { before_first_item = { "", "Attributes: " } } },
                { nil,                     '\t$1',                    { type = { "func" } } },
                { nil,                     "",                        { type = { "func" } } },
                { nil,                     'Raises:',                 { type = { "func" } } },
                { nil,                     '\t$1',                    { type = { "func" } } },
                { i.Throw,                 "\t%s: $1",                { type = { "func" } } },
                { nil,                     "",                        { type = { "func" } } },
                { nil,                     'Examples:',               { type = { "func" } } },
                { nil,                     ' .. code-block:: python', { type = { "func" } } },
                { nil,                     '\t# $1',                  { type = { "func" } } },
                { nil,                     '\t>>> $1',                { type = { "func" } } },
                { nil,                     "",                        { type = { "func" } } },
                { nil,                     'Returns:',                { type = { "func" } } },
                { i.ReturnTypeHint,        "\t%s",                    { type = { "func" } } },
                { nil,                     '\t$1',                    { type = { "func" } } },
                { nil,                     "",                        { type = { "func" } } },
                { i.HasYield,              "Yields:",                 { type = { "func" } } },
                { i.HasYield,              "\t$1",                    { type = { "func" } } },
                { i.HasYield,              "",                        { type = { "func" } } },
                { nil,                     'Caveats:',                { type = { "func" } } },
                { nil,                     '\t$1',                    { type = { "func" } } },
                { nil,                     "",                        { type = { "func" } } },
                { nil,                     '"""' },
              },
            }
          }
        },
      })
      vim.keymap.set({ "n", "v" }, "<leader>ds", ":lua require('neogen').generate()<cr>",
        { desc = "Generate Docstring", silent = true })
    end,
  }
  return data
end

return M
