/obj/item/disk/astrodata
	name = "astronomical data disk"
	desc = "A disk with a wealth of astronomical data recorded."
	icon = 'icons/obj/datadisks.dmi'
	icon_state = "datadisk0"
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL


/obj/structure/sign/ecplaque
	name = "\improper Expeditionary Directives"
	desc = "A plaque with Expeditionary Corps logo etched in it."
	icon = 'maps/torch/icons/obj/solgov-decals.dmi'
	icon_state = "ecplaque"
	var/directives = {"<hr><center>\
		<p>1. <b>Exploring the unknown is your Primary Mission</b>\
			<p>You are to look for land and resources that can be used by Humanity to advance and prosper. Explore. Document. Explain. Knowledge is the most valuable resource.</p>\
		</p>\
		<p>2. <b>Every member of the Expeditionary Corps is an explorer</b>\
			<p>Some are Explorers by rank or position, but everyone has to be one when duty calls. You should always expect being assigned to an expedition if needed. You have already volunteered when you signed up.</p>\
		</p>\
		<p>3. <b>Danger is a part of the mission - avoid, not run away</b>\
			<p>Keep your crew alive and hull intact, but remember - you are not here to sightsee. Dangers are obstacles to be cleared, not the roadblocks. Weigh risks carefully and keep your Primary Mission in mind.</p>\
		</p>\
		</center><hr>\
		"}


/obj/structure/sign/ecplaque/examine(mob/user)
	. = ..()
	to_chat(user, "The founding principles of EC are written there: <A href='?src=\ref[src];show_info=1'>Expeditionary Directives</A>")


/obj/structure/sign/ecplaque/CanUseTopic()
	return STATUS_INTERACTIVE


/obj/structure/sign/ecplaque/OnTopic(href, href_list)
	if (href_list["show_info"])
		to_chat(usr, directives)
		return TOPIC_HANDLED


/obj/structure/sign/ecplaque/use_grab(obj/item/grab/grab, list/click_params)
	if (!ishuman(grab.affecting))
		return ..()
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
