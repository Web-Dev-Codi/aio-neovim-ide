local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')

local properties = {
  force_inactive = {
    filetypes = {},
    buftypes = {},
    bufnames = {}
  }
}

local components = {
  left = {
    active = {},
    inactive = {}
  },
  right = {
    active = {},
    inactive = {}
  }
}

local gruvbox = {
  bg = '#282828',
  black = '#282828',
  yellow = '#d8a657',
  cyan = '#89b482',
  oceanblue = '#45707a',
  green = '#a9b665',
  orange = '#e78a4e',
  violet = '#d3869b',
  magenta = '#c14a4a',
  white = '#a89984',
  fg = '#a89984',
  skyblue = '#7daea3',
  red = '#ea6962',
}

local vi_mode_colors = {
  NORMAL = gruvbox.green,
  OP = gruvbox.green,
  INSERT = gruvbox.red,
  VISUAL = gruvbox.skyblue,
  BLOCK = gruvbox.skyblue,
  REPLACE = gruvbox.violet,
  ['V-REPLACE'] = gruvbox.violet,
  ENTER = gruvbox.cyan,
  MORE = gruvbox.cyan,
  SELECT = gruvbox.orange,
  COMMAND = gruvbox.green,
  SHELL = gruvbox.green,
  TERM = gruvbox.green,
  NONE = gruvbox.yellow
}

local vi_mode_text = {
  NORMAL = '<|',
  OP = '<|',
  INSERT = '|>',
  VISUAL = '<>',
  BLOCK = '<>',
  REPLACE = '<>',
  ['V-REPLACE'] = '<>',
  ENTER = '<>',
  MORE = '<>',
  SELECT = '<>',
  COMMAND = '<|',
  SHELL = '<|',
  TERM = '<|',
  NONE = '<>'
}

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

local checkwidth = function()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

properties.force_inactive.filetypes = {
  'NvimTree',
  'dbui',
  'packer',
  'startify',
  'fugitive',
  'fugitiveblame'
}

properties.force_inactive.buftypes = {
  'terminal'
}

-- LEFT

-- vi-mode
components.left.active[1] = {
  provider = ' NV-IDE ',
  hl = function()
    local val = {}

    val.bg = vi_mode_utils.get_mode_color()
    val.fg = gruvbox.bg
    val.style = 'bold'

    return val
  end,
  right_sep = ' '
}
-- vi-symbol
components.left.active[2] = {
  provider = function()
    return vi_mode_text[vi_mode_utils.get_vim_mode()]
  end,
  hl = function()
    local val = {}
    val.fg = vi_mode_utils.get_mode_color()
    val.bg = gruvbox.bg
    val.style = 'bold'
    return val
  end,
  right_sep = ' '
}
-- filename
components.left.active[3] = {
  provider = function()
    return vim.fn.expand("%:F")
  end,
  enabled = buffer_not_empty,
  hl = {
    fg = gruvbox.white,
    bg = gruvbox.bg,
    style = 'bold'
  }
}
-- gitIcon
components.left.active[4] = {
  provider = function() return ' ' end,
  enabled = buffer_not_empty(),
  hl = {
    fg = gruvbox.orange,
    bg = gruvbox.bg
  }
}
-- gitBranch
components.left.active[5] = {
  provider = 'git_branch',
  enabled = buffer_not_empty(),
  hl = {
    fg = gruvbox.yellow,
    bg = gruvbox.bg,
    style = 'bold'
  }
}
-- diffAdd
components.left.active[6] = {
  provider = 'git_diff_added',
  enabled = checkwidth(),
  hl = {
    fg = gruvbox.green,
    bg = gruvbox.black,
    style = 'bold'
  }
}
-- diffModfified
components.left.active[7] = {
  provider = 'git_diff_changed',
  enabled = checkwidth(),
  hl = {
    fg = gruvbox.orange,
    bg = gruvbox.black,
    style = 'bold'
  }
}
-- diffRemove
components.left.active[8] = {
  provider = 'git_diff_removed',
  enabled = checkwidth(),
  hl = {
    fg = gruvbox.red,
    bg = gruvbox.black,
    style = 'bold'
  }
}
-- diagnosticErrors
components.left.active[9] = {
  provider = 'diagnostic_errors',
  enabled = function() return lsp.diagnostics_exist('Error') end,
  hl = {
    fg = gruvbox.red,
    style = 'bold'
  }
}
-- diagnosticWarn
components.left.active[10] = {
  provider = 'diagnostic_warnings',
  enabled = function() return lsp.diagnostics_exist('Warning') end,
  hl = {
    fg = gruvbox.yellow,
    style = 'bold'
  }
}
-- diagnosticHint
components.left.active[11] = {
  provider = 'diagnostic_hints',
  enabled = function() return lsp.diagnostics_exist('Hint') end,
  hl = {
    fg = gruvbox.cyan,
    style = 'bold'
  }
}
-- diagnosticInfo
components.left.active[12] = {
  provider = 'diagnostic_info',
  enabled = function() return lsp.diagnostics_exist('Information') end,
  hl = {
    fg = gruvbox.skyblue,
    style = 'bold'
  }
}

-- RIGHT

-- fileIcon
components.right.active[1] = {
  provider = function()
    local filename = vim.fn.expand('%:t')
    local extension = vim.fn.expand('%:e')
    local icon  = require'nvim-web-devicons'.get_icon(filename, extension, { default = true })
    return icon
  end,
  hl = {
    fg = gruvbox.white,
    bg = gruvbox.bg,
    style = 'bold'
  },
  right_sep = ' '
}
-- fileSize
components.right.active[2] = {
  provider = 'file_size',
  enabled = function() return vim.fn.getfsize(vim.fn.expand('%:t')) > 0 end,
  hl = {
    fg = gruvbox.skyblue,
    bg = gruvbox.bg,
    style = 'bold'
  },
  right_sep = ' '
}
-- rubyVersion
components.right.active[3] = {
  provider = function()
    return ' '..vim.fn['rvm#string']()
  end,
  hl = {
    fg = gruvbox.red,
    bg = gruvbox.bg,
    style = 'bold'
  },
  right_sep = ' '
}
-- fileEncode
components.right.active[4] = {
  provider = function ()
    local encode = vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc
    return ' ' .. encode:upper()
  end,
  hl = {
    fg = gruvbox.white,
    bg = gruvbox.bg,
    style = 'bold'
  },
  right_sep = ' '
}
-- fileFormat
components.right.active[5] = {
  provider = function() return vim.bo.fileformat:upper() end,
  hl = {
    fg = gruvbox.white,
    bg = gruvbox.bg,
    style = 'bold'
  },
  right_sep = ' '
}
-- lineInfo
components.right.active[6] = {
  provider = 'position',
  hl = {
    fg = gruvbox.white,
    bg = gruvbox.bg,
    style = 'bold'
  },
  right_sep = ' '
}
-- linePercent
components.right.active[7] = {
  provider = 'line_percentage',
  hl = {
    fg = gruvbox.white,
    bg = gruvbox.bg,
    style = 'bold'
  },
  right_sep = ' '
}
-- scrollBar
components.right.active[8] = {
  provider = 'scroll_bar',
  hl = {
    fg = gruvbox.yellow,
    bg = gruvbox.bg,
  },
}

require('feline').setup({
  colors = gruvbox,
  default_bg = gruvbox.bg,
  default_fg = gruvbox.fg,
  vi_mode_colors = vi_mode_colors,
  vi_mode_text = vi_mode_text,
  components = components,
  properties = properties,
})

