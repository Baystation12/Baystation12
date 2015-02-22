// spybug ABILITIES
/mob/living/silicon/platform/spybug/verb/set_mail_tag()
	set name = "Set Mail Tag"
	set desc = "Tag yourself for delivery through the disposals system."
	set category = "Platform Abilities"

	var/new_tag = input("Select the desired destination.", "Set Mail Tag", null) as null|anything in tagger_locations

	if(!new_tag)
		mail_destination = ""
		return

	src << "\blue You configure your internal beacon, tagging yourself for delivery to '[new_tag]'."
	mail_destination = new_tag

	//Auto flush if we use this verb inside a disposal chute.
	var/obj/machinery/disposal/D = src.loc
	if(istype(D))
		src << "\blue \The [D] acknowledges your signal."
		D.flush_count = D.flush_every_ticks

	return

/mob/living/silicon/platform/spybug/verb/self_destruct()
	set name = "Self-Destruct"
	set desc = "Destroys the current platform beyond recovery."
	set category = "Platform Abilities"

	src.visible_message( \
			"[src] begins to emit a loud buzzing noise.", \
			"\blue You begin to emit a loud buzzing noise.", \
			"You hear a loud buzzing noise.")
	platform_disconnect()
	src.gib()
	return

/mob/living/silicon/platform/spybug/ventcrawl()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Platform Abilities"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	handle_ventcrawl()


//Actual picking-up event.
/mob/living/silicon/platform/spybug/attack_hand(mob/living/carbon/human/M as mob)
	if(M.a_intent == "help" || M.a_intent == "grab")
		get_scooped(M)
	..()

var/list/spybug_verbs_default = list(
	/mob/living/silicon/platform/spybug/verb/set_mail_tag,
	/mob/living/silicon/platform/spybug/verb/self_destruct,
	/mob/living/silicon/platform/spybug/ventcrawl
)