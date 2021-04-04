-- Table Utilites
local function tsave(table,name)
    local file = fs.open(name,"w")
    file.write(textutils.serialize(table))
    file.close()
end
function tload(name)
    local file = fs.open(name,"r")
    local data = file.readAll()
    file.close()
    return textutils.unserialize(data)
end

-- First Time Setup
local function stup(stnum)
    if stnum == 1 then
        fs.makeDir("/cmdp/")
    elseif stnum == 2 then
        print("-----")
        print("CMD+ runs on modems, and so needs a channel to run on. Use any number, 0-65535, and make sure it doesn't conflict. Any CMD+ clients will need this number.")
        local cmdchannel = -1
        while cmdchannel > 65535 or cmdchannel < 0 or cmdchannel == nil do -- Fucking pointless indicators, it would work just as fine as while true, because for some damn reason the loop doesn't stop when IN THE PARAMETERS. Whatever.
            local input = read()
            local cmdchannel = tonumber(input)
            if cmdchannel ~= nil then
                if cmdchannel > -1 and cmdchannel < 65536 then
                    local cfg = {}
                    cfg["chan"] = cmdchannel
                    tsave(cfg,"/cmdp/cfg")
                    shell.run(shell.getRunningProgram())
                    break
                else
                    print("Not valid!")
                    local cmdchannel = -1
                end
            end
        end
    end
end

-- Begin
term.clear()
term.setCursorPos(1,1)
print("Remember: Your main CMD+ terminal should be in spawn chunks with an Ender Modem, so it can be accessed anywhere.")

-- Check if setup has been done before
if fs.exists("/cmdp/") == false then
    stup(1)
end
if fs.exists("/cmdp/cfg") == false then
    stup(2)
end
-- Rename to startup
shell.run("rename " .. shell.getRunningProgram() .. " /startup.lua")

-- Truly begin the program
-- Get modems and channel
local cfg = tload("/cmdp/cfg")
local modem = peripheral.find("modem")
if modem == nil then
    error("No modem!")
end
-- Open channel
modem.open(cfg.chan)