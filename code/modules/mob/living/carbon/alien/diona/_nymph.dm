#define DIONA_SCREEN_LOC_HELD   "EAST-8:16,SOUTH:5"
#define DIONA_SCREEN_LOC_HAT    "EAST-7:16,SOUTH:5"
#define DIONA_SCREEN_LOC_INTENT "EAST-2,SOUTH:5"
#define DIONA_SCREEN_LOC_HEALTH ui_alien_health

/mob/living/carbon/alien/diona
	name = "diona nymph"
	desc = "It's a little skittery critter. Chirp."
	icon = 'icons/mob/gestalt.dmi'
	icon_state = "nymph"
	item_state = "nymph"
	death_msg = "expires with a pitiful chirrup..."

	language = LANGUAGE_ROOTLOCAL
	species_language = LANGUAGE_ROOTLOCAL
	only_species_language = 1
	voice_name = "diona nymph"
	speak_emote = list("chirrups")
	universal_understand = 0
	universal_speak = 0

	can_pull_size = ITEM_SIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	holder_type = /obj/item/weapon/holder/diona
	possession_candidate = 1
	atom_flags = ATOM_FLAG_NO_REACT
	hud_type = /datum/hud/diona_nymph

	var/emote_prob = 1
	var/wander_prob = 33
	var/obj/item/hat
	var/obj/item/holding_item
	var/mob/living/carbon/alien/diona/next_nymph
	var/mob/living/carbon/alien/diona/last_nymph
	var/tmp/image/flower
	var/tmp/image/eyes
	var/tmp/last_glow

/mob/living/carbon/alien/diona/Login()
	. = ..()
	if(client)
		if(holding_item)
			holding_item.screen_loc = DIONA_SCREEN_LOC_HELD
			client.screen |= holding_item
		if(hat)
			hat.screen_loc = DIONA_SCREEN_LOC_HAT
			client.screen |= hat

/mob/living/carbon/alien/diona/sterile
	name = "sterile nymph"
	emote_prob =  0
	wander_prob = 0

/mob/living/carbon/alien/diona/sterile/Initialize(var/mapload)
	. = ..(mapload, 0)

/mob/living/carbon/alien/diona/Initialize(var/mapload, var/flower_chance = 15)

	species = all_species[SPECIES_DIONA]
	add_language(LANGUAGE_ROOTGLOBAL)
	add_language(LANGUAGE_GALCOM)

	eyes = image(icon = icon, icon_state = "eyes_[icon_state]")
	eyes.layer = EYE_GLOW_LAYER
	eyes.plane = EFFECTS_ABOVE_LIGHTING_PLANE

	if(prob(flower_chance))
		flower = image(icon = icon, icon_state = "flower_back")
		var/image/I = image(icon = icon, icon_state = "flower_fore")
		I.color = get_random_colour(1)
		flower.overlays += I

	update_icons()

	. = ..(mapload)

/mob/living/carbon/alien/diona/examine(mob/user)
	. = ..()
	if(holding_item)
		to_chat(user, "<span class='notice'>It is holding \icon[holding_item] \a [holding_item].</span>")
	if(hat)
		to_chat(user, "<span class='notice'>It is wearing \icon[hat] \a [hat].</span>")

/mob/living/carbon/alien/diona/IsAdvancedToolUser()
	return FALSE

/mob/living/carbon/alien/diona/proc/handle_npc(var/mob/living/carbon/alien/diona/D)
	if(D.stat != CONSCIOUS)
		return
	if(prob(wander_prob) && isturf(D.loc) && !D.pulledby) //won't move if being pulled
		SelfMove(pick(GLOB.cardinal))
	if(prob(emote_prob))
		D.emote(pick("scratch","jump","chirp","tail"))

/proc/split_into_nymphs(var/mob/living/carbon/human/donor)

	if(!donor || donor.species.name != SPECIES_DIONA)
		return

	// Ensure we have enough nymphs.
	var/list/nymphs = list()
	for(var/mob/living/carbon/alien/diona/D in donor.contents)
		nymphs += D
	if(!nymphs.len)
		nymphs += new /mob/living/carbon/alien/diona/sterile(donor)

	// Work out where the mob client is going.
	var/mob/living/carbon/alien/diona/master_nymph
	for(var/thing in shuffle(nymphs))
		var/mob/living/carbon/alien/diona/check_nymph = thing
		if(!check_nymph.client) master_nymph = check_nymph
	if(!master_nymph)
		master_nymph = new /mob/living/carbon/alien/diona/sterile(donor)

	master_nymph.set_dir(donor.dir)
	transfer_languages(donor, master_nymph)
	if(donor.mind)
		donor.mind.transfer_to(master_nymph)
	else
		master_nymph.key = donor.key

	log_and_message_admins("has split into nymphs; player now controls [key_name_admin(master_nymph)]", donor)

	var/mob/living/carbon/alien/diona/last_nymph
	for(var/thing in nymphs)
		var/mob/living/carbon/alien/diona/nymph = thing
		nymph.dropInto(donor.loc)
		transfer_languages(donor, nymph, (WHITELISTED|RESTRICTED))
		nymph.set_dir(pick(NORTH, SOUTH, EAST, WEST))
		if(!nymph.client)
			if(last_nymph)
				nymph.set_last_nymph(last_nymph)
				last_nymph.set_next_nymph(nymph)
			last_nymph = nymph

	for(var/obj/item/W in donor)
		donor.drop_from_inventory(W)

	donor.visible_message("<span class='warning'>\The [donor] quivers slightly, then splits apart with a wet slithering noise.</span>")
	qdel(donor)
