do
	local data = _G.data
	local fillRecipe = data.raw.recipe["fish-water-barrel"]
	fillRecipe.ingredients = {
		{ type = "fluid", name = "water",    amount = 10, },
		{ type = "item",  name = "barrel",   amount = 1, },
		{ type = "item",  name = "raw-fish", amount = 1, },
	}
	local emptyRecipe = data.raw.recipe["empty-fish-water-barrel"]
	emptyRecipe.results = {
		{ type = "fluid", name = "fish-water", amount = 10, },
		{ type = "item",  name = "barrel",     amount = 1, },
	}
end
