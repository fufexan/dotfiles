{ colors, ... }:
let
  c = colors;
  h = color: "'#${color}'";
in
{
  programs.neovim.extraConfig = ''
    lua << 

    local o = vim.opt

    o.termguicolors = true
    o.background = 'dark'
    vim.cmd 'syntax on'
    vim.cmd 'colorscheme tokyonight'
    o.cursorline = true

    -- feline --
    local components = {
      active = {{}, {}, {}},
      inactive = {{}, {}}
    }

    local colors = {
      fg = ${h c.bg},
      bg = ${h c.bg},

      red = ${h c.normal.red},
      green = ${h c.normal.green},
      yellow = ${h c.normal.yellow},
      magenta = ${h c.normal.magenta}
    }

    local vi_mode_text = {
      n = "n",
      i = "i",
      v = "v",
      [''] = "^v",
      V = "V",
      c = "c",
      R = "R",
      r = "r",
      t = "i"
    }

    local vi_mode_utils = require('feline.providers.vi_mode')

    table.insert(components.active[1], {
      provider = function()
        local mode = vi_mode_text[vim.fn.mode()]
        mode = mode and mode or 'UNKNOWN'
        return ' ' .. mode .. ' '
      end,
      hl = function()
        return {
          name = vi_mode_utils.get_mode_highlight_name(),
          fg = colors.fg,
          bg = colors.red,
          style = 'bold'
        }
      end,
    })

    table.insert(components.active[1], {
      provider = 'file_info',
      hl = {
        fg = colors.fg,
        bg = colors.yellow,
        style = 'bold'
      },
      left_sep = {
        str = ' ',
        hl = {bg = colors.yellow}
      },
      right_sep = {
        {
          str = ' ',
          hl = {bg = colors.yellow}
        },
        ' '
      }
    })

    table.insert(components.active[3], {
      provider = 'line_percentage',
      hl = {
        fg = colors.fg,
        bg = colors.magenta,
        style = 'bold'
      },
      right_sep = {
        str = ' ',
        hl = { bg = colors.magenta }
      },
      left_sep = {
        str = ' ',
        hl = { bg = colors.magenta }
      }
    })

    table.insert(components.active[3], {
      provider = 'position',
      hl = {
        fg = colors.fg,
        bg = colors.green,
        style = 'bold'
      },
      right_sep = {
        str = ' ',
        hl = { bg = colors.green }
      }
    })

    require('feline').setup {
      bg = colors.bg,
      fg = colors.fg,
      colors = colors,
      vi_mode_colors = vi_mode_colors,
      components = components
    }
  '';
}
