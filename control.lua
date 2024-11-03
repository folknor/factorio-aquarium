local ticker
do
	local function PUTFISHLOL(surface, tiles)
		local ent = surface.create_entity({
			name = "fish",
			position = tiles[math.random(1, #tiles)],
		})
		if ent and ent.valid then return true end
		return false
	end

	local acceptableLivingConditions = { "water-green", "water", "deepwater-green", "deepwater", }

	ticker = function(event)
		if event.tick % 120 == 0 then
			if not storage.ents or #storage.ents == 0 then
				-- rehash table just in cases - the extra s is for 'sausage'
				if storage.ents then storage.ents = {} end
				script.on_event(defines.events.on_tick, nil)
			else
				for i, ent in next, storage.ents do
					if ent.e and ent.e.valid and ent.e.fluidbox then
						for k = 1, #ent.e.fluidbox do
							local f = ent.e.fluidbox[k]
							if f and f.name == "fish-water" and f.amount > 0.99 then
								local amount = f.amount
								local tiles = ent.e.surface.get_connected_tiles(ent.pos, acceptableLivingConditions, true)
								if type(tiles) ~= "table" or #tiles == 0 then
									game.print({ "fishyfishyfishy.wtf", })
									table.remove(storage.ents, i)
									ent.e.destroy()
								else
									while amount > 0.99 do
										print(amount)
										PUTFISHLOL(ent.e.surface, tiles)
										amount = amount - 1
									end
									f.amount = math.max(amount, 0.0000001)
									ent.e.fluidbox[k] = f
									break
								end
							end
						end
					else
						-- Yes, we skip out early if we remove mid-table. #care
						table.remove(storage.ents, i)
					end
				end
			end
		end
	end
end

do
	local function enableRecipes(force, recipes)
		for _, r in next, recipes do
			if force.recipes[r] and force.recipes[r].valid then
				force.recipes[r].enabled = true
			end
		end
	end

	script.on_init(function()
		local recipes = {
			"fish-output",
			"fill-fish-water-barrel",
			"empty-fish-water-barrel",
		}
		for _, force in pairs(game.forces) do
			local t = force.technologies["fluid-handling"]
			if t and t.valid and t.researched then
				enableRecipes(force, recipes)
			end
		end

		if storage.ents and #storage.ents ~= 0 then
			script.on_event(defines.events.on_tick, ticker)
		end
	end)

	script.on_load(function()
		if storage.ents and #storage.ents ~= 0 then
			script.on_event(defines.events.on_tick, ticker)
		end
	end)
end


do
	local NAME = "fish-output"

	local function onBuilt(event)
		if not event or not event.entity or not event.entity.valid then return end
		if event.entity.name ~= NAME then return end
		local ent = event.entity
		local o = ent.orientation

		local scan = {}
		-- output = end stuck in ground
		if o == 0.5 then
			scan[1] = ent.position.x
			scan[2] = ent.position.y - 1
		elseif o == 0.75 then
			scan[1] = ent.position.x + 1
			scan[2] = ent.position.y
		elseif o == 0 then
			scan[1] = ent.position.x
			scan[2] = ent.position.y + 1
		elseif o == 0.25 then
			scan[1] = ent.position.x - 1
			scan[2] = ent.position.y
		end

		local surface = ent.surface
		if not surface or not surface.valid then return end

		local t = surface.get_tile(scan[1], scan[2])
		if (t.name ~= "water") and (t.name ~= "water-green") then
			-- Invalid tile placement, return to inventory.
			game.print({ "", "Someone tried to output fish-water on the ground. Unforgivable!", })
			ent.destroy()
			local p = event.player_index and game.players[event.player_index]
			if not p then p = event.robot.force.players[math.random(1, #event.robot.force.players)] end
			p.insert("fish-output")
			return
		end

		if not storage.ents then storage.ents = {} end
		ent.operable = false
		ent.rotatable = false

		-- They like going south. It feels like going downhill.
		table.insert(storage.ents, {
			e = ent,
			pos = scan,
			version = 1,
		})

		script.on_event(defines.events.on_tick, ticker)
	end

	script.on_event(defines.events.on_built_entity, onBuilt)
	script.on_event(defines.events.on_robot_built_entity, onBuilt)
end
