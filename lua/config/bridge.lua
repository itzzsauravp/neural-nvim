local M = {}

function M.setup()
    -- Only run this if we are in WSL
    if vim.fn.has("wsl") == 1 then
        -- Check if socat is installed
        if vim.fn.executable("socat") == 0 then
            vim.notify("socat not found! Install with: sudo apt install socat", vim.log.levels.WARN)
            return
        end

        -- The "Magic" Command
        -- It listens on the Linux side (/tmp/discord-ipc-0)
        -- and pipes it to the Windows side (//./pipe/discord-ipc-0)
        vim.fn.jobstart({
            "socat",
            "UNIX-LISTEN:/tmp/discord-ipc-0,fork,group=vboxsf,mode=777",
            "EXEC:npiperelay.exe -ep -s //./pipe/discord-ipc-0",
        }, { detach = true })
    end
end

return M
