--
-- Script Lua pour Pandoc afin d'ajouter des lignes verticales aux tableaux en LaTeX
-- Auteur : Lilian Besson
-- Date : 21 septembre 2026
--
function Table(el)
  -- Injection de commandes LaTeX autour du tableau pour forcer l'affichage des bordures
  if FORMAT:match 'latex' then
    return {
      pandoc.RawBlock('latex', '\\begingroup\\drawstacklines'),
      el,
      pandoc.RawBlock('latex', '\\endgroup')
    }
  end
end
