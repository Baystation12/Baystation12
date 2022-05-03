/mob/living/simple_animal/hostile/retaliate/parrot/space
	name = "space parrot"
	desc = "It could be some all-knowing being that, for reasons we could never hope to understand, is assuming the shape and general mannerisms of a parrot - or just a rather large bird."
	gender = FEMALE
	health = 750 //how sweet it is to be a god!
	maxHealth = 750
	mob_size = MOB_LARGE
	speak_emote = list("professes","speaks unto you","elaborates","proclaims")
	natural_weapon = /obj/item/natural_weapon/giant
	min_gas = null
	max_gas = null
	minbodytemp = 0
	universal_understand = TRUE
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	see_in_dark = 7
	can_escape = TRUE
	relax_chance = 60 //a gentle beast
	impatience = 10
	parrot_isize = ITEM_SIZE_LARGE
	simple_parrot = TRUE
	ability_cooldown = 2 MINUTES

	meat_amount = 10
	bone_amount = 20
	skin_amount = 20

	var/list/subspecies = list(/decl/parrot_subspecies,
								/decl/parrot_subspecies/purple,
								/decl/parrot_subspecies/blue,
								/decl/parrot_subspecies/green,
								/decl/parrot_subspecies/red,
								/decl/parrot_subspecies/brown,
								/decl/parrot_subspecies/black)
	var/get_subspecies_name = TRUE

	ai_holder = /datum/ai_holder/simple_animal/retaliate
	say_list = /datum/say_list/parrot/space

/mob/living/simple_animal/hostile/retaliate/parrot/space/Initialize()
	. = ..()
	var/subspecies_type = DEFAULTPICK(subspecies, null)
	if(subspecies_type)
		var/decl/parrot_subspecies/ps = decls_repository.get_decl(subspecies_type)
		icon_set = ps.icon_set
		skin_material = ps.feathers
		if(get_subspecies_name)
			SetName(ps.name)
	var/matrix/M = new
	M.Scale(2)
	transform = M
	update_icon()

/mob/living/simple_animal/hostile/retaliate/parrot/space/can_special_attack(mob/living/carbon/human/H)
	. = ..()

	if(!.)
		return FALSE
	if(!Adjacent(H))
		return FALSE

/mob/living/simple_animal/hostile/retaliate/parrot/space/do_special_attack(atom/A)
	. = ..()

	if(ishuman(A) && can_special_attack(A))
		var/mob/living/carbon/human/H = A
		if(prob(70))
			H.Weaken(rand(2,3))
			// cooldown_ability(ability_cooldown / 1.5)
			visible_message(SPAN_MFAUNA("\The [src] flaps its wings mightily and bowls over \the [H] with a gust!"))

		else if(H.get_equipped_item(slot_head))
			var/obj/item/clothing/head/HAT = H.get_equipped_item(slot_head)
			if(H.canUnEquip(HAT))
				visible_message(SPAN_MFAUNA("\The [src] rips \the [H]'s [HAT] off!"))
				// cooldown_ability(ability_cooldown)
				H.unEquip(HAT, get_turf(src))



//subtypes
/mob/living/simple_animal/hostile/retaliate/parrot/space/lesser
	name = "Avatar of the Howling Dark"
	subspecies = list(/decl/parrot_subspecies/black)
	get_subspecies_name = FALSE
	natural_weapon = /obj/item/natural_weapon/large
	health = 300
	maxHealth = 300

/mob/living/simple_animal/hostile/retaliate/parrot/space/megafauna
	name = "giant parrot"
	desc = "A huge parrot-like bird."
	get_subspecies_name = FALSE
	health = 350
	maxHealth = 350
	speak_emote = list("squawks")
	natural_weapon = /obj/item/natural_weapon/large
	relax_chance = 30
	impatience = 5

/datum/say_list/parrot/space
	speak = list("...")
	emote_hear = list("sings a song to herself", "preens herself")