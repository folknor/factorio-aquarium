
do
	local data = _G.data
	if data.is_demo then return end

	local output = table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
	output.name = "fish-output"
	output.icon = "__folk-aquarium__/output.png"

	local outputItem = table.deepcopy(data.raw.item["pipe-to-ground"])
	outputItem.name = "fish-output"
	outputItem.place_result = "fish-output"
	outputItem.icon = "__folk-aquarium__/output.png"
	outputItem.stack_size = 1

	local outputRecipe = table.deepcopy(data.raw.recipe["pipe-to-ground"])
	outputRecipe.name = "fish-output"
	outputRecipe.ingredients = {
		{"pipe", 5},
		{"iron-plate", 3}
	}
	outputRecipe.result = "fish-output"
	outputRecipe.result_count = 1
	outputRecipe.enabled = false

	local fluid = table.deepcopy(data.raw.fluid.water)
	fluid.name = "fish-water"
	fluid.max_temperature = 30 -- dont torture the fish!
	fluid.icon = "__base__/graphics/icons/fish.png"
	fluid.gas_temperature = -1
	fluid.pressure_to_speed_ratio = 1
	fluid.flow_to_energy_ratio = 1

	table.insert(data.raw.technology["fluid-handling"].effects, {
		type = "unlock-recipe",
		recipe = "fish-output"
	})

	data:extend({
		fluid, output, outputItem, outputRecipe
	})
end
