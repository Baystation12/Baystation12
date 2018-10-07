// Lots of repeated vars and procs because isScrewdriver() etc are just istype checks.
/obj/item/weapon/weldingtool/crystal
	name = "crystalline arc welder"
	desc = "A crystalline welding tool of an alien make."
	icon_state = "crystal_welder"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	welding_resource = "stored charge"
	tank = null
	matter = list(MATERIAL_CRYSTAL = 1250)
	waterproof = TRUE

/obj/item/weapon/weldingtool/crystal/attackby(var/obj/item/W, var/mob/user)
	if(isScrewdriver(W) || istype(W,/obj/item/stack/rods) || istype(W, /obj/item/weapon/welder_tank))
		return
	. = ..()

/obj/item/weapon/weldingtool/crystal/afterattack(var/obj/O, var/mob/user, var/proximity)
	if(proximity && istype(O, /obj/structure/reagent_dispensers/fueltank))
		if(!welding)
			to_chat(user, "<span class='warning'>\The [src] runs on the wielder's internal charge and does not need to be refuelled.</span>")
		return
	. = ..()

/obj/item/weapon/weldingtool/crystal/on_update_icon()
	icon_state = welding ? "crystal_welder_on" : "crystal_welder"
	item_state = welding ? "crystal_tool_lit"  : "crystal_tool"
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/weapon/weldingtool/crystal/get_fuel()
	var/amount = 0
	var/mob/living/carbon/human/adherent = loc
	if(istype(adherent))
		for(var/obj/item/organ/internal/cell/cell in adherent.internal_organs)
			if(!cell.is_broken())
				amount += cell.get_charge()
	return amount

/obj/item/weapon/weldingtool/crystal/show_fuel(var/mob/user)
	to_chat(user, "<span class='notice'>It contains [get_fuel()]W of charge.</span>")

/obj/item/weapon/weldingtool/crystal/burn_fuel(var/amount)
	var/mob/living/carbon/human/adherent = loc
	if(istype(adherent))
		for(var/obj/item/organ/internal/cell/cell in adherent.internal_organs)
			if(!cell.is_broken() && cell.get_charge() >= amount)
				var/spending = min(amount, cell.get_charge())
				cell.use(spending)
				amount -= spending

	var/turf/location
	if(isturf(loc))
		location = loc
	else if(isliving(loc))
		var/mob/living/M = loc
		if(isturf(M.loc) && (M.l_hand == src || M.r_hand == src))
			location = M.loc

	if(location)
		location.hotspot_expose(700, 5)

/obj/item/weapon/wirecutters/crystal
	name = "crystalline shears"
	desc = "A crystalline shearing tool of an alien make."
	icon_state = "crystal_wirecutter"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	matter = list(MATERIAL_CRYSTAL = 1250)

/obj/item/weapon/wirecutters/crystal/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)

/obj/item/weapon/screwdriver/crystal
	name = "crystalline screwdriver"
	desc = "A crystalline screwdriving tool of an alien make."
	icon_state = "crystal_screwdriver"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	matter = list(MATERIAL_CRYSTAL = 1250)

/obj/item/weapon/screwdriver/crystal/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)

/obj/item/weapon/crowbar/crystal
	name = "crystalline prytool"
	desc = "A crystalline prying tool of an alien make."
	icon_state = "crystal_crowbar"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	matter = list(MATERIAL_CRYSTAL = 1250)

/obj/item/weapon/crowbar/crystal/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)

/obj/item/weapon/wrench/crystal
	name = "crystalline wrench"
	desc = "A crystalline wrenching tool of an alien make."
	icon_state = "crystal_wrench"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	matter = list(MATERIAL_CRYSTAL = 1250)

/obj/item/weapon/wrench/crystal/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)

/obj/item/device/multitool/crystal
	name = "crystalline multitool"
	desc = "A crystalline energy patterning tool of an alien make."
	icon_state = "crystal_multitool"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	matter = list(MATERIAL_CRYSTAL = 1250)

/obj/item/weapon/storage/belt/utility/vigil
	name = "tool harness"
	desc = "A segmented belt of strange crystalline material."
	icon_state = "vigil"
	item_state = "vigil"

/obj/item/weapon/storage/belt/utility/vigil/Initialize()
	new /obj/item/device/multitool/crystal(src)
	new /obj/item/weapon/wrench/crystal(src)
	new /obj/item/weapon/crowbar/crystal(src)
	new /obj/item/weapon/screwdriver/crystal(src)
	new /obj/item/weapon/wirecutters/crystal(src)
	new /obj/item/weapon/weldingtool/crystal(src)
	update_icon()
	. = ..()
