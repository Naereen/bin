#!/usr/bin/env pandoc
--
-- Script Lua pour Pandoc afin de convertir les tableaux AST en tableaux LaTeX avec bordures
-- Auteur : Lilian Besson
--

function Table(tbl)
  if not FORMAT:match('latex') then
    return nil
  end

  local num_cols = #tbl.colspecs
  if num_cols == 0 then
    return nil
  end

  -- Construction du spécificateur de colonnes : |c|c|c|...|
  local col_spec = "|"
  for i = 1, num_cols do
    col_spec = col_spec .. "c|"
  end

  local latex_code = "\\begin{center}\n"
  latex_code = latex_code .. "\\begin{tabular}{" .. col_spec .. "}\n\\hline\n"

  -- 1. Traitement des en-têtes (tbl.head)
  if tbl.head and tbl.head.rows then
    for _, row in ipairs(tbl.head.rows) do
      local row_cells = {}
      for _, cell in ipairs(row.cells) do
        local text = pandoc.utils.stringify(cell.contents)
        table.insert(row_cells, "\\textbf{" .. text .. "}")
      end
      latex_code = latex_code .. table.concat(row_cells, " & ") .. " \\\\\n\\hline\n"
    end
  end

  -- 2. Traitement du corps du tableau (tbl.bodies)
  if tbl.bodies then
    for _, body in ipairs(tbl.bodies) do
      for _, row in ipairs(body.body) do
        local row_cells = {}
        for _, cell in ipairs(row.cells) do
          local text = pandoc.utils.stringify(cell.contents)
          table.insert(row_cells, text)
        end
        latex_code = latex_code .. table.concat(row_cells, " & ") .. " \\\\\n\\hline\n"
      end
    end
  end

  latex_code = latex_code .. "\\end{tabular}\n"
  latex_code = latex_code .. "\\end{center}"

  return pandoc.RawBlock('latex', latex_code)
end
