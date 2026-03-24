-------------------------------------------------------
--- Auto-show diagnostics on CursorHold
-------------------------------------------------------
vim.opt.updatetime = 000

vim.diagnostic.config({ virtual_text = false })

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
    end,
})

-------------------------------------------------------
--- Float styling (applies to hover and all other floats)
-------------------------------------------------------
vim.api.nvim_set_hl(0, "NormalFloat",              { fg = "#E6E1FF", bg = "#0D0825" })
vim.api.nvim_set_hl(0, "FloatBorder",              { fg = "#B983FF", bg = "#0D0825" })

-------------------------------------------------------
--- Neovim-aware Lua config
-------------------------------------------------------
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = vim.api.nvim_get_runtime_file('', true),
      },
    })
  end,
  settings = {
    Lua = {},
  },
})
vim.lsp.enable('lua_ls')

-------------------------------------------------------
--- Rust config
-------------------------------------------------------
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false,
      },
      hover = {
        memoryLayout = {
          enable = true,
          size = "decimal",
          alignment = "decimal",
          niches = true,       -- show niche optimisation info
        },
      },
    }
  }
})
vim.lsp.enable('rust_analyzer')
