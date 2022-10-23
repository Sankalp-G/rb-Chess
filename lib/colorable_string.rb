# Adds color methods to the string class using refinements
# Inspired by dev.to blog created by Josh Smith
# https://dev.to/joshdevhub/terminal-colors-using-ruby-410p
module ColorableString
  RGB_COLOR_MAP = {
    black: '0;0;0',
    white: '202;144;100',
    dark_tile: '50;103;75',
    light_tile: '238;238;234',
    highlighted: '197;211;157'
  }.freeze

  refine String do
    def fg_color(color_name)
      rgb_val = RGB_COLOR_MAP[color_name]
      str = gsub("\e[0m", '')
      "\e[38;2;#{rgb_val}m#{str}\e[0m"
    end

    def bg_color(color_name)
      rgb_val = RGB_COLOR_MAP[color_name]
      str = gsub("\e[0m", '')
      "\e[48;2;#{rgb_val}m#{str}\e[0m"
    end

    def highlight
      bg_color(:highlighted)
    end
  end
end
