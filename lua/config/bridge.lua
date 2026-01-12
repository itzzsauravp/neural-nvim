local M = {}

function M.setup()
    -- Only run this if we are in WSL
    if vim.fn.has("wsl") == 1 then
        -- 1. Check for socat
        if vim.fn.executable("socat") == 0 then
            vim.notify("socat not found!", vim.log.levels.WARN)
            return
        end

        -- 2. KILL existing bridges to prevent "sloppy" behavior
        -- We kill both socat and npiperelay to ensure a fresh start
        vim.fn.system("pkill socat")
        -- Powershell kill for the Windows side relay
        vim.fn.system("powershell.exe -command \"Stop-Process -Name 'npiperelay' -ErrorAction SilentlyContinue\"")

        -- 3. REMOVE the old socket file
        vim.fn.system("rm -f /tmp/discord-ipc-0")

        -- 4. START the tunnel
        -- Note: We use the symlink name 'npiperelay.exe' since 'which' found it
        vim.fn.jobstart({
            "socat",
            "UNIX-LISTEN:/tmp/discord-ipc-0,fork,mode=777",
            "EXEC:npiperelay.exe -ep -s //./pipe/discord-ipc-0",
        }, { detach = true })
    end
end

-- Create the command for manual reset
vim.api.nvim_create_user_command("DiscordReset", function()
    M.setup()
    -- Trigger Cord to reconnect if it's already loaded
    if package.loaded["cord"] then
        vim.cmd("Cord reconnect")
    end
    print("Discord bridge refreshed!")
end, {})

return M
