/var/datum/xgm_gas_data/gas_data

/datum/xgm_gas_data
	//Simple list of all the gas IDs.
	var/list/gases = list()
	//The friendly, human-readable name for the gas.
	var/list/name = list()
	//Specific heat of the gas.  Used for calculating heat capacity.
	var/list/specific_heat = list()
	//Molar mass of the gas.  Used for calculating specific entropy.
	var/list/molar_mass = list()
	//Tile overlays.  /obj/effect/gas_overlay, created from references to 'icons/effects/tile_effects.dmi'
	var/list/tile_overlay = list()
	//Optional color for tile overlay
	var/list/tile_overlay_color = list()
	//Overlay limits.  There must be at least this many moles for the overlay to appear.
	var/list/overlay_limit = list()
	//Flags.
	var/list/flags = list()
	//Products created when burned. For fuel only for now (not oxidizers)
	var/list/burn_product = list()
	// Reagent created when inhaled by lungs.
	var/list/breathed_product = list()
	// Temperature in K that the gas will condense.
	var/list/condensation_points = list()
	// Reagent path resulting from condesation.
	var/list/condensation_products = list()
	//If it shouldn't autogenerate a codex entry
	var/list/hidden_from_codex = list()

/decl/xgm_gas
	var/id = ""
	var/name = "Unnamed Gas"
	var/specific_heat = 20	// J/(mol*K)
	var/molar_mass = 0.032	// kg/mol

	var/tile_overlay = "generic"
	var/tile_color = null
	var/overlay_limit = null

	var/flags = 0
	var/burn_product = "carbon_dioxide"
	var/breathed_product
	var/condensation_point = INFINITY
	var/condensation_product
	var/hidden_from_codex

/hook/startup/proc/generateGasData()
	gas_data = new
	for(var/p in (typesof(/decl/xgm_gas) - /decl/xgm_gas))
		var/decl/xgm_gas/gas = new p //avoid initial() because of potential New() actions

		if(gas.id in gas_data.gases)
			error("Duplicate gas id `[gas.id]` in `[p]`")

		gas_data.gases += gas.id
		gas_data.name[gas.id] = gas.name
		gas_data.specific_heat[gas.id] = gas.specific_heat
		gas_data.molar_mass[gas.id] = gas.molar_mass
		if(gas.overlay_limit) 
			gas_data.overlay_limit[gas.id] = gas.overlay_limit
			var/obj/effect/gas_overlay/I = new()
			if(gas.tile_overlay)
				I.icon_state = gas.tile_overlay
			if(gas.tile_color)
				gas_data.tile_overlay_color[gas.id] = gas.tile_color
				I.color = gas.tile_color
			gas_data.tile_overlay[gas.id] = I
		gas_data.flags[gas.id] = gas.flags
		gas_data.burn_product[gas.id] = gas.burn_product

		if(!isnull(gas.condensation_product) && !isnull(gas.condensation_point))
			gas_data.condensation_points[gas.id] = gas.condensation_point
			gas_data.condensation_products[gas.id] = gas.condensation_product

		gas_data.breathed_product[gas.id] = gas.breathed_product
		gas_data.hidden_from_codex[gas.id] = gas.hidden_from_codex

	return 1

/obj/effect/gas_overlay
	name = "gas"
	desc = "You shouldn't be clicking this."
	icon = 'icons/effects/tile_effects.dmi'
	icon_state = "generic"
	plane = EFFECTS_BELOW_LIGHTING_PLANE
	layer = FIRE_LAYER
	appearance_flags = RESET_COLOR
	mouse_opacity = 0

/obj/effect/gas_overlay/Initialize()
	. = ..()
	animate(src, alpha = 175, time = 10, easing = SINE_EASING | EASE_OUT, loop = -1)
	animate(alpha = 255, time = 10, easing = SINE_EASING | EASE_IN, loop = -1)