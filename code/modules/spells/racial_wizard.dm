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
	var/list/potentials = list("Resomi" = /spell/aoe_turf/conjure/summon/resomi, "Human" = /obj/item/weapon/storage/bag/cash/infinite, "Vox" = /spell/targeted/expunge)

/obj/item/weapon/magic_rock/attack_self(mob/user)
	if(!istype(user,/mob/living/carbon/human))
		user << "\The [src] can do nothing for such a simple being."
		return
	var/mob/living/carbon/human/H = user
	var/reward = potentials[H.species.get_bodytype()] //we get body type because that lets us ignore subspecies.
	if(!reward)
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
	user << "\The [src] disappears."
	qdel(src)

//RESOMI
/spell/aoe_turf/conjure/summon/resomi
	name = "Summon Nano Machines"
	desc = "This spell summons nano machines from the wizard's body to help them."

	school = "racial"
	spell_flags = 0
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
			var/obj/item/I = new /obj/item/weapon/spacecash/c1000()
			src.handle_item_insertion(I,1)


//VOX
/spell/targeted/expunge
	name = "Expunge"
	desc = "This spell exhudes a magically hideous oder."

	school = "racial"
	spell_flags = 0
	invocation_type = SpI_EMOTE
	invocation = "exhudes a horendous oder!"
	charge_max = 600 //2 minutes

	compatible_mobs = list(/mob/living/carbon/human)

	hud_state = "gen_eat"

	cast_sound = 'sound/voice/shriek1.ogg'

/spell/targeted/expunge/cast(var/list/targets, mob/user)
	for(var/mob/living/carbon/human/H in targets)
		H << "<span class='warning'>Oh god that smell!</span>"
		H.vomit()