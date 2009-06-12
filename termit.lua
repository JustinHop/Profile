defaults = {}
defaults.windowTitle = 'Termit'
defaults.tabName = 'Terminal'
defaults.encoding = 'UTF-8'
defaults.wordChars = '+-AA-Za-z0-9,./?%&#:_~'
defaults.font = 'Monospace 11'
--defaults.foregroundColor = 'gray'
--defaults.backgroundColor = 'black'
defaults.showScrollbar = false
defaults.transparentBackground = true
defaults.transparentSaturation = 0.4
defaults.hideSingleTab = false
defaults.hideMenubar = true
defaults.fillTabbar = true
defaults.scrollbackLines = 4096
defaults.geometry = '1x1'
--defaults.allowChangingTitle = false
defaults.allowChangingTitle = true
defaults.changeTitle = function (title)
    print('title='..title)
    newTitle = 'Termit: '..title
    return newTitle
end
setOptions(defaults)

bindKey('Alt-Right', nextTab)
bindKey('Shift-Right', nextTab)
bindKey('Ctrl-Tab', nextTab)
bindKey('Alt-Left', prevTab)
bindKey('Shift-Left', prevTab)
bindKey('CtrlShift-Tab', prevTab)
bindKey('Ctrl-2', function () print('Hello2!') end)
bindKey('Ctrl-3', function () print('Hello3!') end)
bindKey('Ctrl-3', nil) -- remove previous binding
bindKey('Ctrl-w', nil)
bindKey('CtrlShift-w', closeTab)
bindKey('Ctrl-t', nil)
bindKey('CtrlShift-t', openTab)

setKbPolicy('keysym')

bindMouse('DoubleClick', openTab)

function onZsh()
    tabInfo = {}
    --tabInfo.name = 'Zsh tab'
    tabInfo.command = 'zsh'
    tabInfo.encoding = 'UTF-8'
    tabInfo.working_dir = '/tmp'
    openTab(tabInfo)
end
function onNamed()
    setTabName('New tab name')
end
function onClose()
    closeTab()
end
function onReconf()
    reconfigure()
end
function onSetColor()
    setColor('red')
end
-- 
userMenu = {}
mi = {}
mi.name = 'Close tab'
mi.action = 'onClose()'
table.insert(userMenu, mi)

mi = {}
mi.name = 'New tab name'
mi.action = 'onNamed()'
table.insert(userMenu, mi)

mi = {}
mi.name = 'Zsh tab'
mi.action = 'onZsh()'
table.insert(userMenu, mi)

mi = {}
mi.name = 'set red color'
mi.action = 'onSetColor()'
table.insert(userMenu, mi)

mi = {}
mi.name = 'Reconfigure'
mi.action = 'onReconf()'
table.insert(userMenu, mi)

function printTable(tbl, indent)
    for p in pairs(tbl) do
        if type(tbl[p]) == 'table' then
            print(indent..p..':')
            local_indent = indent..'  '
            printTable(tbl[p], local_indent)
        else
            print(indent..tostring(p)..'='..tostring(tbl[p]))
        end
    end
end
--printTable(userMenu, '')

-- list of available encodings
encodings = {'UTF-8', 'KOI8-R', 'CP1251', 'CP866'}

addMenu(userMenu, "User menu")
addPopupMenu(userMenu, "User menu")

encMenu = {}

for i, e in pairs(encodings) do 
    mi = {}
    mi.name = e
    mi.action = 'setEncoding("' .. e .. '")'
    table.insert(encMenu, mi)
end
addMenu(encMenu, "Encodings")
addPopupMenu(encMenu, "Encodings")


