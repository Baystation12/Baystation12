
/obj/item/device/landmine/explosive
	name = "anti-personnel mine"
	desc = "A dangerous area denial device. Can be customised for various anti-personnel purposes."
	icon_state = "landmine4"
	state = STATE_INACTIVE

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent(/datum/reagent/glycerol, 26)
		B2.reagents.add_reagent(/datum/reagent/nitric_acid, 26)

		assembly = new/obj/item/device/assembly_holder/prox_igniter(src)

		beakers += B1
		beakers += B2
		overlays += "red"

/obj/item/device/landmine/emp
	name = "anti-personnel mine"
	desc = "A dangerous area denial device. Can be customised for various anti-personnel purposes."
	icon_state = "landmine4"
	state = STATE_INACTIVE

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/large/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/large/B2 = new(src)

		B1.reagents.add_reagent(/datum/reagent/uranium, 100)
		B2.reagents.add_reagent(/datum/reagent/iron, 100)

		assembly = new/obj/item/device/assembly_holder/prox_igniter(src)

		beakers += B1
		beakers += B2
		overlays += "blue"

/obj/item/device/landmine/gas
	name = "anti-personnel mine"
	desc = "A dangerous area denial device. Can be customised for various anti-personnel purposes."
	icon_state = "landmine4"
	state = STATE_INACTIVE

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/large/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/large/B2 = new(src)

		B1.reagents.add_reagent(/datum/reagent/potassium, 25)
		B1.reagents.add_reagent(/datum/reagent/toxin, 25)
		B1.reagents.add_reagent(/datum/reagent/capsaicin/condensed, 10)
		B2.reagents.add_reagent(/datum/reagent/sugar, 25)
		B2.reagents.add_reagent(/datum/reagent/phosphorus, 25)
		B2.reagents.add_reagent(/datum/reagent/capsaicin/condensed, 10)

		assembly = new/obj/item/device/assembly_holder/prox_igniter(src)

		beakers += B1
		beakers += B2
		overlays += "green"

/obj/item/device/landmine/frag
	name = "anti-personnel mine"
	desc = "A dangerous area denial device. Can be customised for various anti-personnel purposes."
	icon_state = "landmine4"
	state = STATE_INACTIVE

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent(/datum/reagent/glycerol, 25)
		B1.reagents.add_reagent(/datum/reagent/iron, 35)
		B2.reagents.add_reagent(/datum/reagent/nitric_acid, 25)
		B2.reagents.add_reagent(/datum/reagent/iron, 35)

		assembly = new/obj/item/device/assembly_holder/prox_igniter(src)

		beakers += B1
		beakers += B2
		overlays += "purple"

/obj/item/device/landmine/flash
	name = "anti-personnel mine"
	desc = "A dangerous area denial device. Can be customised for various anti-personnel purposes."
	icon_state = "landmine4"
	state = STATE_INACTIVE

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent(/datum/reagent/aluminum, 1)
		B2.reagents.add_reagent(/datum/reagent/potassium, 1)
		B2.reagents.add_reagent(/datum/reagent/sulfur, 1)

		assembly = new/obj/item/device/assembly_holder/prox_igniter(src)

		beakers += B1
		beakers += B2
		overlays += "white"

/obj/item/device/landmine/foam
	name = "anti-personnel mine"
	desc = "A dangerous area denial device. Can be customised for various anti-personnel purposes."
	icon_state = "landmine4"
	state = STATE_INACTIVE

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent(/datum/reagent/iron, 60)
		B2.reagents.add_reagent(/datum/reagent/foaming_agent, 20)
		B2.reagents.add_reagent(/datum/reagent/acid/polyacid, 20)

		assembly = new/obj/item/device/assembly_holder/prox_igniter(src)

		beakers += B1
		beakers += B2
		overlays += "brown"

/obj/item/device/landmine/flame
	name = "anti-personnel mine"
	desc = "A dangerous area denial device. Can be customised for various anti-personnel purposes."
	icon_state = "landmine4"
	state = STATE_INACTIVE

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent(/datum/reagent/aluminum, 40)
		B1.reagents.add_reagent(/datum/reagent/toxin/phoron, 20)
		B2.reagents.add_reagent(/datum/reagent/toxin/phoron, 20)
		B2.reagents.add_reagent(/datum/reagent/acid, 40)

		assembly = new/obj/item/device/assembly_holder/prox_igniter(src)

		beakers += B1
		beakers += B2
		overlays += "orange"

#undef STATE_INACTIVE
#undef STATE_ARMING
#undef STATE_ACTIVE
#undef STATE_WARNING
#undef STATE_DETONATE
