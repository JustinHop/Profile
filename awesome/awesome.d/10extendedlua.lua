function usefuleval(s)
    local f, err = loadstring("return "..s);
    if not f then
        f, err = loadstring(s);
    end
    
    if f then
        setfenv(f, _G);
        local ret = { pcall(f) };
        if ret[1] then
            -- Ok
            table.remove(ret, 1)
            local highest_index = #ret;
            for k, v in pairs(ret) do
                if type(k) == "number" and k > highest_index then
                    highest_index = k;
                end
                ret[k] = select(2, pcall(tostring, ret[k])) or "<no value>";
            end
            -- Fill in the gaps
            for i = 1, highest_index do
                if not ret[i] then
                    ret[i] = "nil"
                end
            end
            if highest_index > 0 then
                mypromptbox[mouse.screen].text = awful.util.escape("Result"..(highest_index > 1 and "s" or "")..": "..tostring(table.concat(ret, ", ")));
            else
                mypromptbox[mouse.screen].text = "Result: Nothing";
            end
        else
            err = ret[2];
        end
    end
    if err then
        mypromptbox[mouse.screen].text = awful.util.escape("Error: "..tostring(err));
    end
end

usefullua = 1
