/mob/living/simple_animal/shade/narsie
	maxHealth = 9001
	health = 9001
	status_flags = GODMODE
	layer = OBFUSCATION_LAYER + 0.1
	invisibility = INVISIBILITY_OBSERVER
	see_invisible = SEE_INVISIBLE_CULT

	var/influence_max = 0
	var/influence_target = 0
	var/influence_current = 0
	var/last_influence_change = 0

/mob/living/simple_animal/shade/narsie/New()
	..()
	src.sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
	last_influence_change = world.time

	make_floating(1)

/mob/living/simple_animal/shade/narsie/stop_floating()

/mob/living/simple_animal/shade/narsie/say(var/message)
	if(HasSufficientInfluenceFeedback())
		..()

/mob/living/simple_animal/shade/narsie/emote(var/act, var/type, var/desc)
	if(HasSufficientInfluenceFeedback())
		..()

/mob/living/simple_animal/shade/narsie/visible_emote(var/act_desc)
	if(HasSufficientInfluenceFeedback())
		..()

/mob/living/simple_animal/shade/narsie/audible_emote(var/act_desc)
	if(HasSufficientInfluenceFeedback())
		..()

/mob/living/simple_animal/shade/narsie/attack_hand()
	if(HasSufficientInfluenceFeedback())
		..()

/mob/living/simple_animal/shade/narsie/UnarmedAttack()
	if(HasSufficientInfluenceFeedback())
		..()

/mob/living/simple_animal/shade/narsie/hear_say()
	if(HasSufficientInfluence())
		..()

/mob/living/simple_animal/shade/narsie/hear_radio()
	if(HasSufficientInfluence())
		..()

/mob/living/simple_animal/shade/narsie/proc/HasSufficientInfluenceFeedback()
	. = HasSufficientInfluence()
	if(!.)
		src << "You do not yet have the influence to interact directly with the mortal realm."

/mob/living/simple_animal/shade/narsie/proc/HasSufficientInfluence()
	return invisibility <= SEE_INVISIBLE_LIVING

/mob/living/simple_animal/shade/narsie/verb/TargetInfluence()
	set category = "Mask of Nar-Sie"
	set name = "Set Target Influence"

	var/influence = input("Set the target influence level", "Set influence", influence_target) as num|null
	if(isnum(influence))
		influence_target = influence

/mob/living/simple_animal/shade/narsie/verb/MaxInfluence()
	set category = "Mask of Nar-Sie"
	set name = "Set Max Influence"

	var/influence = input("Set the max influence level", "Set influence", influence_max) as num|null
	if(isnum(influence))
		influence_max = influence

/mob/living/simple_animal/shade/narsie/Life()
	..()
	ProcessHUD()
	ProcessInfluence()

/mob/living/simple_animal/shade/narsie/OnDeathInLife()

/mob/living/simple_animal/shade/narsie/proc/ProcessHUD()
	if(client)
		client.screen.Remove(global_hud.blurry, global_hud.druggy, global_hud.vimpaired, global_hud.darkMask, global_hud.nvg, global_hud.thermal, global_hud.meson, global_hud.science)

		client.screen |= global_hud.science

/mob/living/simple_animal/shade/narsie/proc/ProcessInfluence()
	var/ticks_since_last = world.time - last_influence_change
	last_influence_change = world.time

	if(influence_target > influence_max)
		influence_target = influence_max

	if(influence_current < influence_target)
		influence_current += round(ticks_since_last/10,1)

	if(influence_current > influence_target)
		influence_current = influence_target

/mob/living/simple_animal/shade/narsie/Stat()
	if(statpanel("Mask of Nar-Sie"))
		stat(null, "Influence: [influence_current]/[influence_max]")
	..()
