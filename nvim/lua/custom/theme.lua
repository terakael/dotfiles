-- Machine-specific theme configuration
-- Loads local-theme (e.g. Omarchy theme) if available, otherwise falls back to fallback-theme (everforest)

local ok, local_theme = pcall(require, 'custom.local-theme')
if ok and local_theme then
  return local_theme
end

return require 'custom.fallback-theme'
