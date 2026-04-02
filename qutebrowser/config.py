import rosepine
# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig()

# set the palette you'd like to use
# valid options are 'rose-pine', 'rose-pine-moon' and 'rose-pine-dawn'
# last argument (optional, default is False): enable the plain look for the menu rows
rosepine.setup(c, 'rose-pine-moon', True)

c.fonts.default_family = ["JetBrains Mono Nerd Font"]
c.fonts.default_size = "11pt"
c.url.searchengines = {
    'DEFAULT':  'https://www.duckduckgo.com/?q={}',
    'aw':       'https://wiki.archlinux.org/?search={}',
    're':       'https://www.reddit.com/search/?q={}',
    'yt':       'https://www.youtube.com/results?search_query={}'
}

c.tabs.padding = {'bottom': 5, 'left': 10, 'right': 10, 'top': 5}
c.tabs.indicator.width = 1

c.statusbar.padding = {'bottom': 5, 'left': 10, 'right': 10, 'top': 5}

c.hints.radius = 4

c.content.user_stylesheets = "~/.config/qutebrowser/ddg-font.css"
