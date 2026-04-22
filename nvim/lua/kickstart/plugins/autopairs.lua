-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  dependencies = { 'hrsh7th/nvim-cmp' }, -- Ensure cmp loads first
  config = function()
    local autopairs = require 'nvim-autopairs'

    autopairs.setup {
      check_ts = true, -- Use Treesitter to be smarter
      disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
    }

    -- Integration with nvim-cmp
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local cmp = require 'cmp'

    fast_wrap =
      {
        map = '<M-e>', -- Alt+e to wrap the word under cursor
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%)%>%]%]%}%,]]=],
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey = 'Comment',
      },
      -- This makes it so that when you confirm a completion item,
      -- autopairs decides if it needs to add brackets
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
