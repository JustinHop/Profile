-- battery monitor for one screen on one battery
if false then
batteries = 1

icon.bat = widget({ type = "imagebox", align = "right" })
icon.bat.image = image("/home/justin/.config/awesome/icons/tux-system/battery.png")

-- Function to extract charge percentage
function read_battery_life(number)
   return function(format)
             local fh = io.popen('acpi')
             local output = fh:read("*a")
             fh:close()

             count = 0
             for s in string.gmatch(output, "(%d+)%%") do
                if number == count then
                   return {s}
                end
                count = count + 1
             end
          end
end

-- Display one vertical progressbar per battery
for battery=0, batteries-1 do
   batterygraphwidget = widget({ type = 'progressbar',
                                 name = 'batterygraphwidget',
                                 align = 'right' })
   batterygraphwidget.height = 1
   batterygraphwidget.width = 8
   batterygraphwidget.bg = '#333333'
   batterygraphwidget.border_color = '#0a0a0a'
   batterygraphwidget.vertical = true
   batterygraphwidget:bar_properties_set('battery',
                                         { fg = '#AEC6D8',
                                           fg_center = '#285577',
                                           fg_end = '#285577',
                                           fg_off = '#222222',
                                           vertical_gradient = true,
                                           horizontal_gradient = false,
                                           ticks_count = 0,
                                           ticks_gap = 0 })

   wicked.register(batterygraphwidget, read_battery_life(battery), '$1', 1, 'battery')
end
included.bat = 1;
end
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80:foldmethod=marker
