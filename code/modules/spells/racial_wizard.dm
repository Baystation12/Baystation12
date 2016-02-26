//this file is full of all the racial spells/artifacts/etc that each species has.

/obj/item/weapon/magic_rock
	name = "magical rock"
	desc = "Legends say that this rock will unlock the true potential of anyone who touches it."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "magic rock"
	w_class = 2
	throw_speed = 1
	throw_range = 3
	force = 15
	var/list/potentials = list("Resomi" = /spell/aoe_turf/conjure/summon/resomi, "Human" = /obj/item/weapon/storage/bag/cash/infinite, "Vox" = /spell/targeted/shapeshift/true_form,
		"Tajara" = /spell/messa_shroud, "Unathi" = /spell/moghes_blessing, "Diona" = /spell/aoe_turf/conjure/grove/gestalt)

/obj/item/weapon/magic_rock/attack_self(mob/user)
	if(!istype(user,/mob/living/carbon/human))
		user << "\The [src] can do nothing for such a simple being."
		return
	var/mob/living/carbon/human/H = user
	var/reward = potentials[H.species.get_bodytype()] //we get body type because that lets us ignore subspecies.
	if(!reward)
		user << "\The [src] does not know what to make of you."
		return
	for(var/spell/S in user.spell_list)
		if(istype(S,reward))
			user << "\The [src] can do no more for you."
			return
	user.drop_from_inventory(src)
	var/a = new reward()
	if(ispath(reward,/spell))
		H.add_spell(a)
	else if(ispath(reward,/obj))
		H.put_in_hands(a)
	user << "\The [src] crumbles in your hands."
	qdel(src)

//RESOMI
/spell/aoe_turf/conjure/summon/resomi
	name = "Summon Nano Machines"
	desc = "This spell summons nano machines from the wizard's body to help them."

	school = "racial"
	spell_flags = Z2NOCAST
	invocation_type = SpI_EMOTE
	invocation = "spasms a moment as nanomachines come out of a port on his back!"

	level_max = list(Sp_TOTAL = 0, Sp_SPEED = 0, Sp_POWER = 0)

	name_summon = 1

	charge_type = Sp_HOLDVAR
	holder_var_type = "shock_stage"
	holder_var_amount = 15

	hud_state = "wiz_resomi"

	summon_amt = 1
	summon_type = list(/mob/living/simple_animal/hostile/commanded/nanomachine)

/spell/aoe_turf/conjure/summon/resomi/before_cast()
	..()
	newVars["master"] = holder

/spell/aoe_turf/conjure/summon/resomi/take_charge(mob/user = user, var/skipcharge)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(H && H.shock_stage >= 30)
		H.visible_message("<b>[user]</b> drops to the floor, thrashing wildly while foam comes from their mouth.")
		H.Paralyse(20)
		H.adjustBrainLoss(10)


//HUMAN
/obj/item/weapon/storage/bag/cash/infinite/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..()
	if(.)
		if(istype(W,/obj/item/weapon/spacecash)) //only matters if its spacecash.
			var/obj/item/I = new /obj/item/weapon/spacecash/bundle/c1000()
			src.handle_item_insertion(I,1)


//Tajaran
/spell/messa_shroud
	name = "Messa's Shroud"
	desc = "This spell causes darkness at the point of the caster for a duration of time."

	school = "racial"
	spell_flags = 0
	invocation_type = SpI_EMOTE
	invocation = "mutters a small prayer, the light around them darkening."
	charge_max = 300 //30 seconds

	range = 5
	duration = 150 //15 seconds

	cast_sound = 'sound/effects/bamf.ogg'

	hud_state = "wiz_tajaran"

/spell/messa_shroud/choose_targets()
	return list(get_turf(holder))

/spell/messa_shroud/cast(var/list/targets, mob/user)
	var/turf/T = targets[1]

	if(!istype(T))
		return

	var/obj/O = new /obj(T)
	playsound(T,cast_sound,50,1)
	O.set_light(range, -10, "#FFFFFF")

	spawn(duration)
		qdel(O)

//VOX
/spell/targeted/shapeshift/true_form
	name = "True Form"
	desc = "Pay respect to your heritage. Become what you once were."

	school = "racial"
	spell_flags = INCLUDEUSER
	invocation_type = SpI_EMOTE
	range = -1
	invocation = "begins to grow!"
	charge_max = 1200 //2 minutes
	duration = 300 //30 seconds

	smoke_amt = 5
	smoke_spread = 1

	possible_transformations = list(/mob/living/simple_animal/armalis)

	hud_state = "wiz_vox"

	cast_sound = 'sound/voice/shriek1.ogg'
	revert_sound = 'sound/voice/shriek1.ogg'

	drop_items = 0


//UNATHI
/spell/moghes_blessing
	name = "Moghes Blessing"
	desc = "Imbue your weapon with memories of Moghe"

	school = "racial"
	spell_flags = 0
	invocation_type = SpI_EMOTE
	invocation = "whispers something."
	charge_type = Sp_HOLDVAR
	holder_var_type = "bruteloss"
	holder_var_amount = 10

	hud_state = "wiz_unathi"

/spell/moghes_blessing/choose_targets(mob/user = usr)
	var/list/hands = list()
	if(user.l_hand && !findtext(user.l_hand.name,"Moghes Blessing"))
		hands += user.l_hand
	if(user.r_hand && !findtext(user.r_hand.name,"Moghes Blessing"))
		hands += user.r_hand
	return hands

/spell/moghes_blessing/cast(var/list/targets, mob/user)
	for(var/obj/item/I in targets)
		I.name = "[I.name] (Moghes Blessing)"
		I.force += 10
		I.throwforce += 7
		I.color = "#663300"


//DIONA
/spell/aoe_turf/conjure/grove/gestalt
	name = "Convert Gestalt"
	desc = "Converts the surrounding area into a Dionaea gestalt."

	invocation_type = SpI_EMOTE
	invocation = "rumbles as green alien plants grow quickly along the floor."

	charge_type = Sp_HOLDVAR
	holder_var_type = "bruteloss"
	holder_var_amount = 20

	spell_flags = Z2NOCAST | IGNOREPREV | IGNOREDENSE
	summon_type = list(/turf/simulated/floor/diona)
	seed_type = /datum/seed/diona

	hud_state = "wiz_diona"