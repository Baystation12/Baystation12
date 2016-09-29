/obj/item/device/assembly_holder/grenade/chem_grenade
	name = "grenade casing"
	icon_state = "chemg"
	item_state = "grenade"
	desc = "A hand made chemical grenade."
	w_class = 2.0
	force = 2.0
	default_grenade = 0
	pulse_chance = 75

/obj/item/device/assembly_holder/grenade/chem_grenade/New()
	trigger = new /obj/item/device/assembly/button (src)
	detonator = new /obj/item/device/assembly/timer (src)
	igniter = null
	explosive = new /obj/item/device/assembly/chem_mixer (src)
	..()

/obj/item/device/assembly_holder/grenade/chem_grenade/prime() // Again, leaving this here for any old code that may use it.
	attack_self()

/obj/item/device/assembly_holder/grenade/chem_grenade/metalfoam
	name = "metal-foam grenade"
	desc = "Used for emergency sealing of air breaches."

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("aluminum", 30)
		B2.reagents.add_reagent("foaming_agent", 10)
		B2.reagents.add_reagent("pacid", 10)

		var/obj/item/device/assembly/chem_mixer/E = explosive
		E.attach_container(B1)
		E.attach_container(B2)
		icon_state = initial(icon_state) +"_locked"

/obj/item/device/assembly_holder/grenade/chem_grenade/incendiary
	name = "incendiary grenade"
	desc = "Used for clearing rooms of living things."

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("aluminum", 15)
		B1.reagents.add_reagent("fuel",20)
		B2.reagents.add_reagent("phoron", 15)
		B2.reagents.add_reagent("sacid", 15)
		B1.reagents.add_reagent("fuel",20)

		var/obj/item/device/assembly/chem_mixer/E = explosive
		E.attach_container(B1)
		E.attach_container(B2)
		icon_state = initial(icon_state) +"_locked"

/obj/item/device/assembly_holder/grenade/chem_grenade/antiweed
	name = "weedkiller grenade"
	desc = "Used for purging large areas of invasive plant species. Contents under pressure. Do not directly inhale contents."

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("plantbgone", 25)
		B1.reagents.add_reagent("potassium", 25)
		B2.reagents.add_reagent("phosphorus", 25)
		B2.reagents.add_reagent("sugar", 25)

		var/obj/item/device/assembly/chem_mixer/E = explosive
		E.attach_container(B1)
		E.attach_container(B2)
		icon_state = "grenade"

/obj/item/device/assembly_holder/grenade/chem_grenade/cleaner
	name = "cleaner grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("surfactant", 40)
		B2.reagents.add_reagent("water", 40)
		B2.reagents.add_reagent("cleaner", 10)

		var/obj/item/device/assembly/chem_mixer/E = explosive
		E.attach_container(B1)
		E.attach_container(B2)
		icon_state = initial(icon_state) +"_locked"

/obj/item/device/assembly_holder/grenade/chem_grenade/teargas
	name = "tear gas grenade"
	desc = "Concentrated Capsaicin. Contents under pressure. Use with caution."

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/large/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/large/B2 = new(src)

		B1.reagents.add_reagent("phosphorus", 40)
		B1.reagents.add_reagent("potassium", 40)
		B1.reagents.add_reagent("condensedcapsaicin", 40)
		B2.reagents.add_reagent("sugar", 40)
		B2.reagents.add_reagent("condensedcapsaicin", 80)

		var/obj/item/device/assembly/chem_mixer/E = explosive
		E.attach_container(B1)
		E.attach_container(B2)
		icon_state = initial(icon_state) +"_locked"
