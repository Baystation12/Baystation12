//this file is full of all the racial spells/artifacts/etc that each species has.

/obj/item/weapon/magic_rock
	name = "magical rock"
	desc = "Legends say that this rock will unlock the true potential of anyone who touches it."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "magic rock"
	w_class = ITEM_SIZE_SMALL
	throw_speed = 1
	throw_range = 3
	force = 15
	var/list/potentials = list(SPECIES_RESOMI = /spell/aoe_turf/conjure/summon/resomi, SPECIES_HUMAN = /obj/item/weapon/storage/bag/cash/infinite, SPECIES_VOX = /spell/targeted/shapeshift/true_form,
		SPECIES_TAJARA = /spell/messa_shroud, SPECIES_UNATHI = /spell/moghes_blessing, SPECIES_DIONA = /spell/aoe_turf/conjure/grove/gestalt, SPECIES_SKRELL = /obj/item/weapon/contract/apprentice/skrell,
		SPECIES_IPC = /spell/camera_connection)

/obj/item/weapon/magic_rock/attack_self(mob/user)
	if(!istype(user,/mob/living/carbon/human))
		to_chat(user, "\The [src] can do nothing for such a simple being.")
		return
	var/mob/living/carbon/human/H = user
	var/reward = potentials[H.species.get_bodytype(H)] //we get body type because that lets us ignore subspecies.
	if(!reward)
		to_chat(user, "\The [src] does not know what to make of you.")
		return
	for(var/spell/S in user.mind.learned_spells)
		if(istype(S,reward))
			to_chat(user, "\The [src] can do no more for you.")
			return
	user.drop_from_inventory(src)
	var/a = new reward()
	if(ispath(reward,/spell))
		H.add_spell(a)
	else if(ispath(reward,/obj))
		H.put_in_hands(a)
	to_chat(user, "\The [src] crumbles in your hands.")
	qdel(src)

//RESOMI
/spell/aoe_turf/conjure/summon/resomi
	name = "Summon Nano Machines"
	desc = "This spell summons nano machines from the wizard's body to help them."

	school = "racial"
	spell_flags = Z2NOCAST
	invocation_type = SpI_EMOTE
	invocation = "spasms a moment as nanomachines come out of a port on their back!"

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

/obj/item/weapon/storage/bag/cash/infinite
	startswith = list(/obj/item/weapon/spacecash/bundle/c1000 = 1)


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

	possible_transformations = list(/mob/living/simple_animal/hostile/armalis)

	hud_state = "wiz_vox"

	cast_sound = 'sound/voice/shriek1.ogg'
	revert_sound = 'sound/voice/shriek1.ogg'

	drop_items = 0


//UNATHI
/spell/moghes_blessing
	name = "Moghes Blessing"
	desc = "Imbue your weapon with memories of Moghes"

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
	for(var/obj/item/I in list(user.l_hand, user.r_hand))
		//make sure it's not already blessed
		if(istype(I) && !has_extension(I, /datum/extension/moghes_blessing))
			hands += I
	return hands

/spell/moghes_blessing/cast(var/list/targets, mob/user)
	for(var/obj/item/I in targets)
		set_extension(I, /datum/extension/moghes_blessing, /datum/extension/moghes_blessing)

/datum/extension/moghes_blessing
	expected_type = /obj/item
	flags = EXTENSION_FLAG_IMMEDIATE

/datum/extension/moghes_blessing/New(var/datum/holder)
	..(holder)
	apply_blessing(holder)

/datum/extension/moghes_blessing/proc/apply_blessing(obj/item/I)
	I.name += " of Moghes"
	I.desc += "<BR>It has been imbued with the memories of Moghes."
	I.force += 10
	I.throwforce += 14
	I.color = "#663300"

//DIONA
/spell/aoe_turf/conjure/grove/gestalt
	name = "Convert Gestalt"
	desc = "Converts the surrounding area into a Dionaea gestalt."

	school = "racial"
	spell_flags = 0
	invocation_type = SpI_EMOTE
	invocation = "rumbles as green alien plants grow quickly along the floor."

	charge_type = Sp_HOLDVAR
	holder_var_type = "bruteloss"
	holder_var_amount = 20

	spell_flags = Z2NOCAST | IGNOREPREV | IGNOREDENSE
	summon_type = list(/turf/simulated/floor/diona)
	seed_type = /datum/seed/diona

	hud_state = "wiz_diona"

//SKRELL
/obj/item/weapon/contract/apprentice/skrell
	name = "skrellian apprenticeship contract"
	var/obj/item/weapon/spellbook/linked
	color = "#3366ff"
	contract_spells = list(/spell/contract/return_master) //somewhat of a necessity due to how many spells they would have after a while.

/obj/item/weapon/contract/apprentice/skrell/New(var/newloc,var/spellbook, var/owner)
	..()
	if(istype(spellbook,/obj/item/weapon/spellbook))
		linked = spellbook
	if(istype(owner,/mob))
		contract_master = owner

/obj/item/weapon/contract/apprentice/skrell/attack_self(mob/user as mob)
	if(!linked)
		to_chat(user, "<span class='warning'>This contract requires a link to a spellbook.</span>")
		return
	..()

/obj/item/weapon/contract/apprentice/skrell/afterattack(atom/A, mob/user as mob, proximity)
	if(!linked && istype(A,/obj/item/weapon/spellbook))
		linked = A
		to_chat(user, "<span class='notice'>You've linked \the [A] to \the [src]</span>")
		return
	..()

/obj/item/weapon/contract/apprentice/skrell/contract_effect(mob/user as mob)
	. = ..()
	if(.)
		linked.uses += 0.5
		var/obj/item/I = new /obj/item/weapon/contract/apprentice/skrell(get_turf(src),linked,contract_master)
		user.put_in_hands(I)
		new /obj/item/weapon/contract/apprentice/skrell(get_turf(src),linked,contract_master)

//IPC
/spell/camera_connection
	name = "Camera Connection"
	desc = "This spell allows the wizard to connect to the local camera network and see what it sees."

	school = "racial"

	invocation_type = SpI_EMOTE
	invocation = "emits a beeping sound before standing very, very still."

	charge_max = 600 //1 minute
	charge_type = Sp_RECHARGE


	spell_flags = Z2NOCAST
	hud_state = "wiz_IPC"
	var/mob/observer/eye/vision
	var/eye_type = /mob/observer/eye/wizard_eye

/spell/camera_connection/New()
	..()
	vision = new eye_type(src)

/spell/camera_connection/Destroy()
	qdel(vision)
	vision = null
	. = ..()

/spell/camera_connection/choose_targets()
	var/mob/living/L = holder
	if(!istype(L) || L.eyeobj) //no using if we already have an eye on.
		return null
	return list(holder)

/spell/camera_connection/cast(var/list/targets, mob/user)
	var/mob/living/L = targets[1]

	vision.possess(L)
	L.verbs += /mob/living/proc/release_eye

/mob/observer/eye/wizard_eye
	name_sufix = "Wizard Eye"

/mob/observer/eye/wizard_eye/New() //we dont use the Ai one because it has AI specific procs imbedded in it.
	..()
	visualnet = cameranet

/mob/living/proc/release_eye()
	set name = "Release Vision"
	set desc = "Return your sight to your body."
	set category = "Abilities"

	verbs -= /mob/living/proc/release_eye //regardless of if we have an eye or not we want to get rid of this verb.

	if(!eyeobj)
		return
	eyeobj.release(src)

/mob/observer/eye/wizard_eye/Destroy()
	if(istype(eyeobj.owner, /mob/living))
		var/mob/living/L = eyeobj.owner
		L.release_eye()
	qdel(eyeobj)
	return ..()