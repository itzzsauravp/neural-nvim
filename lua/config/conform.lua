return {
    formatters_by_ft = {
        javascript = { "biome", "prettier", stop_after_first = true },
        typescript = { "biome", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettier", stop_after_first = true },
        typescriptreact = { "biome", "prettier", stop_after_first = true },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },

        python = { "isort", "black" },

        c = { "clang-format" },
        cpp = { "clang-format" },

        odin = { "odin_fmt" },
    },
    format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
    },
}
