local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    -- Snippet para Conceptos (Escribe 'callc' + Tab)
    s("callc", fmt([[
  > [!ABSTRACT] 🧠 Concepto Clave
  > {}
  ]], { i(1, "Descripción del concepto...") })),

    -- Snippet para Objetivos (Escribe 'callo' + Tab)
    s("callo", fmt([[
  > [!TIP] 🎯 Objetivo / Foco
  > {}
  ]], { i(1, "Cuál es la meta aquí...") })),

    -- Snippet para Comandos (Escribe 'callcmd' + Tab)
    s("callcmd", fmt([[
  > [!EXAMPLE] 💻 Comandos
  > ```bash
  > {}
  > ```
  ]], { i(1, "comando aquí") })),

    -- Snippet para Peligro/Nota (Escribe 'calld' + Tab)
    s("calld", fmt([[
  > [!DANGER] ⚠️ Cuidado
  > {}
  ]], { i(1, "Advertencia...") })),

    -- Snippet para insertar imagen desde HELPERS/Images (Escribe 'imgh' + Tab)
    s("imgh", {
        t("!["),
        i(1, "descripción"),
        t("](/home/jorgerios/obsidian-vault/HELPERS/Images/"),
        i(2, "nombre-imagen.png"),
        t(")"),
        i(0)
    }),
}
