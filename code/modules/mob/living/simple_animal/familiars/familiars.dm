/mob/living/simple_animal/familiar
	name = "familiar"
	desc = "No wizard is complete without a mystical sidekick."
	supernatural = 1

	response_help = "pets"
	response_disarm = "pushes"
	response_harm = "hits"

	universal_speak = FALSE
	universal_understand = TRUE

	min_gas = list(GAS_OXYGEN = 1)
	max_gas = null
	unsuitable_atmos_damage = 1

	var/list/wizardy_spells = list()

/mob/living/simple_animal/familiar/New()
	..()
	add_language(LANGUAGE_HUMAN_EURO)
	for(var/spell in wizardy_spells)
		src.add_spell(new spell, "const_spell_ready")

/mob/living/simple_animal/familiar/carcinus
	name = "carcinus"
	desc = "A small crab said to be made of stone and starlight."
	icon = 'icons/mob/simple_animal/animal.dmi'
	icon_state = "evilcrab"
	icon_living = "evilcrab"
	icon_dead = "evilcrab_dead"

	speak_emote = list("chitters","clicks")


	health = 200
	maxHealth = 200
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "pinches"
	resistance = 9
	can_escape = TRUE //snip snip

/*familiar version of the Pike w/o all the other hostile/carp stuff getting in the way (namely life)
*/

/mob/living/simple_animal/familiar/pike
	name = "space pike"
	desc = "A bigger, more magical cousin of the space carp."

	icon = 'icons/mob/simple_animal/spaceshark.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	pixel_x = -16

	speak_emote = list("gnashes")

	health = 100
	maxHealth = 100
	melee_damage_lower = 10
	melee_damage_upper = 10
	can_escape = TRUE

	min_gas = null

	wizardy_spells = list(/spell/aoe_turf/conjure/forcewall)

/mob/living/simple_animal/familiar/pike/Allow_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/familiar/horror
	name = "horror"
	desc = "Looking at it fills you with dread."
	icon = 'icons/mob/mob.dmi'
	icon_state = "horror"
	icon_living = "horror"

	speak_emote = list("moans", "groans")

	response_help = "thinks better of touching"

	health = 150
	maxHealth = 150
	melee_damage_lower = 5
	melee_damage_upper = 8
	attacktext = "touches"

	wizardy_spells = list(/spell/targeted/torment)

/mob/living/simple_animal/familiar/horror/death(gibbed, deathmessage, show_dead_message)
	..(null,"rapidly deteriorates","The bonds tying you to this mortal plane have been severed.")

	ghostize()
	gibs(src.loc)
	qdel(src)


/mob/living/simple_animal/familiar/minor_amaros
	name = "minor amaros"
	desc = "A small fluffy alien creature."
	icon = 'icons/mob/mob.dmi'
	icon_state = "baby roro"
	icon_living = "baby roro"
	icon_dead   = "baby roro dead"

	speak_emote = list("entones")
	mob_size = MOB_SMALL

	health = 25
	maxHealth = 25

	wizardy_spells = list(/spell/targeted/heal_target,
						/spell/targeted/heal_target/area)



/mob/living/simple_animal/familiar/pet //basically variants of normal animals with spells.
	icon = 'icons/mob/simple_animal/animal.dmi'
	var/icon_rest //so that we can have resting little guys.

/mob/living/simple_animal/familiar/pet/Life()
	. = ..()
	if(!.)
		return FALSE
	if(!icon_rest)
		return
	if(stat == UNCONSCIOUS || resting)
		icon_state = icon_rest

/mob/living/simple_animal/familiar/pet/mouse
	name = "mouse"
	desc = "A small rodent. It looks very old."
	icon_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	icon_rest = "mouse_gray_sleep"

	speak_emote = list("squeeks")
	holder_type = /obj/item/weapon/holder/mouse
	pass_flags = PASS_FLAG_TABLE
	mob_size = MOB_MINISCULE

	response_harm = "stamps on"

	health = 15
	maxHealth = 15
	melee_damage_lower = 1
	melee_damage_upper = 1
	can_escape = TRUE
	attacktext = "nibbles"

	wizardy_spells = list(/spell/aoe_turf/smoke)

/mob/living/simple_animal/familiar/pet/mouse/New()
	..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

/mob/living/simple_animal/familiar/pet/cat
	name = "black cat"
	desc = "A pitch black cat. Said to be especially unlucky."
	icon_state = "cat3"
	icon_living = "cat3"
	icon_dead = "cat3_dead"
	icon_rest = "cat3_rest"


	speak_emote = list("meows", "purrs")
	holder_type = /obj/item/weapon/holder/cat
	mob_size = MOB_SMALL

	health = 25
	maxHealth = 25
	melee_damage_lower = 3
	melee_damage_upper = 4
	attacktext = "scratched"

	wizardy_spells = list(/spell/targeted/subjugation)
