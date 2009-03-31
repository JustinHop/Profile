-------------------------------------------------------------------------------
---- @file rc.lua
---- @author Justin Hoppensteadt &lt;awesome@justinhoppensteadt.com&gt;
---- based on script by Matthew Wild &lt;mwild1@gmail.com&gt;
---------------------------------------------------------------------------------

myconfs = { "include", "background", "env", "tags", "wibox", "mouse", "keys", "hooks" };
local f = io.open(os.getenv("HOME").."/.awesome.err", "a+")
f:write( "\n\n", os.date("%c"), "\t----Awesome starting up -----------------------\n");
 
for i = 1, #myconfs do
    local tryfile = (os.getenv("HOME") .. "/.config/awesome/" .. myconfs[i] .. ".lua" );
    f:write(os.date("%c"), ":\tCompiling:\t",tryfile,"\n");

    local rc, err = loadfile(tryfile);
    if rc then
        rc, err = pcall(rc);
        if rc then
            f:write(os.date("%c"), ":\tExecuting:\t",tryfile,"\n");
        else
            f:write(os.date("%c"), ":\tExecution FAILED:\t",tryfile,"\nERROR:",err,"\n",
                "!!!!!!!!! Falling back to default install\n");
            dofile("/etc/xdg/awesome/rc.lua");
            return;
        end
    else
        f:write(os.date("%c"), ":\tCompilation FAILED:\t",tryfile,"\nERROR:",err,"\n",
        "!!!!!!!!! Falling back to default install\n");
        dofile("/etc/xdg/awesome/rc.lua");
        return;
    end
end

--for s = 1,screen.count() do
    --mypromptbox[s].text = awful.util.escape(err:match("[^\n]*"));
--end
-- f:write("Awesome crashed during startup on ", os.date("%B %d, %H:%M:\n\n").. " in file " .. rc);
-- f:write(erro, "\n");

-- dofile("/etc/xdg/awesome/rc.lua");
f:close();

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
