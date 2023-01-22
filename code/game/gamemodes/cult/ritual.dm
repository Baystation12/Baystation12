/obj/item/book/tome
	name = "arcane tome"
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "tome"
	throw_speed = 1
	throw_range = 5
	w_class = 2
	unique = 1
	carved = 2 // Don't carve it

/obj/item/book/tome/attack_self(mob/living/user)
	if(!iscultist(user))
		to_chat(user, SPAN_NOTICE("\The [src] seems full of illegible scribbles. Is this a joke?"))
	else
		to_chat(user, "Hold \the [src] in your hand while drawing a rune to use it.")

/obj/item/book/tome/examine(mob/user)
	. = ..()
	if(!iscultist(user))
		to_chat(user, "An old, dusty tome with frayed edges and a sinister looking cover.")
	else
		to_chat(user, "The scriptures of Nar-Sie, The One Who Sees, The Geometer of Blood. Contains the details of every ritual his followers could think of. Most of these are useless, though.")

/obj/item/book/tome/attack(mob/living/M, mob/living/user)
	if (user.a_intent != I_HELP || user.zone_sel.selecting != BP_EYES)
		return ..()
	user.visible_message(
		SPAN_NOTICE("\The [user] shows \the [src] to \the [M]."),
		SPAN_NOTICE("You open up \the [src] and show it to \the [M].")
	)
	if (iscultist(M))
		if (user != M)
			to_chat(user, SPAN_NOTICE("But they already know all there is to know."))
		to_chat(M, SPAN_NOTICE("But you already know all there is to know."))
	else
		to_chat(M, SPAN_NOTICE("\The [src] seems full of illegible scribbles. Is this a joke?"))
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)

/obj/item/book/tome/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity || !iscultist(user))
		return
	if(A.reagents && A.reagents.has_reagent(/datum/reagent/water/holywater))
		to_chat(user, "<span class='notice'>You unbless \the [A].</span>")
		var/holy2water = A.reagents.get_reagent_amount(/datum/reagent/water/holywater)
		A.reagents.del_reagent(/datum/reagent/water/holywater)
		A.reagents.add_reagent(/datum/reagent/water, holy2water)

/mob/proc/make_rune(var/rune, var/cost = 5, var/tome_required = 0)
	var/has_tome = 0
	var/has_robes = 0
	var/cult_ground = 0
	if(istype(get_active_hand(), /obj/item/book/tome) || istype(get_inactive_hand(), /obj/item/book/tome))
		has_tome = 1
	else if(tome_required && mob_needs_tome())
		to_chat(src, "<span class='warning'>This rune is too complex to draw by memory, you need to have a tome in your hand to draw it.</span>")
		return
	if(istype(get_equipped_item(slot_head), /obj/item/clothing/head/culthood) && istype(get_equipped_item(slot_wear_suit), /obj/item/clothing/suit/cultrobes) && istype(get_equipped_item(slot_shoes), /obj/item/clothing/shoes/cult))
		has_robes = 1
	var/turf/T = get_turf(src)
	if(T.holy)
		to_chat(src, "<span class='warning'>This place is blessed, you may not draw runes on it - defile it first.</span>")
		return
	if(!istype(T, /turf/simulated))
		to_chat(src, "<span class='warning'>You need more space to draw a rune here.</span>")
		return
	if(locate(/obj/effect/rune) in T)
		to_chat(src, "<span class='warning'>There's already a rune here.</span>") // Don't cross the runes
		return
	if(T.icon_state == "cult" || T.icon_state == "cult-narsie")
		cult_ground = 1
	var/self
	var/timer
	var/damage = 1
	if(has_tome)
		if(has_robes && cult_ground)
			self = "Feeling greatly empowered, you slice open your finger and make a rune on the engraved floor. It shifts when your blood touches it, and starts vibrating as you begin to chant the ritual that binds your life essence with the dark arcane energies flowing through the surrounding world."
			timer = 1 SECOND
			damage = 0.2
		else if(has_robes)
			self = "Feeling empowered in your robes, you slice open your finger and start drawing a rune, chanting the ritual that binds your life essence with the dark arcane energies flowing through the surrounding world."
			timer = 3 SECONDS
			damage = 0.8
		else if(cult_ground)
			self = "You slice open your finger and slide it over the engraved floor, watching it shift when your blood touches it. It vibrates when you begin to chant the ritual that binds your life essence with the dark arcane energies flowing through the surrounding world." // Sadly, you don't have access to the bell nor the candelbarum
			timer = 2 SECONDS
			damage = 0.8
		else
			self = "You slice open one of your fingers and begin drawing a rune on the floor whilst chanting the ritual that binds your life essence with the dark arcane energies flowing through the surrounding world."
			timer = 4 SECONDS
	else
		self = "Working without your tome, you try to draw the rune from your memory"
		if(has_robes && cult_ground)
			self += ". You feel that you remember it perfectly, finishing it with a few bold strokes. The engraved floor shifts under your touch, and vibrates once you begin your chants."
			timer = 3 SECONDS
		else if(has_robes)
			self += ". You don't remember it well, but you feel strangely empowered. You begin chanting, the unknown words slipping into your mind from beyond."
			timer = 5 SECONDS
		else if(cult_ground)
			self += ", watching as the floor shifts under your touch, correcting the rune. You begin your chants, and the ground starts to vibrate."
			timer = 4 SECONDS
		else
			self += ", having to cut your finger two more times before you make it resemble the pattern in your memory. It still looks a little off."
			timer = 8 SECONDS
			damage = 2
	visible_message("<span class='warning'>\The [src] slices open a finger and begins to chant and paint symbols on the floor.</span>", "<span class='notice'>[self]</span>", "You hear chanting.")
	if(do_after(src, timer, T, DO_PUBLIC_UNIQUE))
		remove_blood_simple(cost * damage)
		if(locate(/obj/effect/rune) in T)
			return
		var/obj/effect/rune/R = new rune(T, get_rune_color(), get_blood_name())
		var/area/A = get_area(R)
		log_and_message_admins("created \an [R.cultname] rune at \the [A.name].")
		R.add_fingerprint(src)
		return 1
	return 0

/mob/living/carbon/human/make_rune(var/rune, var/cost, var/tome_required)
	if(should_have_organ(BP_HEART) && vessel && !vessel.has_reagent(/datum/reagent/blood, species.blood_volume * 0.7))
		to_chat(src, "<span class='danger'>You are too weak to draw runes.</span>")
		return
	..()

/mob/proc/remove_blood_simple(var/blood)
	return

/mob/living/carbon/human/remove_blood_simple(var/blood)
	if(should_have_organ(BP_HEART))
		vessel.remove_reagent(/datum/reagent/blood, blood)

/mob/proc/get_blood_name()
	return "blood"

/mob/living/silicon/get_blood_name()
	return "oil"

/mob/living/carbon/human/get_blood_name()
	if(species)
		return species.get_blood_name()
	return "blood"

/mob/living/simple_animal/construct/get_blood_name()
	return "ichor"

/mob/proc/mob_needs_tome()
	return 0

/mob/living/carbon/human/mob_needs_tome()
	return 1

/mob/proc/get_rune_color()
	return "#c80000"

/mob/living/carbon/human/get_rune_color()
	return species.blood_color

var/global/list/Tier1Runes = list(
	/mob/proc/convert_rune,
	/mob/proc/teleport_rune,
	/mob/proc/tome_rune,
	/mob/proc/wall_rune,
	/mob/proc/ajorney_rune,
	/mob/proc/defile_rune,
	/mob/proc/stun_imbue,
	/mob/proc/emp_imbue,
	/mob/proc/cult_communicate,
	/mob/proc/obscure,
	/mob/proc/reveal
	)

var/global/list/Tier2Runes = list(
	/mob/proc/armor_rune,
	/mob/proc/offering_rune,
	/mob/proc/drain_rune,
	/mob/proc/emp_rune,
	/mob/proc/massdefile_rune
	)

var/global/list/Tier3Runes = list(
	/mob/proc/weapon_rune,
	/mob/proc/shell_rune,
	/mob/proc/bloodboil_rune,
	/mob/proc/confuse_rune,
	/mob/proc/revive_rune
)

var/global/list/Tier4Runes = list(
	/mob/proc/tearreality_rune
	)

/mob/proc/convert_rune()
	set category = "Cult Magic"
	set name = "Rune: Convert"

	make_rune(/obj/effect/rune/convert, tome_required = 1)

/mob/proc/teleport_rune()
	set category = "Cult Magic"
	set name = "Rune: Teleport"

	make_rune(/obj/effect/rune/teleport, tome_required = 1)

/mob/proc/tome_rune()
	set category = "Cult Magic"
	set name = "Rune: Summon Tome"

	make_rune(/obj/effect/rune/tome, cost = 15)

/mob/proc/wall_rune()
	set category = "Cult Magic"
	set name = "Rune: Wall"

	make_rune(/obj/effect/rune/wall, tome_required = 1)

/mob/proc/ajorney_rune()
	set category = "Cult Magic"
	set name = "Rune: Astral Journey"

	make_rune(/obj/effect/rune/ajorney)

/mob/proc/defile_rune()
	set category = "Cult Magic"
	set name = "Rune: Defile"

	make_rune(/obj/effect/rune/defile, tome_required = 1)

/mob/proc/massdefile_rune()
	set category = "Cult Magic"
	set name = "Rune: Mass Defile"

	make_rune(/obj/effect/rune/massdefile, tome_required = 1, cost = 20)

/mob/proc/armor_rune()
	set category = "Cult Magic"
	set name = "Rune: Summon Robes"

	make_rune(/obj/effect/rune/armor, tome_required = 1)

/mob/proc/offering_rune()
	set category = "Cult Magic"
	set name = "Rune: Offering"

	make_rune(/obj/effect/rune/offering, tome_required = 1)



/mob/proc/drain_rune()
	set category = "Cult Magic"
	set name = "Rune: Blood Drain"

	make_rune(/obj/effect/rune/drain, tome_required = 1)

/mob/proc/emp_rune()
	set category = "Cult Magic"
	set name = "Rune: EMP"

	make_rune(/obj/effect/rune/emp, tome_required = 1)

/mob/proc/weapon_rune()
	set category = "Cult Magic"
	set name = "Rune: Summon Weapon"

	make_rune(/obj/effect/rune/weapon, tome_required = 1)

/mob/proc/shell_rune()
	set category = "Cult Magic"
	set name = "Rune: Summon Shell"

	make_rune(/obj/effect/rune/shell, cost = 10, tome_required = 1)

/mob/proc/bloodboil_rune()
	set category = "Cult Magic"
	set name = "Rune: Blood Boil"

	make_rune(/obj/effect/rune/blood_boil, cost = 20, tome_required = 1)

/mob/proc/confuse_rune()
	set category = "Cult Magic"
	set name = "Rune: Confuse"

	make_rune(/obj/effect/rune/confuse)

/mob/proc/revive_rune()
	set category = "Cult Magic"
	set name = "Rune: Revive"

	make_rune(/obj/effect/rune/revive, tome_required = 1)

/mob/proc/tearreality_rune()
	set category = "Cult Magic"
	set name = "Rune: Tear Reality"

	make_rune(/obj/effect/rune/tearreality, cost = 50, tome_required = 1)

/mob/proc/stun_imbue()
	set category = "Cult Magic"
	set name = "Imbue: Stun"

	make_rune(/obj/effect/rune/imbue/stun, cost = 20, tome_required = 1)

/mob/proc/emp_imbue()
	set category = "Cult Magic"
	set name = "Imbue: EMP"

	make_rune(/obj/effect/rune/imbue/emp)

/mob/proc/cult_communicate()
	set category = "Cult Magic"
	set name = "Communicate"

	if(incapacitated())
		to_chat(src, "<span class='warning'>Not when you are incapacitated.</span>")
		return

	message_cult_communicate()
	remove_blood_simple(3)

	var/input = input(src, "Please choose a message to tell to the other acolytes.", "Voice of Blood", "")
	if(!input)
		return

	whisper("[input]")

	input = sanitize(input)
	log_and_message_admins("used a communicate verb to say '[input]'")
	for(var/datum/mind/H in GLOB.cult.current_antagonists)
		if(H.current && !H.current.stat)
			to_chat(H.current, "<span class='cult'>[input]</span>")

/mob/living/carbon/cult_communicate()
	if(incapacitated(INCAPACITATION_RESTRAINED))
		to_chat(src, "<span class='warning'>You need at least your hands free to do this.</span>")
		return
	..()

/mob/proc/message_cult_communicate()
	return

/mob/living/carbon/human/message_cult_communicate()
	visible_message("<span class='warning'>\The [src] cuts \his finger and starts drawing on the back of \his hand.</span>")

/mob/proc/obscure()
	set category = "Cult Magic"
	set name = "Rune: Obscure"

	make_rune(/obj/effect/rune/obscure)

/mob/proc/reveal()
	set category = "Cult Magic"
	set name = "Rune: Reveal"

	make_rune(/obj/effect/rune/reveal)
