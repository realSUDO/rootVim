return {
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup({
        '*'; -- Apply to all file types
      }, {
        mode = 'background',
        css = true, -- Enable all CSS features
        tailwind = true, -- Enable tailwind colors
      })
    end
  }
}
