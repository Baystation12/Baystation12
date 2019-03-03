//vox got different organs within. This will also help with regular surgeons knowing the organs within an alien as alien as vox.
/obj/item/organ/internal/heart/vox
	icon_state = "vox heart"
	dead_icon = null
	parent_organ = BP_GROIN

/obj/item/organ/internal/lungs/vox
	name = "air capillary sack" //Like birds, Vox absorb gas via air capillaries.
	icon_state = "vox lung"

/obj/item/organ/internal/kidneys/vox
	name = "filtration bladder"
	icon_state = "lungs" //wow are vox kidneys fat.
	color = "#99ccff"
	parent_organ = BP_CHEST

/obj/item/organ/internal/liver/vox
	name = "waste tract"
	parent_organ = BP_CHEST
	color = "#0033cc"

/obj/item/organ/internal/stomach/vox
	name = "gizzard"
	color = "#0033cc"
	var/list/gains_nutriment_from_inedible_reagents = list(
		/datum/reagent/woodpulp =      3,
		/datum/reagent/anfo/plus =     2,
		/datum/reagent/ultraglue =     1,
		/datum/reagent/anfo =          1,
		/datum/reagent/coolant =       1,
		/datum/reagent/lube =          1,
		/datum/reagent/lube/oil =      1,
		/datum/reagent/space_cleaner = 1,
		/datum/reagent/napalm =        1,
		/datum/reagent/napalm/b =      1,
		/datum/reagent/thermite =      1,
		/datum/reagent/foaming_agent = 1,
		/datum/reagent/surfactant =    1,
		/datum/reagent/paint =         1
	)

/obj/item/organ/internal/stomach/vox/Process()
	. = ..()
	if(is_usable() && ingested.total_volume > 0)
		for(var/datum/reagent/R in ingested.reagent_list)
			var/inedible_nutriment_amount = gains_nutriment_from_inedible_reagents[R.type]
			if(inedible_nutriment_amount > 0)
				owner.nutrition += inedible_nutriment_amount

/obj/item/organ/internal/stack/vox
	name = "cortical stack"
	invasive = 1

/obj/item/organ/internal/stack/vox/removed()
	var/obj/item/organ/external/head = owner.get_organ(parent_organ)
	owner.visible_message("<span class='danger'>\The [src] rips gaping holes in \the [owner]'s [head.name] as it is torn loose!</span>")
	head.take_external_damage(rand(15,20))
	for(var/obj/item/organ/internal/O in head.contents)
		O.take_internal_damage(rand(30,70))
	..()
