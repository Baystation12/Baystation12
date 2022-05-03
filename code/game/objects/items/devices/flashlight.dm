#define FLASHLIGHT_ALWAYS_ON FLAG(0)
#define FLASHLIGHT_SINGLE_USE FLAG(1)
#define FLASHLIGHT_CANNOT_BLIND FLAG(2)

/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT

	matter = list(MATERIAL_PLASTIC = 50, MATERIAL_GLASS = 20)

	action_button_name = "Toggle Flashlight"
	var/on = FALSE
	var/activation_sound = 'sound/effects/flashlight.ogg'
	var/flashlight_max_bright = 0.5 //brightness of light when on, must be no greater than 1.
	var/flashlight_inner_range = 1 //inner range of light when on, can be negative
	var/flashlight_outer_range = 3 //outer range of light when on, can be negative
	var/flashlight_flags = EMPTY_BITFIELD // FLASHLIGHT_ bitflags

/obj/item/device/flashlight/Initialize()
	. = ..()

	set_flashlight()
	update_icon()

/obj/item/device/flashlight/on_update_icon()
	if (flashlight_flags & FLASHLIGHT_ALWAYS_ON)
		return // Prevent update_icon shennanigans with objects that won't have on/off variant sprites

	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/device/flashlight/attack_self(mob/user)
	if (flashlight_flags & FLASHLIGHT_ALWAYS_ON)
		to_chat(user, "You cannot toggle the [name].")
		return 0

	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the [name] on while in this [user.loc].")//To prevent some lighting anomalities.
		return 0

	if (flashlight_flags & FLASHLIGHT_SINGLE_USE && on)
		to_chat(user, "The [name] is already lit.")
		return 0

	on = !on
	if(on && activation_sound)
		playsound(get_turf(src), activation_sound, 75, 1)
	set_flashlight()
	update_icon()
	user.update_action_buttons()
	return 1

/obj/item/device/flashlight/proc/set_flashlight()
	if (on)
		set_light(flashlight_max_bright, flashlight_inner_range, flashlight_outer_range, 2, light_color)
	else
		set_light(0)

/obj/item/device/flashlight/attack(mob/living/M as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(on && user.zone_sel.selecting == BP_EYES)

		if((MUTATION_CLUMSY in user.mutations) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(H))
			for(var/obj/item/clothing/C in list(H.head,H.wear_mask,H.glasses))
				if(istype(C) && (C.body_parts_covered & EYES))
					to_chat(user, "<span class='warning'>You're going to need to remove [C] first.</span>")
					return

			var/obj/item/organ/vision
			if(!H.species.vision_organ || !H.should_have_organ(H.species.vision_organ))
				to_chat(user, "<span class='warning'>You can't find anything on [H] to direct [src] into!</span>")
				return

			vision = H.internal_organs_by_name[H.species.vision_organ]
			if(!vision)
				vision = H.species.has_organ[H.species.vision_organ]
				to_chat(user, "<span class='warning'>\The [H] is missing \his [initial(vision.name)]!</span>")
				return

			user.visible_message("<span class='notice'>\The [user] directs [src] into [M]'s [vision.name].</span>", \
								 "<span class='notice'>You direct [src] into [M]'s [vision.name].</span>")

			inspect_vision(vision, user)

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //can be used offensively
			if (!(flashlight_flags & FLASHLIGHT_CANNOT_BLIND))
				M.flash_eyes()
	else
		return ..()

/obj/item/device/flashlight/proc/inspect_vision(obj/item/organ/vision, mob/living/user)
	var/mob/living/carbon/human/H = vision.owner

	if(H == user)	//can't look into your own eyes buster
		return

	if(!BP_IS_ROBOTIC(vision))

		if(vision.owner.stat == DEAD || H.blinded)	//mob is dead or fully blind
			to_chat(user, "<span class='warning'>\The [H]'s pupils do not react to the light!</span>")
			return
		if(MUTATION_XRAY in H.mutations)
			to_chat(user, "<span class='notice'>\The [H]'s pupils give an eerie glow!</span>")
		if(vision.damage)
			to_chat(user, "<span class='warning'>There's visible damage to [H]'s [vision.name]!</span>")
		else if(H.eye_blurry)
			to_chat(user, "<span class='notice'>\The [H]'s pupils react slower than normally.</span>")
		if(H.getBrainLoss() > 15)
			to_chat(user, "<span class='notice'>There's visible lag between left and right pupils' reactions.</span>")

		var/list/pinpoint = list(/datum/reagent/tramadol/oxycodone=1,/datum/reagent/tramadol=5)
		var/list/dilating = list(/datum/reagent/space_drugs=5,/datum/reagent/mindbreaker=1,/datum/reagent/adrenaline=1)
		var/datum/reagents/ingested = H.get_ingested_reagents()
		if(H.reagents.has_any_reagent(pinpoint) || ingested.has_any_reagent(pinpoint))
			to_chat(user, "<span class='notice'>\The [H]'s pupils are already pinpoint and cannot narrow any more.</span>")
		else if(H.shock_stage >= 30 || H.reagents.has_any_reagent(dilating) || ingested.has_any_reagent(dilating))
			to_chat(user, "<span class='notice'>\The [H]'s pupils narrow slightly, but are still very dilated.</span>")
		else
			to_chat(user, "<span class='notice'>\The [H]'s pupils narrow.</span>")

	//if someone wants to implement inspecting robot eyes here would be the place to do it.

/obj/item/device/flashlight/upgraded
	name = "\improper LED flashlight"
	desc = "An energy efficient flashlight."
	icon_state = "biglight"
	item_state = "biglight"
	flashlight_max_bright = 0.75
	flashlight_outer_range = 4

/obj/item/device/flashlight/flashdark
	name = "flashdark"
	desc = "A strange device manufactured with mysterious elements that somehow emits darkness. Or maybe it just sucks in light? Nobody knows for sure."
	icon_state = "flashdark"
	item_state = "flashdark"
	w_class = ITEM_SIZE_NORMAL
	flashlight_max_bright = -1
	flashlight_outer_range = 4
	flashlight_inner_range = 1
	flashlight_flags = FLASHLIGHT_CANNOT_BLIND

/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = ""
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_EARS
	w_class = ITEM_SIZE_TINY
	flashlight_max_bright = 0.25
	flashlight_inner_range = 0.1
	flashlight_outer_range = 2

/obj/item/device/flashlight/maglight
	name = "maglight"
	desc = "A very, very heavy duty flashlight."
	icon_state = "maglight"
	item_state = "maglight"
	force = 10
	base_parry_chance = 15
	attack_verb = list ("smacked", "thwacked", "thunked")
	matter = list(MATERIAL_ALUMINIUM = 200, MATERIAL_GLASS = 50)
	hitsound = "swing_hit"
	flashlight_max_bright = 0.5
	flashlight_outer_range = 5

/******************************Lantern*******************************/
/obj/item/device/flashlight/lantern
	name = "lantern"
	desc = "A mining lantern."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "lantern"
	item_state = "lantern"
	force = 10
	attack_verb = list ("bludgeoned", "bashed", "whack")
	w_class = ITEM_SIZE_NORMAL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	matter = list(MATERIAL_STEEL = 200,MATERIAL_GLASS = 100)
	flashlight_outer_range = 5

/obj/item/device/flashlight/lantern/on_update_icon()
	..()
	if(on)
		item_state = "lantern-on"
	else
		item_state = "lantern"

/******************************Lantern*******************************/

/obj/item/device/flashlight/drone
	name = "low-power flashlight"
	desc = "A miniature lamp, that might be used by small robots."
	icon_state = "penlight"
	item_state = ""
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_TINY
	flashlight_max_bright = 0.25
	flashlight_inner_range = 0.1
	flashlight_outer_range = 2
	flashlight_flags = FLASHLIGHT_CANNOT_BLIND


// the desk lamps are a bit special
/obj/item/device/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	item_state = "lamp"
	w_class = ITEM_SIZE_LARGE
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	flashlight_max_bright = 0.3
	flashlight_inner_range = 2
	flashlight_outer_range = 5

	on = 1

// green-shaded desk lamp
/obj/item/device/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	item_state = "lampgreen"
	light_color = "#ffc58f"

/obj/item/device/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

// FLARES

/obj/item/device/flashlight/flare
	name = "flare"
	desc = "A red standard-issue flare. There are instructions on the side reading 'pull cord, make light'."
	w_class = ITEM_SIZE_TINY
	light_color = "#e58775"
	icon_state = "flare"
	item_state = "flare"
	action_button_name = null //just pull it manually, neckbeard.
	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500
	activation_sound = 'sound/effects/flare.ogg'
	flashlight_flags = FLASHLIGHT_SINGLE_USE

	flashlight_max_bright = 0.8
	flashlight_inner_range = 0.1
	flashlight_outer_range = 5

/obj/item/device/flashlight/flare/Initialize()
	. = ..()
	fuel = rand(4 MINUTES, 5 MINUTES) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.v
	update_icon()

/obj/item/device/flashlight/flare/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/device/flashlight/flare/Process()
	if(produce_heat)
		var/turf/T = get_turf(src)
		if(T)
			T.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if (fuel <= 0)
		on = FALSE
	if(!on)
		update_damage()
		set_flashlight()
		update_icon()
		STOP_PROCESSING(SSobj, src)

/obj/item/device/flashlight/flare/attack_self(var/mob/user)
	if(fuel <= 0)
		to_chat(user,"<span class='notice'>\The [src] is spent.</span>")
		return 0

	. = ..()

	if(.)
		activate(user)
		update_damage()
		set_flashlight()
		update_icon()
		START_PROCESSING(SSobj, src)

/obj/item/device/flashlight/flare/afterattack(var/obj/O, var/mob/user, var/proximity)
	if(proximity && istype(O) && on)
		O.HandleObjectHeating(src, user, 500)
	..()

/obj/item/device/flashlight/flare/proc/activate(var/mob/user)
	if(istype(user))
		user.visible_message("<span class='notice'>[user] pulls the cord on \the [src], activating it.</span>", "<span class='notice'>You pull the cord on \the [src], activating it!</span>")

/obj/item/device/flashlight/flare/proc/update_damage()
	if(on)
		force = on_damage
		damtype = DAMAGE_BURN
	else
		force = initial(force)
		damtype = initial(damtype)

/obj/item/device/flashlight/flare/on_update_icon()
	..()
	if(!on && fuel <= 0)
		icon_state = "[initial(icon_state)]-empty"

//Glowsticks
/obj/item/device/flashlight/flare/glowstick
	name = "green glowstick"
	desc = "A military-grade glowstick."
	w_class = 2.0
	color = "#49f37c"
	icon_state = "glowstick"
	item_state = "glowstick"
	randpixel = 12
	produce_heat = 0
	activation_sound = 'sound/effects/glowstick.ogg'

	flashlight_max_bright = 0.6
	flashlight_inner_range = 0.1
	flashlight_outer_range = 3
	flashlight_flags = FLASHLIGHT_CANNOT_BLIND


/obj/item/device/flashlight/flare/glowstick/Initialize()
	. = ..()
	fuel = rand(1600, 2000)
	light_color = color

/obj/item/device/flashlight/flare/glowstick/on_update_icon()
	item_state = "glowstick"
	overlays.Cut()
	if(fuel <= 0)
		icon_state = "glowstick-empty"
		on = FALSE
	else if (on)
		var/image/I = overlay_image(icon,"glowstick-on",color)
		I.blend_mode = BLEND_ADD
		overlays += I
		item_state = "glowstick-on"
	else
		icon_state = "glowstick"
	var/mob/M = loc
	if(istype(M))
		if(M.l_hand == src)
			M.update_inv_l_hand()
		if(M.r_hand == src)
			M.update_inv_r_hand()

/obj/item/device/flashlight/flare/glowstick/activate(var/mob/user)
	if(istype(user))
		user.visible_message("<span class='notice'>[user] cracks and shakes \the [src].</span>", "<span class='notice'>You crack and shake \the [src], turning it on!</span>")

/obj/item/device/flashlight/flare/glowstick/red
	name = "red glowstick"
	color = "#fc0f29"

/obj/item/device/flashlight/flare/glowstick/blue
	name = "blue glowstick"
	color = "#599dff"

/obj/item/device/flashlight/flare/glowstick/orange
	name = "orange glowstick"
	color = "#fa7c0b"

/obj/item/device/flashlight/flare/glowstick/yellow
	name = "yellow glowstick"
	color = "#fef923"

/obj/item/device/flashlight/flare/glowstick/random
	name = "glowstick"
	desc = "A party-grade glowstick."
	color = "#ff00ff"

/obj/item/device/flashlight/flare/glowstick/random/New()
	color = rgb(rand(50,255),rand(50,255),rand(50,255))
	..()

/obj/item/device/flashlight/slime
	gender = PLURAL
	name = "glowing slime extract"
	desc = "A glowing ball of what appears to be amber."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floor1" //not a slime extract sprite but... something close enough!
	item_state = "slime"
	w_class = ITEM_SIZE_TINY
	on = TRUE //Bio-luminesence has one setting, on.
	flashlight_flags = FLASHLIGHT_ALWAYS_ON | FLASHLIGHT_CANNOT_BLIND

	flashlight_max_bright = 1
	flashlight_inner_range = 0.1
	flashlight_outer_range = 5

/obj/item/device/flashlight/slime/New()
	..()

//hand portable floodlights for emergencies. Less bulky than the large ones. But also less light. Unused green variant in the sheet.

/obj/item/device/flashlight/lamp/floodlamp
	name = "flood lamp"
	desc = "A portable emergency flood light with a ultra-bright LED."
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "floodlamp"
	item_state = "lamp"
	on = 0
	w_class = ITEM_SIZE_LARGE
	obj_flags = OBJ_FLAG_CONDUCTIBLE | OBJ_FLAG_ROTATABLE

	flashlight_max_bright = 0.8
	flashlight_inner_range = 1
	flashlight_outer_range = 5

/obj/item/device/flashlight/lamp/floodlamp/green
	icon_state = "greenfloodlamp"

//Lava Lamps: Because we're already stuck in the 70ies with those fax machines.
/obj/item/device/flashlight/lamp/lava
	name = "lava lamp"
	desc = "A kitchy throwback decorative light. Noir Edition."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "lavalamp"
	on = 0
	action_button_name = "Toggle lamp"
	flashlight_outer_range = 3 //range of light when on
	matter = list(MATERIAL_ALUMINIUM = 250, MATERIAL_GLASS = 200)
	flashlight_flags = FLASHLIGHT_CANNOT_BLIND

/obj/item/device/flashlight/lamp/lava/on_update_icon()
	overlays.Cut()
	var/image/I = image(icon = icon, icon_state = "lavalamp-[on ? "on" : "off"]")
	I.color = light_color
	overlays += I

/obj/item/device/flashlight/lamp/lava/red
	desc = "A kitchy red decorative light."
	light_color = COLOR_RED

/obj/item/device/flashlight/lamp/lava/blue
	desc = "A kitchy blue decorative light."
	light_color = COLOR_BLUE

/obj/item/device/flashlight/lamp/lava/cyan
	desc = "A kitchy cyan decorative light."
	light_color = COLOR_CYAN

/obj/item/device/flashlight/lamp/lava/green
	desc = "A kitchy green decorative light."
	light_color = COLOR_GREEN

/obj/item/device/flashlight/lamp/lava/orange
	desc = "A kitchy orange decorative light."
	light_color = COLOR_ORANGE

/obj/item/device/flashlight/lamp/lava/purple
	desc = "A kitchy purple decorative light."
	light_color = COLOR_PURPLE
/obj/item/device/flashlight/lamp/lava/pink
	desc = "A kitchy pink decorative light."
	light_color = COLOR_PINK

/obj/item/device/flashlight/lamp/lava/yellow
	desc = "A kitchy yellow decorative light."
	light_color = COLOR_YELLOW

#undef FLASHLIGHT_ALWAYS_ON
#undef FLASHLIGHT_SINGLE_USE
#undef FLASHLIGHT_CANNOT_BLIND
