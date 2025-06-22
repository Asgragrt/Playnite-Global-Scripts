<#
    Script to open magpie given that the game has '[SW] Magpie' as a category.
#>

$magpiePath = "C:\Program Files\Magpie\Magpie.exe"

# Check if game requires scaling
$gameRequiresScaling = $Game.Categories.Name -contains "[SW] Magpie"
if (!$gameRequiresScaling) {
    return
}

Open-App $magpiePath "Magpie" "-t"