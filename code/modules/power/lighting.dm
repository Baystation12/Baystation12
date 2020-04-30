// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/weapon/light)


// status values shared between lighting fixtures and items
#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3

#define LIGHT_STAGE_EMPTY 1
#define LIGHT_STAGE_WIRED 2
#define LIGHT_STAGE_COMPLETE 3

#define LIGHT_BULB_TEMPERATURE 400 //K - used value for a 60W bulb
#define LIGHTING_POWER_FACTOR 5		//5W per luminosity * range


#define LIGHTMODE_EMERGENCY "emergency_lighting"
#define LIGHTMODE_READY "ready"

#define LIGHT_PHORON_EXPLODE_THRESHOLD 5 // This many units of phoron have to be in the bulb for it to explode


// Light frames! The unfinished form of a light fixture.
/obj/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER

	var/stage = LIGHT_STAGE_EMPTY
	var/fixture_type = /obj/machinery/light
	var/sheets_refunded = 2

/obj/machinery/light_construct/New(atom/newloc, var/newdir, atom/fixture = null)
	..(newloc)

	if(newdir)
		set_dir(newdir)

	if(istype(fixture))
		if(istype(fixture, /obj/machinery/light))
			fixture_type = fixture.type
		fixture.transfer_fingerprints_to(src)

	update_icon()

/obj/machinery/light_construct/on_update_icon()
	switch(stage)
		if(LIGHT_STAGE_EMPTY) icon_state = "tube-construct-stage1"
		if(LIGHT_STAGE_WIRED) icon_state = "tube-construct-stage2"
		if(LIGHT_STAGE_COMPLETE) icon_state = "tube-empty"

/obj/machinery/light_construct/examine(mob/user, distance)
	. = ..()
	if(distance > 2)
		return

	switch(stage)
		if(LIGHT_STAGE_EMPTY) to_chat(user, "It's an empty frame.")
		if(LIGHT_STAGE_WIRED) to_chat(user, "It's wired.")
		if(LIGHT_STAGE_COMPLETE) to_chat(user, "The casing is closed.")

/obj/machinery/light_construct/attackby(obj/item/weapon/W as obj, mob/living/user)
	add_fingerprint(user)
	if(isWrench(W))

		switch(stage)
			if (LIGHT_STAGE_EMPTY)
				playsound(loc, 'sound/items/Ratchet.ogg', 50, TRUE)
				to_chat(user, SPAN_NOTICE("You begin deconstructing [src]."))
				if (!user.do_skilled(30, SKILL_CONSTRUCTION, src))
					return
				new /obj/item/stack/material/steel( get_turf(loc), sheets_refunded )
				user.visible_message(SPAN_NOTICE("[user] deconstructs [src]."), \
					SPAN_NOTICE("You deconstruct [src]!"), \
					SPAN_ITALIC("You hear ratcheting and metal scraping."))
				playsound(loc, 'sound/items/Deconstruct.ogg', 75, TRUE)
				qdel(src)
				return
			
			if (LIGHT_STAGE_WIRED)
				to_chat(user, SPAN_WARNING("You have to remove the wires first."))
				return

			if (LIGHT_STAGE_COMPLETE)
				to_chat(user, SPAN_WARNING("You have to unscrew the case first."))
				return

	if(isWirecutter(W))
		if (stage != LIGHT_STAGE_WIRED)
			return
		stage = LIGHT_STAGE_EMPTY
		update_icon()
		new /obj/item/stack/cable_coil(get_turf(loc), 1, "red")
		user.visible_message(SPAN_NOTICE("[user] cuts the wires from [src]."), \
			SPAN_NOTICE("You cut [src]'s wires and remove them from the frame'."), \
			SPAN_ITALIC("You hear snipping and cables being cut."))
		playsound(loc, 'sound/items/Wirecutter.ogg', 50, TRUE)
		return

	if(istype(W, /obj/item/stack/cable_coil))
		if (stage != LIGHT_STAGE_EMPTY)
			return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			stage = LIGHT_STAGE_WIRED
			update_icon()
			user.visible_message(SPAN_NOTICE("[user] adds wires to [src]."), \
				SPAN_NOTICE("You add wires to [src]."))
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
		return

	if(isScrewdriver(W))
		if (stage == LIGHT_STAGE_WIRED)
			stage = LIGHT_STAGE_COMPLETE
			update_icon()
			user.visible_message(SPAN_NOTICE("[user] closes [src]'s casing."), \
				SPAN_NOTICE("You close [src]'s casing."), \
				SPAN_ITALIC("You hear screws being tightened."))
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, TRUE)

			var/obj/machinery/light/newlight = new fixture_type(loc, src)
			newlight.set_dir(dir)

			transfer_fingerprints_to(newlight)
			qdel(src)
			return
	..()

/obj/machinery/light_construct/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = 1
	layer = ABOVE_HUMAN_LAYER
	stage = 1
	fixture_type = /obj/machinery/light/small
	sheets_refunded = 1

/obj/machinery/light_construct/small/on_update_icon()
	switch(stage)
		if(LIGHT_STAGE_EMPTY) icon_state = "bulb-construct-stage1"
		if(LIGHT_STAGE_WIRED) icon_state = "bulb-construct-stage2"
		if(LIGHT_STAGE_COMPLETE) icon_state = "bulb-empty"

/obj/machinery/light_construct/spot
	name = "large light fixture frame"
	desc = "A large light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	fixture_type = /obj/machinery/light/spot
	sheets_refunded = 3

// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube_map"
	desc = "A lighting fixture."
	anchored = 1
	layer = ABOVE_HUMAN_LAYER  					// They were appearing under mobs which is a little weird - Ostaf
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT //Lights are calc'd via area so they don't need to be in the machine list

	var/on = 0					// 1 if on, 0 if off
	var/flickering = 0
	var/light_type = /obj/item/weapon/light/tube		// the type of light item
	var/construct_type = /obj/machinery/light_construct

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread

	var/obj/item/weapon/light/lightbulb

	var/current_mode = null

// the smaller bulb light fixture
/obj/machinery/light/small
	icon_state = "bulb_map"
	base_state = "bulb"
	desc = "A small lighting fixture."
	light_type = /obj/item/weapon/light/bulb
	construct_type = /obj/machinery/light_construct/small

/obj/machinery/light/small/emergency
	light_type = /obj/item/weapon/light/bulb/red

/obj/machinery/light/small/red
	light_type = /obj/item/weapon/light/bulb/red

/obj/machinery/light/spot
	name = "spotlight"
	desc = "A more robust socket for light tubes that demand more power."
	light_type = /obj/item/weapon/light/tube/large
	construct_type = /obj/machinery/light_construct/spot

// create a new lighting fixture
/obj/machinery/light/Initialize(mapload, obj/machinery/light_construct/construct = null)
	. = ..(mapload)

	s.set_up(1, 1, src)

	if(construct)
		construct_type = construct.type
		construct.transfer_fingerprints_to(src)
		set_dir(construct.dir)
	else
		lightbulb = new light_type(src)
		if(prob(lightbulb.broken_chance))
			broken(1)

	on = powered()
	update_icon(0)

/obj/machinery/light/Destroy()
	QDEL_NULL(lightbulb)
	QDEL_NULL(s)
	. = ..()

/obj/machinery/light/on_update_icon(var/trigger = 1)
	overlays.Cut()
	icon_state = "[base_state]_empty" //Never use the initial state. That'll just reset it to the mapping icon.
	pixel_y = 0
	pixel_x = 0
	var/turf/T = get_step(get_turf(src), dir)
	if(istype(T) && T.density)
		if(dir == NORTH)
			pixel_y = 21
		else if(dir == EAST)
			pixel_x = 10
		else if(dir == WEST)
			pixel_x = -10

	var/_state
	switch(get_status())		// set icon_states
		if(LIGHT_OK)
			_state = "[base_state][on]"
		if(LIGHT_EMPTY)
			on = 0
		if(LIGHT_BURNED)
			_state = "[base_state]_burned"
			on = 0
		if(LIGHT_BROKEN)
			_state = "[base_state]_broken"
			on = 0

	if(istype(lightbulb, /obj/item/weapon/light/))
		var/image/I = image(icon, src, _state)
		I.color = lightbulb.b_colour
		overlays += I

	if(on)

		update_use_power(POWER_USE_ACTIVE)

		var/changed = 0
		if(current_mode && (current_mode in lightbulb.lighting_modes))
			changed = set_light(arglist(lightbulb.lighting_modes[current_mode]))
		else
			changed = set_light(lightbulb.b_max_bright, lightbulb.b_inner_range, lightbulb.b_outer_range, lightbulb.b_curve, lightbulb.b_colour)

		if(trigger && changed && get_status() == LIGHT_OK)
			switch_check()
	else
		update_use_power(POWER_USE_OFF)
		set_light(0)
	change_power_consumption((light_outer_range * light_max_bright) * LIGHTING_POWER_FACTOR, POWER_USE_ACTIVE)

/obj/machinery/light/proc/get_status()
	if(!lightbulb)
		return LIGHT_EMPTY
	else
		return lightbulb.status

/obj/machinery/light/proc/switch_check()
	lightbulb.switch_on()
	if(get_status() != LIGHT_OK)
		set_light(0)
	update_icon()

/obj/machinery/light/attack_generic(var/mob/user, var/damage)
	if(!damage)
		return
	var/status = get_status()
	if(status == LIGHT_EMPTY || status == LIGHT_BROKEN)
		to_chat(user, SPAN_WARNING("You can't do anything with \the [src]."))
		return
	if(!(status == LIGHT_OK || status == LIGHT_BURNED))
		return
	user.visible_message(SPAN_WARNING("[user] smashes the light!"), SPAN_WARNING("You smash the light!"))
	attack_animation(user)
	broken()
	return 1

/obj/machinery/light/proc/set_mode(var/new_mode)
	if(current_mode != new_mode)
		current_mode = new_mode
		update_icon(0)

/obj/machinery/light/proc/set_emergency_lighting(var/enable)
	if(!lightbulb)
		return

	if(enable)
		if(LIGHTMODE_EMERGENCY in lightbulb.lighting_modes)
			set_mode(LIGHTMODE_EMERGENCY)
			update_power_channel(ENVIRON)
	else
		if(current_mode == LIGHTMODE_EMERGENCY)
			set_mode(null)
			update_power_channel(initial(power_channel))

// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/machinery/light/proc/seton(var/state)
	on = (state && get_status() == LIGHT_OK)
	queue_icon_update()

// examine verb
/obj/machinery/light/examine(mob/user)
	. = ..()
	var/fitting = get_fitting_name()
	switch(get_status())
		if(LIGHT_OK)
			to_chat(user, "It is turned [on? "on" : "off"].")
		if(LIGHT_EMPTY)
			to_chat(user, "The [fitting] has been removed.")
		if(LIGHT_BURNED)
			to_chat(user, "The [fitting] is burnt out.")
		if(LIGHT_BROKEN)
			to_chat(user, "The [fitting] has been smashed.")

/obj/machinery/light/proc/get_fitting_name()
	var/obj/item/weapon/light/L = light_type
	return initial(L.name)

// attack with item - insert light (if right type), otherwise try to break the light

/obj/machinery/light/proc/insert_bulb(obj/item/weapon/light/L)
	L.forceMove(src)
	lightbulb = L

	on = powered()
	update_icon()

/obj/machinery/light/proc/remove_bulb()
	. = lightbulb
	lightbulb.dropInto(loc)
	lightbulb.update_icon()
	lightbulb = null
	update_icon()

/obj/machinery/light/attackby(obj/item/W, mob/user)

	// attempt to insert light
	if(istype(W, /obj/item/weapon/light))
		if(lightbulb)
			to_chat(user, SPAN_WARNING("There is a [get_fitting_name()] already inserted."))
			return
		if(!istype(W, light_type))
			to_chat(user, SPAN_WARNING("This type of light requires a [get_fitting_name()]."))
			return
		if(!user.unEquip(W, src))
			return
		user.visible_message(SPAN_NOTICE("[user] inserts [W] into [src]."), SPAN_NOTICE("You insert [W]."), SPAN_ITALIC("You hear something being screwed in."))
		insert_bulb(W)
		add_fingerprint(user)

		// attempt to break the light
		//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N

	else if(lightbulb && (lightbulb.status != LIGHT_BROKEN))

		if(prob(1 + W.force * 5))

			user.visible_message(SPAN_WARNING("[user] smashes the light!"), SPAN_WARNING("You smash the light!"), SPAN_WARNING("You hear a small glass object shatter."))
			if(on && (W.obj_flags & OBJ_FLAG_CONDUCTIBLE))
				if (prob(12))
					electrocute_mob(user, get_area(src), src, 0.3)
			broken()

		else
			user.visible_message(SPAN_WARNING("[user] hits the light!"), SPAN_WARNING("You hit the light!"), SPAN_WARNING("You hear glass cracking."))
			playsound(loc, "glasscrack", 40, TRUE)
		attack_animation(user)

	// attempt to stick weapon into light socket
	else if(!lightbulb)
		if(istype(W, /obj/item/weapon/screwdriver)) //If it's a screwdriver open it.
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, TRUE)
			user.visible_message(SPAN_NOTICE("[user] opens [src]'s casing."), SPAN_NOTICE("You open up [src]'s casing."), SPAN_ITALIC("You hear screws being loosened."))
			var/obj/machinery/light_construct/C = new construct_type(loc, dir, src)
			C.stage = LIGHT_STAGE_WIRED
			C.update_icon()
			qdel(src)
			return

		user.visible_message(SPAN_WARNING("[user] shoves [W] into [src]!"), SPAN_DANGER("You stick [W] into [src]!"))
		if(powered() && (W.obj_flags & OBJ_FLAG_CONDUCTIBLE))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if (prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))


// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/powered()
	var/area/A = get_area(src)
	return A && A.lightswitch && ..(power_channel)

/obj/machinery/light/proc/flicker(var/amount = rand(10, 20))
	if(flickering) return
	flickering = 1
	spawn(0)
		if(on && get_status() == LIGHT_OK)
			for(var/i = 0; i < amount; i++)
				if(get_status() != LIGHT_OK) break
				on = !on
				update_icon(0)
				sleep(rand(5, 15))
			on = (get_status() == LIGHT_OK)
			update_icon(0)
		flickering = 0

// ai attack - make lights flicker, because why not

/obj/machinery/light/attack_ai(mob/user)
	to_chat(user, SPAN_NOTICE("You cause [src] to flick on and off."))
	flicker(1)

// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player
/obj/machinery/light/physical_attack_hand(mob/living/user)
	if(!lightbulb)
		to_chat(user, SPAN_WARNING("There is no [get_fitting_name()] in this light."))
		return TRUE

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			visible_message(SPAN_WARNING("[user] shreds the light!"), SPAN_WARNING("You shred the light!"), SPAN_WARNING("You hear glass shattering!"))
			broken()
			return TRUE

	// make it burn hands if not wearing fire-insulated gloves
	if(on)
		var/prot = 0
		var/mob/living/carbon/human/H = user

		if(istype(H))
			if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature)
					if(G.max_heat_protection_temperature > LIGHT_BULB_TEMPERATURE)
						prot = 1
		else
			prot = 1

		if(prot > 0 || (MUTATION_COLD_RESISTANCE in user.mutations))
			to_chat(user, SPAN_NOTICE("You remove the [get_fitting_name()]."))
		else if(istype(user) && user.psi && !user.psi.suppressed && user.psi.get_rank(PSI_PSYCHOKINESIS) >= PSI_RANK_OPERANT)
			to_chat(user, SPAN_NOTICE("You telekinetically remove the [get_fitting_name()]."))
		else if(user.a_intent != I_HELP)
			var/obj/item/organ/external/hand = H.organs_by_name[user.hand ? BP_L_HAND : BP_R_HAND]
			if(hand && hand.is_usable() && !hand.can_feel_pain())
				user.apply_damage(3, BURN, user.hand ? BP_L_HAND : BP_R_HAND, used_weapon = src)
				user.visible_message(SPAN_WARNING("\The [user]'s [hand] burns and sizzles as \he touches the hot [get_fitting_name()]."), SPAN_WARNING("Your [hand.name] burns and sizzles as you remove the hot [get_fitting_name()]."))
		else
			to_chat(user, SPAN_WARNING("You try to remove the [get_fitting_name()], but it's too hot and you don't want to burn your hand."))
			return TRUE
	else
		to_chat(user, SPAN_NOTICE("You remove the [get_fitting_name()]."))

	// create a light tube/bulb item and put it in the user's hand
	user.put_in_active_hand(remove_bulb())	//puts it in our active hand
	return TRUE

// ghost attack - make lights flicker like an AI, but even spookier!
/obj/machinery/light/attack_ghost(mob/user)
	if(round_is_spooky())
		flicker(rand(2,5))
	else return ..()

// break the light and make sparks if was on
/obj/machinery/light/proc/broken(var/skip_sound_and_sparks = 0)
	if(!lightbulb)
		return

	if(!skip_sound_and_sparks)
		if(lightbulb && !(lightbulb.status == LIGHT_BROKEN))
			playsound(loc, 'sound/effects/Glasshit.ogg', 50, TRUE)
		if(on)
			s.set_up(3, 1, src)
			s.start()
	lightbulb.status = LIGHT_BROKEN
	update_icon()

/obj/machinery/light/proc/fix()
	if(get_status() == LIGHT_OK || !lightbulb)
		return
	lightbulb.status = LIGHT_OK
	on = 1
	update_icon()

// explosion effect
// destroy the whole light fixture or just shatter it

/obj/machinery/light/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
			return
		if(2)
			if (prob(75))
				broken()
		if(3)
			if (prob(50))
				broken()

// timed process
// use power

// called when area power state changes
/obj/machinery/light/power_change()
	spawn(10)
		seton(powered())

// called when on fire

/obj/machinery/light/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		broken()

/obj/machinery/light/small/readylight
	light_type = /obj/item/weapon/light/bulb/red/readylight
	var/state = 0

/obj/machinery/light/small/readylight/proc/set_state(var/new_state)
	state = new_state
	if(state)
		set_mode(LIGHTMODE_READY)
	else
		set_mode(null)

/obj/machinery/light/navigation
	name = "navigation light"
	desc = "A periodically flashing light."
	icon = 'icons/obj/lighting_nav.dmi'
	icon_state = "nav10"
	base_state = "nav1"
	light_type = /obj/item/weapon/light/tube/large
	on = TRUE

/obj/machinery/light/navigation/delay2
		icon_state = "nav20"
		base_state = "nav2"
/obj/machinery/light/navigation/delay3
		icon_state = "nav30"
		base_state = "nav3"
/obj/machinery/light/navigation/delay4
		icon_state = "nav40"
		base_state = "nav4"
/obj/machinery/light/navigation/delay5
		icon_state = "nav50"
		base_state = "nav5"

/obj/machinery/light/navigation/powered()
	return TRUE


// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/weapon/light
	icon = 'icons/obj/lighting.dmi'
	force = 2
	throwforce = 5
	w_class = ITEM_SIZE_TINY
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/base_state
	var/switchcount = 0	// number of times switched
	matter = list(MATERIAL_STEEL = 60)
	var/broken_chance = 2

	var/b_max_bright = 0.9
	var/b_inner_range = 1
	var/b_outer_range = 5
	var/b_curve = 2
	var/b_colour = "#fffee0"
	var/list/lighting_modes = list()
	var/sound_on

/obj/item/weapon/light/examine(mob/user)
	. = ..()
	if (reagents.total_volume && Adjacent(user))
		to_chat(user, SPAN_WARNING("There's some sort of fluid inside [src]."))

/obj/item/weapon/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	matter = list(MATERIAL_GLASS = 100, MATERIAL_ALUMINIUM = 20)

	b_outer_range = 5
	b_colour = "#fffee0"
	lighting_modes = list(
		LIGHTMODE_EMERGENCY = list(l_outer_range = 4, l_max_bright = 1, l_color = "#da0205"),
		)
	sound_on = 'sound/machines/lightson.ogg'

/obj/item/weapon/light/tube/party/Initialize() //Randomly colored light tubes. Mostly for testing, but maybe someone will find a use for them.
	. = ..()
	b_colour = rgb(pick(0,255), pick(0,255), pick(0,255))

/obj/item/weapon/light/tube/large
	w_class = ITEM_SIZE_SMALL
	name = "large light tube"
	b_max_bright = 0.95
	b_inner_range = 2
	b_outer_range = 8
	b_curve = 2.5

/obj/item/weapon/light/tube/large/party/Initialize() //Randomly colored light tubes. Mostly for testing, but maybe someone will find a use for them.
	. = ..()
	b_colour = rgb(pick(0,255), pick(0,255), pick(0,255))

/obj/item/weapon/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_state = "lbulb"
	item_state = "contvapour"
	broken_chance = 3
	matter = list(MATERIAL_GLASS = 100)

	b_max_bright = 0.6
	b_inner_range = 0.1
	b_outer_range = 4
	b_curve = 3
	b_colour = "#fcfcc7"
	lighting_modes = list(
		LIGHTMODE_EMERGENCY = list(l_outer_range = 3, l_max_bright = 1, l_color = "#da0205"),
		)

/obj/item/weapon/light/bulb/red
	color = "#da0205"
	b_colour = "#da0205"

/obj/item/weapon/light/bulb/red/readylight
	lighting_modes = list(
		LIGHTMODE_READY = list(l_outer_range = 5, l_max_bright = 1, l_color = "#00ff00"),
		)

/obj/item/weapon/light/throw_impact(atom/hit_atom)
	..()
	shatter()

/obj/item/weapon/light/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "fbulb"
	base_state = "fbulb"
	item_state = "egg4"
	matter = list(MATERIAL_GLASS = 100)

// update the icon state and description of the light
/obj/item/weapon/light/on_update_icon()
	color = b_colour
	var/broken
	switch(status)
		if(LIGHT_OK)
			icon_state = base_state
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "[base_state]_burned"
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "[base_state]_broken"
			desc = "A broken [name]."
			broken = TRUE
	var/image/I = image(icon, src, "[base_state]_attachment[broken ? "_broken" : ""]")
	I.color = null
	overlays += I

/obj/item/weapon/light/New(atom/newloc, obj/machinery/light/fixture = null)
	..()
	update_icon()

// attack bulb/tube with object
// if a syringe, can inject phoron to make it explode
/obj/item/weapon/light/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/reagent_containers/syringe) && status == LIGHT_OK)
		var/obj/item/weapon/reagent_containers/syringe/S = I

		if(S.reagents.total_volume)
			if (!reagents)
				create_reagents(5)
				S.reagents.trans_to_obj(src, 5)
				to_chat(user, SPAN_WARNING("You inject the solution into [src]."))
				if (reagents.get_reagent_amount(/datum/reagent/toxin/phoron) >= LIGHT_PHORON_EXPLODE_THRESHOLD)
					log_and_message_admins("injected a light with phoron, rigging it to explode.", user)
				return
			else
				to_chat(user, SPAN_WARNING("[src] is already filled with fluid!"))
	. = ..()

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

/obj/item/weapon/light/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != I_HURT)
		return

	shatter()

/obj/item/weapon/light/proc/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		visible_message(SPAN_WARNING("[src] shatters!"), SPAN_WARNING("You hear a small glass object shatter."))
		status = LIGHT_BROKEN
		force = 5
		sharp = TRUE
		playsound(loc, "glasscrack", 75, TRUE)
		update_icon()

/obj/item/weapon/light/proc/switch_on()
	switchcount++
	if(reagents)
		if (reagents.get_reagent_amount(/datum/reagent/toxin/phoron) >= LIGHT_PHORON_EXPLODE_THRESHOLD)
			visible_message(SPAN_DANGER("[src] flares brilliantly!"), SPAN_DANGER("You hear a loud crack!"))
			log_and_message_admins("Rigged light explosion, last touched by [fingerprintslast]")
			var/turf/T = get_turf(loc)
			status = LIGHT_BROKEN
			spawn(0)
				sleep(2)
				explosion(T, 0, 0, 3, 5)
		else
			visible_message(SPAN_WARNING("[src] short-circuits as something burns out its filament!"))
			status = LIGHT_BURNED
			if (sound_on)
				playsound(src, sound_on, 100)
	else if(prob(min(60, switchcount*switchcount*0.01)))
		status = LIGHT_BURNED
	else if(sound_on)
		playsound(src, sound_on, 75)
	return status

/obj/machinery/light/do_simple_ranged_interaction(var/mob/user)
	if(lightbulb)
		remove_bulb()
	return TRUE

#undef LIGHT_STAGE_COMPLETE
#undef LIGHT_STAGE_WIRED
#undef LIGHT_STAGE_EMPTY
