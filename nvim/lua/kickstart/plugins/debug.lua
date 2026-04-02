return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Language support
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
    'jbyuki/one-small-step-for-vimkind',

    -- Optional: inline variable display
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true, -- Highlight changed values!
        highlight_new_as_changed = true,
        show_stop_reason = true,
        commented = false, -- Whether to prefix virtual text with comment string
        only_first_definition = true,
      },
    },
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle UI',
    },
    {
      '<leader>dw', -- "d"ebug "w"rangler
      function()
        require('dapui').float_element('scopes', { enter = true, width = 80, height = 30 })
      end,
      desc = 'Debug: Data Wrangler (Floating Scopes)',
    },
    {
      '<F10>',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: terminate session',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local mason_dap = require 'mason-nvim-dap'

    dap.listeners.after.event_initialized['hide_diagnostics'] = function()
      vim.diagnostic.enable(false)
    end

    dap.listeners.after.event_terminated['show_diagnostics'] = function()
      vim.diagnostic.enable(true)
    end

    dap.listeners.after.event_exited['show_diagnostics'] = function()
      vim.diagnostic.enable(true)
    end

    require('nvim-dap-virtual-text').setup {
      virt_text_pos = 'eol',
      display_callback = function(variable, buf, stackframe, node, options)
        local max_len = 60 -- Set your character limit here
        local text = variable.value:gsub('%s+', ' ')

        if #text > max_len then
          text = string.sub(text, 1, max_len) .. '... '
        end

        return '   ' .. variable.name .. ' = ' .. text
      end,
      -- Other configurations...
    }
    dap.adapters['local-lua'] = {
      type = 'executable',
      command = 'node',
      args = {
        vim.fn.stdpath 'data' .. '/mason/packages/local-lua-debugger-vscode/extension/extension/debugAdapter.js',
      },
    }

    mason_dap.setup {
      ensure_installed = {
        'debugpy',
        'lua-debugger-adapter',
      },
      automatic_installation = true,
      handlers = {
        function(config)
          mason_dap.default_setup(config)
        end,
      },
    }

    dap.configurations.lua = {
      {
        type = 'local-lua',
        request = 'launch',
        name = 'start_debuging',
        cwd = vim.uv.cwd(),
        program = {
          lua = 'lua',
          file = '${file}',
        },

        extensionPath = vim.fn.stdpath 'data' .. '/mason/packages/local-lua-debugger-vscode/extension/',
        -- This ensures the debugger can find its own scripts
        scripts = {
          vim.fn.stdpath 'data' .. '/mason/packages/local-lua-debugger-vscode/extension/debugger/lldebugger.lua',
        },
      },
    }

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file with arguments',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        console = 'integratedTerminal',

        args = function()
          local args_string = vim.fn.input 'Arguments: '
          return vim.split(args_string, ' +')
        end,

        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            return cwd .. '/.venv/bin/python'
          else
            return '/usr/bin/python'
          end
        end,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Pytest: Current file.',
        module = 'pytest',
        args = {
          '${file}',
          '-sv',
        },
        console = 'integratedTerminal',
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            return cwd .. '/.venv/bin/python'
          else
            return '/usr/bin/python'
          end
        end,
      },
    }
    -- Set up DAP UI
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Auto open/close DAP UI
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end

    local dap_python = require 'dap-python'
    local mason_path = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'

    local has_nerd_font = vim.g.have_nerd_font
    local icons = has_nerd_font
        and {
          Breakpoint = '',
          BreakpointCondition = '',
          BreakpointRejected = '',
          LogPoint = '',
          Stopped = '',
        }
      or {
        Breakpoint = '●',
        BreakpointCondition = '⊜',
        BreakpointRejected = '⊘',
        LogPoint = '◆',
        Stopped = '⭔',
      }

    for name, icon in pairs(icons) do
      vim.fn.sign_define('Dap' .. name, { text = icon, texthl = 'DiagnosticSignWarn', numhl = '' })
    end
  end,
}
