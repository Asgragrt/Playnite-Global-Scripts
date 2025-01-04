<#
    Script to open magpie given that the game has '[SW] Magpie' as a category.
#>

$magpiePath = "C:\Program Files\Magpie\Magpie.exe"

# Check if game requires scaling
$gameRequiresScaling = $Game.Categories.Name -contains "[SW] Magpie"
if (!$gameRequiresScaling) {
    Exit 0
}

Open-App $magpiePath "Magpie" "-t"