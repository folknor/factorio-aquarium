do
	local data = _G.data

	local output = table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
	output.name = "fish-output"
	output.icon = "__folk-aquarium__/output.png"
	output.icon_size = 32
	output.minable.result = "fish-output"

	local outputItem = table.deepcopy(data.raw.item["pipe-to-ground"])
	outputItem.name = "fish-output"
	outputItem.place_result = "fish-output"
	outputItem.icon = "__folk-aquarium__/output.png"
	outputItem.icon_size = 32

	local outputRecipe = table.deepcopy(data.raw.recipe["pipe-to-ground"])
	outputRecipe.name = "fish-output"
	outputRecipe.icon_size = 32
	outputRecipe.results = { { type = "item", name = "fish-output", amount = 1, }, }
	outputRecipe.enabled = false

	local fluid = table.deepcopy(data.raw.fluid.water)
	fluid.name = "fish-water"
	fluid.max_temperature = 30 -- dont torture the fish!
	fluid.icon = "__base__/graphics/icons/fish.png"
	fluid.gas_temperature = 15

	table.insert(data.raw.technology["fluid-handling"].effects, {
		type = "unlock-recipe",
		recipe = "fish-output",
	})

	data:extend({
		fluid, output, outputItem, outputRecipe,
	})
end
