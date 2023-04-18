/obj/structure/sign/dedicationplaque
	name = "\improper SEV Torch dedication plaque"
	icon_state = "lightplaque"

/obj/structure/sign/dedicationplaque/Initialize()
	. = ..()
	desc = "S.E.V. Torch - Mako Class - Sol Expeditionary Corps Registry 95519 - Shiva Fleet Yards, Mars - First Vessel To Bear The Name - Launched [GLOB.using_map.game_year - 5] - Sol Central Government - 'Never was anything great achieved without danger.'"

/obj/structure/sign/ecplaque
	name = "\improper Expeditionary Directives"
	desc = "A plaque with Expeditionary Corps logo etched in it."
	icon = 'maps/torch/icons/obj/solgov-decals.dmi'
	icon_state = "ecplaque"
	var/directives = {"<hr><center>
		1. <b>Exploring the unknown is your Primary Mission</b><br>

		You are to look for land and resources that can be used by Humanity to advance and prosper. Explore. Document. Explain. Knowledge is the most valuable resource.<br>

		2. <b>Every member of the Expeditionary Corps is an explorer</b><br>

		Some are Explorers by rank or position, but everyone has to be one when duty calls. You should always expect being assigned to an expedition if needed. You have already volunteered when you signed up.<br>

		3. <b>Danger is a part of the mission - avoid, not run away</b> <br>

		Keep your crew alive and hull intact, but remember - you are not here to sightsee. Dangers are obstacles to be cleared, not the roadblocks. Weigh risks carefully and keep your Primary Mission in mind.
		</center><hr>"}

/obj/structure/sign/ecplaque/examine(mob/user)
	. = ..()
	to_chat(user, "The founding principles of EC are written there: <A href='?src=\ref[src];show_info=1'>Expeditionary Directives</A>")

/obj/structure/sign/ecplaque/CanUseTopic()
	return STATUS_INTERACTIVE

/obj/structure/sign/ecplaque/OnTopic(href, href_list)
	if(href_list["show_info"])
		to_chat(usr, directives)
		return TOPIC_HANDLED


/obj/structure/sign/ecplaque/use_grab(obj/item/grab/grab, list/click_params)
	if (!ishuman(grab.affecting))
		return ..()

	// Harm intent - Bash against the plaque
	if (grab.assailant.a_intent == I_HURT)
		grab.assailant.setClickCooldown(grab.assailant.get_attack_speed(grab))
		grab.affecting.apply_damage(5, DAMAGE_BRUTE, BP_HEAD, used_weapon = src)
		grab.assailant.visible_message(
			SPAN_WARNING("\The [grab.assailant] smashes \the [grab.affecting] into \the [src] face-first!"),
			SPAN_DANGER("You smash \the [grab.affecting] into \the [src] face-first!"),
			exclude_mobs = list(grab.affecting)
		)
		grab.affecting.show_message(
			SPAN_DANGER("\The [grab.assailant] smashes you into \the [src] face-first!"),
			VISIBLE_MESSAGE,
			SPAN_DANGER("You feel your face being smashed into something!")
		)
		playsound(src, 'sound/weapons/tablehit1.ogg', 50, TRUE)
		grab.force_drop()
		admin_attack_log(grab.assailant, grab.affecting, "educated victim on \the [src].", "Was educated on \the [src].", "used \a [src] to educate")
		return TRUE

	return ..()


/obj/effect/floor_decal/scglogo
	alpha = 230
	icon = 'maps/torch/icons/obj/solgov_floor.dmi'
	icon_state = "center"

/obj/structure/sign/solgov
	name = "\improper SolGov Seal"
	desc = "A sign which signifies who this vessel belongs to."
	icon = 'maps/torch/icons/obj/solgov-decals.dmi'
	icon_state = "solgovseal"

/obj/structure/sign/double/solgovflag
	name = "\improper Sol Central Government Flag"
	desc = "The flag of the Sol Central Government, a symbol of many things to many people."
	icon = 'maps/torch/icons/obj/solgov-decals.dmi'

/obj/structure/sign/double/solgovflag/left
	icon_state = "solgovflag-left"

/obj/structure/sign/double/solgovflag/right
	icon_state = "solgovflag-right"

/obj/structure/sign/memorial
	name = "memorial rock"
	desc = "A large stone slab, engraved with the names of uniformed personnel who gave their lives for scientific progress. Not a list you'd want to make. Add the dog tags of the fallen to the monument to memorialize them."
	icon = 'maps/torch/icons/obj/solgov-64x.dmi'
	icon_state = "memorial"
	density = TRUE
	anchored = TRUE
	pixel_x = -16
	pixel_y = -16
	unacidable = TRUE
	var/list/fallen = list()
	var/list/accepted_branches = list(
		"Expeditionary Corps",
		"Fleet"
	)


/obj/structure/sign/memorial/use_tool(obj/item/tool, mob/user, list/click_params)
	// Dog Tags - Add dog tag
	if (istype(tool, /obj/item/clothing/accessory/badge/solgov/tags))
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		var/obj/item/clothing/accessory/badge/solgov/tags/dog_tags = tool
		if (!(dog_tags.owner_branch in accepted_branches))
			USE_FEEDBACK_FAILURE("\The [src] only accepts dog tags from the [english_list(accepted_branches, and_text = " or ")] branches.")
			return TRUE
		fallen += "[dog_tags.owner_rank] [dog_tags.owner_name] | [dog_tags.owner_branch]"
		user.visible_message(
			SPAN_NOTICE("\The [user] adds \a [tool] to \the [src]."),
			SPAN_NOTICE("You add \the [dog_tags.owner_name]'s [tool.name] to \the [src].")
		)
		qdel(dog_tags)
		return TRUE

	return ..()


/obj/structure/sign/memorial/examine(mob/user, distance)
	. = ..()
	if (distance <= 2 && length(fallen))
		to_chat(user, "<b>The fallen:</b> [jointext(fallen, "<br>")]")
