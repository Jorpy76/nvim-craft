return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" }, -- "Avante" es para plugins de IA, bien mantenido
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },

    opts = {
        -- 1. BLOQUES DE CÓDIGO (Estilo "Caja Sólida")
        code = {
            enabled = true,
            sign = true,      -- Icono del lenguaje (ej. 🐍 para Python)
            style = 'full',   -- Fondo completo (como en Obsidian)
            width = 'block',  -- Ancho completo
            left_pad = 2,     -- Espacio interno a la izquierda
            right_pad = 2,    -- Espacio interno a la derecha
            border = 'thick', -- Un borde sutil alrededor del código
        },

        -- 2. CABECERAS (Tus iconos personalizados + Fondo sutil)
        heading = {
            sign = false, -- Oculta los '##'
            icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
            -- Opcional: Colorea toda la línea del título (estilo Notion/Obsidian)
            -- backgrounds = { "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg" },
        },

        -- 3. CALLOUTS (¡La parte más importante para estudiar!)
        -- Aquí traducimos tus [!TAGS] a iconos y colores bonitos
        callout = {
            note     = { raw = "[!NOTE]", rendered = "󰋽 Nota", highlight = "RenderMarkdownInfo" },
            tip      = { raw = "[!TIP]", rendered = "🎯 Objetivo/Tip", highlight = "RenderMarkdownSuccess" },
            warning  = { raw = "[!WARNING]", rendered = " Cuidado", highlight = "RenderMarkdownWarn" },
            danger   = { raw = "[!DANGER]", rendered = "󰳤 Peligro", highlight = "RenderMarkdownError" },
            -- Estos dos son CLAVES para tus snippets de HTB:
            abstract = { raw = "[!ABSTRACT]", rendered = "🧠 Concepto Clave", highlight = "RenderMarkdownCyan" },
            example  = { raw = "[!EXAMPLE]", rendered = "💻 Comandos/Terminal", highlight = "RenderMarkdownHint" },
            quote    = { raw = "[!QUOTE]", rendered = "❝ Cita", highlight = "RenderMarkdownQuote" },
        },

        -- 4. CHECKBOXES (Para tus listas de tareas)
        checkbox = {
            enabled = true,
            position = 'inline',
            custom = {
                todo = { raw = "[-]", rendered = "󰥔 " }, -- Pendiente
                done = { raw = "[x]", rendered = " " }, -- Hecho (Check verde)
            },
        },

        -- 5. COMPORTAMIENTO (Anti-Conceal es magia)
        -- Esto hace que los símbolos se oculten para leer, PERO aparezcan
        -- cuando pones el cursor encima para editar.
        anti_conceal = {
            enabled = true,
            ignore = { 'code_background' }, -- No quita el fondo del código al editar
        },

        file_types = { "markdown", "Avante" },
        render_modes = { "n", "c", "i" }, -- Funciona en modos Normal y Insertar
    },
}
