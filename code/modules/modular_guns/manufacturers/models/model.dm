var/list/weapon_models = list()

/proc/get_gun_model_by_path(var/gun_path)
	if(!weapon_models[gun_path])
		weapon_models[gun_path] = new gun_path
	return weapon_models[gun_path]

/decl/weapon_model
	var/force_gun_name                                                 // If set, overrides generated gun name.
	var/model_name = ""                                                // Extended model name, shown in desc.
	var/model_desc = ""                                                // Gun description.
	var/producer_path = /decl/weapon_manufacturer                      // Path to gun manufacturer.
	var/decl/weapon_manufacturer/produced_by                           // Reference to gun manufacturer.

	var/use_icon = 'icons/obj/gun_components/generic_model.dmi'        // Icon used for components of this model.
	var/accessory_icon = 'icons/obj/gun_components/accessories.dmi'    // Icon used for accessories on a gun of this model.
	var/ammo_indicator_icon                                            // Icon used for ammo indicator.
	var/ammo_use_state                                                 // Ammo state override.
	var/ammo_indicator_states                                          // Number of intermediary states.
	var/force_item_state                                               // State used for inhands.

/decl/weapon_model/New()
	..()
	if(producer_path)
		produced_by = get_manufacturer_by_path(producer_path)