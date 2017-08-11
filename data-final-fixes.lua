do
	local data = _G.data
	if data.is_demo then return end
	local fillRecipe = data.raw.recipe["fill-fish-water-barrel"]
	fillRecipe.ingredients = {
		{type = "fluid", name = "water", amount = 1 },
		{type = "item", name = "empty-barrel", amount = 1 },
		{type = "item", name = "raw-fish", amount = 1 },
	}
	local emptyRecipe = data.raw.recipe["empty-fish-water-barrel"]
	emptyRecipe.results = {
		{type = "fluid", name = "fish-water", amount = 1 },
		{type = "item", name = "empty-barrel", amount = 1 }
	}
end
