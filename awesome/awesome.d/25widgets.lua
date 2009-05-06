

volwidget = widget({ type = 'progressbar', name = 'volwidget', align = 'right' })
volwidget.height = 1
volwidget.width = 8
volwidget.bg = '#33333355'
volwidget.border_color = '#0a0a0a'
volwidget.vertical = true
volwidget:bar_properties_set('vol',
    { fg = '#AED8C6',
        fg_center = '#287755',
        fg_end = '#287755',
        fg_off = '#222222',
        vertical_gradient = true,
        horizontal_gradient = false,
        ticks_count = 0,
        ticks_gap = 0 })

bw=1;
