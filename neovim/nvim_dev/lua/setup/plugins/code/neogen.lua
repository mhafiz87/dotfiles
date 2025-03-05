local M = {}

function M.init(args)
  setmetatable(args, { __index = { enable = true } })
  local data = {
    enabled = args.enable,
    "danymat/neogen",
    event = "BufReadPost",
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
                { nil,                     '"""',                      { no_results = true, type = { "class", "func" } } },
                { nil,                     'Summary:',                 { no_results = true, type =  { "class", "func" } } },
                { nil,                     '\t$1',                     { no_results = true, type =  { "class", "func" } } },
                { nil,                     "",                         { no_results = true, type =  { "class", "func" } } },
                { nil,                     'Description:',             { no_results = true, type =  { "class", "func" } } },
                { nil,                     '\t$1',                     { no_results = true, type =  { "class", "func" } } },
                { nil,                     "",                         { no_results = true, type =  { "class", "func" } } },
                { nil,                     'Args:',                    { no_results = true, type =  { "class", "func" } } },
                { i.Parameter,             "\t%s: $1",                 { no_results = true, type =  { "class", "func" } } },
                { { i.Parameter, i.Type }, "\t%s (%s): $1",            { no_results = true, required = i.Tparam, type =  { "class", "func" } } },
                { i.ArbitraryArgs,         "\t%s: $1",                 { no_results = true, type =  { "class", "func" } } },
                { i.Kwargs,                "\t%s: $1",                 { no_results = true, type =  { "class", "func" } } },
                { i.ClassAttribute,        "\t%s: $1",                 { no_results = true, before_first_item = { "", "Attributes: " } } },
                { nil,                     '\t$1',                     { no_results = true, type =  { "class", "func" } } },
                { nil,                     "",                         { no_results = true, type =  { "class", "func" } } },
                { nil,                     'Raises:',                  { no_results = true, type =  { "class", "func" } } },
                { nil,                     '\t$1',                     { no_results = true, type =  { "class", "func" } } },
                { i.Throw,                 "\t%s: $1",                 { no_results = true, type =  { "class", "func" } } },
                { nil,                     "",                         { no_results = true, type =  { "class", "func" } } },
                { nil,                     'Examples:',                { no_results = true, type =  { "class", "func" } } },
                { nil,                     '\t.. code-block:: python', { no_results = true, type =  { "class", "func" } } },
                { nil,                     '\t# $1',                   { no_results = true, type =  { "class", "func" } } },
                { nil,                     '\t>>> $1',                 { no_results = true, type =  { "class", "func" } } },
                { nil,                     "",                         { no_results = true, type =  { "class", "func" } } },
                { nil,                     'Returns:',                 { no_results = true, type =  { "class", "func" } } },
                { i.ReturnTypeHint,        "\t%s",                     { no_results = true, type =  { "class", "func" } } },
                { nil,                     '\t$1',                     { no_results = true, type =  { "class", "func" } } },
                { nil,                     "",                         { no_results = true, type =  { "class", "func" } } },
                { i.HasYield,              "Yields:",                  { no_results = true, type =  { "class", "func" } } },
                { i.HasYield,              "\t$1",                     { no_results = true, type =  { "class", "func" } } },
                { i.HasYield,              "",                         { no_results = true, type =  { "class", "func" } } },
                { nil,                     'Caveats:',                 { no_results = true, type =  { "class", "func" } } },
                { nil,                     '\t$1',                     { no_results = true, type =  { "class", "func" } } },
                { nil,                     '"""',                      { no_results = true, type = { "class", "func" } }},
                { nil,                     '"""',                      { type = { "class", "class", "func" } } },
                { nil,                     'Summary:',                 { type = { "class", "func" } } },
                { nil,                     '\t$1',                     { type = { "class", "func" } } },
                { nil,                     "",                         { type = { "class", "func" } } },
                { nil,                     'Description:',             { type = { "class", "func" } } },
                { nil,                     '\t$1',                     { type = { "class", "func" } } },
                { nil,                     "",                         { type = { "class", "func" } } },
                { nil,                     'Args:',                    { type = { "class", "func" } } },
                { i.Parameter,             "\t%s: $1",                 { type = { "class", "func" } } },
                { { i.Parameter, i.Type }, "\t%s (%s): $1",            { required = i.Tparam, type = { "class", "func" } } },
                { i.ArbitraryArgs,         "\t%s: $1",                 { type = { "class", "func" } } },
                { i.Kwargs,                "\t%s: $1",                 { type = { "class", "func" } } },
                { i.ClassAttribute,        "\t%s: $1",                 { before_first_item = { "", "Attributes: " } } },
                { nil,                     '\t$1',                     { type = { "class", "func" } } },
                { nil,                     "",                         { type = { "class", "func" } } },
                { nil,                     'Raises:',                  { type = { "class", "func" } } },
                { nil,                     '\t$1',                     { type = { "class", "func" } } },
                { i.Throw,                 "\t%s: $1",                 { type = { "class", "func" } } },
                { nil,                     "",                         { type = { "class", "func" } } },
                { nil,                     'Examples:',                { type = { "class", "func" } } },
                { nil,                     '\t.. code-block:: python', { type = { "class", "func" } } },
                { nil,                     '\t# $1',                   { type = { "class", "func" } } },
                { nil,                     '\t>>> $1',                 { type = { "class", "func" } } },
                { nil,                     "",                         { type = { "class", "func" } } },
                { nil,                     'Returns:',                 { type = { "class", "func" } } },
                { i.ReturnTypeHint,        "\t%s",                     { type = { "class", "func" } } },
                { nil,                     '\t$1',                     { type = { "class", "func" } } },
                { nil,                     "",                         { type = { "class", "func" } } },
                { i.HasYield,              "Yields:",                  { type = { "class", "func" } } },
                { i.HasYield,              "\t$1",                     { type = { "class", "func" } } },
                { i.HasYield,              "",                         { type = { "class", "func" } } },
                { nil,                     'Caveats:',                 { type = { "class", "func" } } },
                { nil,                     '\t$1',                     { type = { "class", "func" } } },
                { nil,                     '"""',                      { type = { "class", "func" } }},
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

