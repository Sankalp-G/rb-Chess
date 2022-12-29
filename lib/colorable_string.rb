# Adds color methods to the string class using refinements
# Inspired by dev.to blog created by Josh Smith
# https://dev.to/joshdevhub/terminal-colors-using-ruby-410p
module ColorableString
  RGB_COLOR_MAP = {
    black: '0;0;0',
    white: '202;144;100',
    dark_tile: '50;103;75',
    light_tile: '238;238;234',
    highlighted: '100;200;190',
    gray_highlight: '100;100;100',
    red_highlight: '230;100;100'
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

    def replace_bg_color(color)
      new_string = reset_bg_color.bg_color(color)
      replace(new_string)
    end

    def highlight
      replace_bg_color(:highlighted)
    end

    def reset_fg_color
      gsub!(/\e\[38.*?m/, '')
    end

    def reset_bg_color
      gsub!(/\e\[48.*?m/, '')
    end
  end
end
