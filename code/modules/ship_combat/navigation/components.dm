/obj/item/weapon/component
	name = "component"
	desc = "A necessary component."

	var/tier = 1


//ECM
/obj/item/weapon/component/ecm
	name = "ECM Dish"
	desc = "The primary machinery for ECM."
	var/idle_power_usage = 750

/obj/item/weapon/component/ecm/compacted
	name = "Compacted ECM Dish"
	desc = "The primary machinery for ECM. This one is compacted and thus more efficient."
	idle_power_usage = 600
	tier = 2

/obj/item/weapon/component/ecm/sonic
	name = "Sonic ECM Dish"
	desc = "The primary machinery for ECM. This one uses sonic waves, and is thus more efficient."
	idle_power_usage = 500
	tier = 3

/obj/item/weapon/component/ecm/ionic
	name = "Ionic ECM Dish"
	desc = "The primary machinery for ECM. This one uses ionic signals, and is thus more efficient."
	idle_power_usage = 350
	tier = 4
// Shields
/obj/item/weapon/component/shield
	name = "Shielding Capacitor"
	desc = "A shielding capacitor."
	var/stored_power = 50000

	compact
		name = "Compacted Shielding Capacitor"
		desc = "A shielding capacitor. This one is compacted, allowing 200% capacity."
		stored_power = 100000
		tier = 2

	nuclear
		name = "Nuclear Shielding Capacitor"
		desc = "A shielding capacitor. This one uses ionised uranium as power storage, allowing 300% capacity"
		stored_power = 150000
		tier = 3

	fission
		name = "Fission Shielding Capacitor"
		desc = "A shielding capacitor. This one uses positively charged hydrogen as power storage, allowing 500% capacity"
		stored_power = 250000
		tier = 4

//Engines
/obj/item/weapon/component/engine
	name = "engine"
	desc = "An engine component."
	var/mod = 0.2

	ion
		name = "electrical ion engine"
		desc = "An electrical ion drive, runs off of electricity."

		ion_pulse
			name = "electrical ion pulse engine"
			desc = "An electrical ion pulse engine, more efficienct than an ion engine."
			tier = 2
			mod = 0.4

	fuel
		name = "liquid fuel	engine"
		desc = "A liquid fuel engine, runs off of liquid fuel."

		compressed_fuel
			name = "compressed liquid fuel engine"
			desc = "A compressed liquid fuel engine, more efficient than a liquid fuel engine."
			tier = 2
			mod = 0.4

		magneto
			name = "magneto liquid fuel engine"
			desc = "A magneto liquid fuel egnine, more efficient than a compressed liquid fuel engine."
			tier = 3
			mod = 0.6



