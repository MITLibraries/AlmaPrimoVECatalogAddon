RegEx = {};

local function Match(pattern, text)
    local types = {};
    types["Regex"] = luanet.import_type("System.Text.RegularExpressions.Regex");
    
    local regex = types["Regex"](pattern);
    return regex:Match(text);
end

RegEx.Match = Match;
