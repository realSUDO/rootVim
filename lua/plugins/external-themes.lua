return {
-- ==========================
-- catppuccin
-- ==========================
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- ensure theme loads early
    priority = 1000, -- make sure it overrides defaults
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
        term_colors = true,
        integrations = {
          telescope = true,
          treesitter = true,
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          notify = true,
          mini = true,
          which_key = true,
        },
      })
    end
  },

-- ==========================
-- TokyoNight
-- ==========================

  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        transparent = true,
        terminal_colors = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        dim_inactive = false,
        lualine_bold = true,
        on_colors = function(colors)
          -- Optional: make comments dimmer for readability
          colors.comment = "#6B7089"
        end,
      })
    end
  },
}

