import dracula.draw

config.load_autoconfig()

dracula.draw.blood(
    c,
    {
        'spacing': {'vertical': 6, 'horizontal': 8},
        'font': {'family': 'Hack, Menlo, Terminus, Monospace', 'size': 14},
    },
)

c.fonts.web.size.default = 18
c.fonts.web.size.default_fixed = 18
c.fonts.web.size.minimum = 18

