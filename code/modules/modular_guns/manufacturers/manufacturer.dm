var/list/weapon_manufacturers = list()

/proc/get_manufacturer_by_path(var/gun_path)
	if(!weapon_manufacturers[gun_path])
		weapon_manufacturers[gun_path] = new gun_path
	return weapon_manufacturers[gun_path]

/decl/weapon_manufacturer

	// Strings and appearance info.
	var/manufacturer_name = "unbranded"
	var/manufacturer_description = "Custom-built and ramshackle components are common across most of human space."
	var/manufacturer_short = "unbranded"
	var/casing_desc = "The casing is unpainted, unpolished metal."

	// Combat data. Multiplies the associated variables on the finished gun.
	var/accuracy   // Modifies accuracy
	var/capacity   // Modifies initial charge and casing capacity.
	var/damage_mod // Modifies damage of outgoing projectiles.
	var/recoil     // Modifies recoil.
	var/fire_rate  // Modifies fire delay.
	var/weight     // Modifies w_class.

