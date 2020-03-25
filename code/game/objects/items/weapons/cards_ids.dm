/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the IC data card reader
 */
/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS

/obj/item/weapon/card/union
	name = "union card"
	desc = "A card showing membership in the local worker's union."
	icon_state = "union"
	slot_flags = SLOT_ID
	var/signed_by

/obj/item/weapon/card/union/examine(mob/user)
	. = ..()
	if(signed_by)
		to_chat(user, "It has been signed by [signed_by].")
	else
		to_chat(user, "It has a blank space for a signature.")

/obj/item/weapon/card/union/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/weapon/pen))
		if(signed_by)
			to_chat(user, SPAN_WARNING("\The [src] has already been signed."))
		else
			var/signature = sanitizeSafe(input("What do you want to sign the card as?", "Union Card") as text, MAX_NAME_LEN)
			if(signature && !signed_by && !user.incapacitated() && Adjacent(user))
				signed_by = signature
				user.visible_message(SPAN_NOTICE("\The [user] signs \the [src] with a flourish."))
		return
	..()

/obj/item/weapon/card/data
	name = "data card"
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one has a stripe running down the middle."
	icon_state = "data_1"
	var/detail_color = COLOR_ASSEMBLY_ORANGE
	var/function = "storage"
	var/data = "null"
	var/special = null
	var/list/files = list(  )

/obj/item/weapon/card/data/Initialize()
	.=..()
	update_icon()

/obj/item/weapon/card/data/on_update_icon()
	overlays.Cut()
	var/image/detail_overlay = image('icons/obj/card.dmi', src,"[icon_state]-color")
	detail_overlay.color = detail_color
	overlays += detail_overlay

/obj/item/weapon/card/data/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/device/integrated_electronics/detailer))
		var/obj/item/device/integrated_electronics/detailer/D = I
		detail_color = D.detail_color
		update_icon()
	return ..()

/obj/item/weapon/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/obj/item/weapon/card/data/full_color
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one has the entire card colored."
	icon_state = "data_2"

/obj/item/weapon/card/data/disk
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one inexplicibly looks like a floppy disk."
	icon_state = "data_3"

/*
 * ID CARDS
 */

/obj/item/weapon/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ESOTERIC = 2)

/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ESOTERIC = 2)
	var/uses = 10

	var/static/list/card_choices = list(
							/obj/item/weapon/card/emag,
							/obj/item/weapon/card/union,
							/obj/item/weapon/card/data,
							/obj/item/weapon/card/data/full_color,
							/obj/item/weapon/card/data/disk,
							/obj/item/weapon/card/id,
						) //Should be enough of a selection for most purposes

var/const/NO_EMAG_ACT = -50
/obj/item/weapon/card/emag/resolve_attackby(atom/A, mob/user)
	var/used_uses = A.emag_act(uses, user, src)
	if(used_uses == NO_EMAG_ACT)
		return ..(A, user)

	uses -= used_uses
	A.add_fingerprint(user)
	if(used_uses)
		log_and_message_admins("emagged \an [A].")

	if(uses<1)
		user.visible_message("<span class='warning'>\The [src] fizzles and sparks - it seems it's been used once too often, and is now spent.</span>")
		var/obj/item/weapon/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)

	return 1

/obj/item/weapon/card/emag/Initialize()
	. = ..()
	if(length(card_choices) && !card_choices[card_choices[1]])
		card_choices = generate_chameleon_choices(card_choices)

/obj/item/weapon/card/emag/verb/change(picked in card_choices)
	set name = "Change Cryptographic Sequencer Appearance"
	set category = "Chameleon Items"
	set src in usr

	if (!(usr.incapacitated()))
		if(!ispath(card_choices[picked]))
			return

		disguise(card_choices[picked], usr)

/obj/item/weapon/card/emag/examine(mob/user)
	. = ..()
	if(user.skill_check(SKILL_DEVICES,SKILL_ADEPT))
		to_chat(user, SPAN_WARNING("This ID card has some form of non-standard modifications."))

/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access."
	icon_state = "base"
	item_state = "card-id"
	slot_flags = SLOT_ID

	var/list/access = list()
	var/registered_name = "Unknown" // The name registered_name on the card
	var/associated_account_number = 0
	var/list/associated_email_login = list("login" = "", "password" = "")

	var/age = "\[UNSET\]"
	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/sex = "\[UNSET\]"
	var/icon/front
	var/icon/side

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0			// determines if this ID has claimed a dorm already

	var/job_access_type     // Job type to acquire access rights from, if any

	var/datum/mil_branch/military_branch = null //Vars for tracking branches and ranks on multi-crewtype maps
	var/datum/mil_rank/military_rank = null

	var/formal_name_prefix
	var/formal_name_suffix

	var/detail_color
	var/extra_details

/obj/item/weapon/card/id/Initialize()
	.=..()
	if(job_access_type)
		var/datum/job/j = SSjobs.get_by_path(job_access_type)
		if(j)
			rank = j.title
			assignment = rank
			access |= j.get_access()
			if(!detail_color)
				detail_color = j.selection_color
	update_icon()

/obj/item/weapon/card/id/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	ret.overlays += overlay_image(ret.icon, "[ret.icon_state]_colors", detail_color, RESET_COLOR)
	return ret

/obj/item/weapon/card/id/on_update_icon()
	overlays.Cut()
	overlays += overlay_image(icon, "[icon_state]_colors", detail_color, RESET_COLOR)
	for(var/detail in extra_details)
		overlays += overlay_image(icon, detail, flags=RESET_COLOR)

/obj/item/weapon/card/id/CanUseTopic(var/user)
	if(user in view(get_turf(src)))
		return STATUS_INTERACTIVE

/obj/item/weapon/card/id/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["look_at_id"])
		if(istype(user))
			user.examinate(src)
			return TOPIC_HANDLED

/obj/item/weapon/card/id/examine(mob/user, distance)
	. = ..()
	to_chat(user, "It says '[get_display_name()]'.")
	if(distance <= 1)
		show(user)

/obj/item/weapon/card/id/proc/prevent_tracking()
	return 0

/obj/item/weapon/card/id/proc/show(mob/user as mob)
	if(front && side)
		send_rsc(user, front, "front.png")
		send_rsc(user, side, "side.png")
	var/datum/browser/popup = new(user, "idcard", name, 600, 250)
	popup.set_content(dat())
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/item/weapon/card/id/proc/get_display_name()
	. = registered_name
	if(military_rank && military_rank.name_short)
		. ="[military_rank.name_short] [.][formal_name_suffix]"
	else if(formal_name_prefix || formal_name_suffix)
		. = "[formal_name_prefix][.][formal_name_suffix]"
	if(assignment)
		. += ", [assignment]"

/obj/item/weapon/card/id/proc/set_id_photo(var/mob/M)
	front = getFlatIcon(M, SOUTH, always_use_defdir = 1)
	side = getFlatIcon(M, WEST, always_use_defdir = 1)

/mob/proc/set_id_info(var/obj/item/weapon/card/id/id_card)
	id_card.age = 0

	id_card.formal_name_prefix = initial(id_card.formal_name_prefix)
	id_card.formal_name_suffix = initial(id_card.formal_name_suffix)
	if(client && client.prefs)
		for(var/culturetag in client.prefs.cultural_info)
			var/decl/cultural_info/culture = SSculture.get_culture(client.prefs.cultural_info[culturetag])
			if(culture)
				id_card.formal_name_prefix = "[culture.get_formal_name_prefix()][id_card.formal_name_prefix]"
				id_card.formal_name_suffix = "[id_card.formal_name_suffix][culture.get_formal_name_suffix()]"

	id_card.registered_name = real_name

	var/gender_term = "Unset"
	var/datum/gender/G = gender_datums[get_sex()]
	if(G)
		gender_term = gender2text(G.formal_term)
	id_card.sex = gender2text(gender_term)
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)

/mob/living/carbon/human/set_id_info(var/obj/item/weapon/card/id/id_card)
	..()
	id_card.age = age
	if(GLOB.using_map.flags & MAP_HAS_BRANCH)
		id_card.military_branch = char_branch
	if(GLOB.using_map.flags & MAP_HAS_RANK)
		id_card.military_rank = char_rank

/obj/item/weapon/card/id/proc/dat()
	var/list/dat = list("<table><tr><td>")
	dat += text("Name: []</A><BR>", "[formal_name_prefix][registered_name][formal_name_suffix]")
	dat += text("Sex: []</A><BR>\n", sex)
	dat += text("Age: []</A><BR>\n", age)

	if(GLOB.using_map.flags & MAP_HAS_BRANCH)
		dat += text("Branch: []</A><BR>\n", military_branch ? military_branch.name : "\[UNSET\]")
	if(GLOB.using_map.flags & MAP_HAS_RANK)
		dat += text("Rank: []</A><BR>\n", military_rank ? military_rank.name : "\[UNSET\]")

	dat += text("Assignment: []</A><BR>\n", assignment)
	dat += text("Fingerprint: []</A><BR>\n", fingerprint_hash)
	dat += text("Blood Type: []<BR>\n", blood_type)
	dat += text("DNA Hash: []<BR><BR>\n", dna_hash)
	if(front && side)
		dat +="<td align = center valign = top>Photo:<br><img src=front.png height=80 width=80 border=4><img src=side.png height=80 width=80 border=4></td>"
	dat += "</tr></table>"
	return jointext(dat,null)

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	user.visible_message("\The [user] shows you: \icon[src] [src.name]. The assignment on the card: [src.assignment]",\
		"You flash your ID card: \icon[src] [src.name]. The assignment on the card: [src.assignment]")

	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/GetAccess()
	return access

/obj/item/weapon/card/id/GetIdCard()
	return src

/obj/item/weapon/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment))
	to_chat(usr, "The blood type on the card is [blood_type].")
	to_chat(usr, "The DNA hash on the card is [dna_hash].")
	to_chat(usr, "The fingerprint hash on the card is [fingerprint_hash].")
	return

/obj/item/weapon/card/id/silver
	name = "identification card"
	desc = "A silver card which shows honour and dedication."
	item_state = "silver_id"
	job_access_type = /datum/job/hop

/obj/item/weapon/card/id/gold
	name = "identification card"
	desc = "A golden card which shows power and might."
	job_access_type = /datum/job/captain
	color = "#d4c780"
	extra_details = list("goldstripe")

/obj/item/weapon/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(access_syndicate, access_external_airlocks)
	color = COLOR_RED_GRAY
	detail_color = COLOR_GRAY40

/obj/item/weapon/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"
	detail_color = COLOR_AMBER

/obj/item/weapon/card/id/captains_spare/New()
	access = get_all_station_access()
	..()

/obj/item/weapon/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for lawed synthetics."
	icon_state = "robot_base"
	assignment = "Synthetic"
	detail_color = COLOR_AMBER

/obj/item/weapon/card/id/synthetic/New()
	access = get_all_station_access() + access_synth
	..()

/obj/item/weapon/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	registered_name = "Central Command"
	assignment = "General"
	color = COLOR_GRAY40
	detail_color = COLOR_COMMAND_BLUE
	extra_details = list("goldstripe")

/obj/item/weapon/card/id/centcom/New()
	access = get_all_centcom_access()
	..()

/obj/item/weapon/card/id/centcom/station/New()
	..()
	access |= get_all_station_access()

/obj/item/weapon/card/id/centcom/ERT
	name = "\improper Emergency Response Team ID"
	assignment = "Emergency Response Team"

/obj/item/weapon/card/id/centcom/ERT/New()
	..()
	access |= get_all_station_access()

/obj/item/weapon/card/id/foundation_civilian
	name = "operant registration card"
	desc = "A registration card in a faux-leather case. It marks the named individual as a registered, law-abiding psionic."
	icon_state = "warrantcard_civ"

/obj/item/weapon/card/id/foundation_civilian/on_update_icon()
	return

/obj/item/weapon/card/id/foundation
	name = "\improper Foundation warrant card"
	desc = "A warrant card in a handsome leather case."
	assignment = "Field Agent"
	icon_state = "warrantcard"

/obj/item/weapon/card/id/foundation/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && isliving(user))
		var/mob/living/M = user
		if(M.psi)
			to_chat(user, SPAN_WARNING("There is a psionic compulsion surrounding \the [src], forcing anyone who reads it to perceive it as a legitimate document of authority. The actual text just reads 'I can do what I want.'"))
		else
			to_chat(user, SPAN_NOTICE("This is the real deal, stamped by [GLOB.using_map.boss_name]. It gives the holder the full authority to pursue their goals. You believe it implicitly."))

/obj/item/weapon/card/id/foundation/attack_self(var/mob/living/user)
	. = ..()
	if(istype(user))
		for(var/mob/M in viewers(world.view, get_turf(user))-user)
			if(user.psi && isliving(M))
				var/mob/living/L = M
				if(!L.psi)
					to_chat(L, SPAN_NOTICE("This is the real deal, stamped by [GLOB.using_map.boss_name]. It gives the holder the full authority to pursue their goals. You believe \the [user] implicitly."))
					continue
			to_chat(M, SPAN_WARNING("There is a psionic compulsion surrounding \the [src] in a flicker of indescribable light."))

/obj/item/weapon/card/id/foundation/on_update_icon()
	return

/obj/item/weapon/card/id/foundation/New()
	..()
	access |= get_all_station_access()

/obj/item/weapon/card/id/all_access
	name = "\improper Administrator's spare ID"
	desc = "The spare ID of the Lord of Lords himself."
	registered_name = "Administrator"
	assignment = "Administrator"
	detail_color = COLOR_MAROON
	extra_details = list("goldstripe")

/obj/item/weapon/card/id/all_access/New()
	access = get_access_ids()
	..()

// Department-flavor IDs
/obj/item/weapon/card/id/medical
	name = "identification card"
	desc = "A card issued to medical staff."
	job_access_type = /datum/job/doctor
	detail_color = COLOR_PALE_BLUE_GRAY

/obj/item/weapon/card/id/medical/chemist
	job_access_type = /datum/job/chemist

/obj/item/weapon/card/id/medical/geneticist
	job_access_type = /datum/job/geneticist

/obj/item/weapon/card/id/medical/psychiatrist
	job_access_type = /datum/job/psychiatrist

/obj/item/weapon/card/id/medical/paramedic
	job_access_type = /datum/job/Paramedic

/obj/item/weapon/card/id/medical/head
	name = "identification card"
	desc = "A card which represents care and compassion."
	job_access_type = /datum/job/cmo
	extra_details = list("goldstripe")

/obj/item/weapon/card/id/security
	name = "identification card"
	desc = "A card issued to security staff."
	job_access_type = /datum/job/officer
	color = COLOR_OFF_WHITE
	detail_color = COLOR_MAROON

/obj/item/weapon/card/id/security/warden
	job_access_type = /datum/job/warden

/obj/item/weapon/card/id/security/detective
	job_access_type = /datum/job/detective

/obj/item/weapon/card/id/security/head
	name = "identification card"
	desc = "A card which represents honor and protection."
	job_access_type = /datum/job/hos
	extra_details = list("goldstripe")

/obj/item/weapon/card/id/engineering
	name = "identification card"
	desc = "A card issued to engineering staff."
	job_access_type = /datum/job/engineer
	detail_color = COLOR_SUN

/obj/item/weapon/card/id/engineering/head
	name = "identification card"
	desc = "A card which represents creativity and ingenuity."
	job_access_type = /datum/job/chief_engineer
	extra_details = list("goldstripe")

/obj/item/weapon/card/id/science
	name = "identification card"
	desc = "A card issued to science staff."
	job_access_type = /datum/job/scientist
	detail_color = COLOR_PALE_PURPLE_GRAY

/obj/item/weapon/card/id/science/xenobiologist
	job_access_type = /datum/job/xenobiologist

/obj/item/weapon/card/id/science/roboticist
	job_access_type = /datum/job/roboticist

/obj/item/weapon/card/id/science/head
	name = "identification card"
	desc = "A card which represents knowledge and reasoning."
	job_access_type = /datum/job/rd
	extra_details = list("goldstripe")

/obj/item/weapon/card/id/cargo
	name = "identification card"
	desc = "A card issued to cargo staff."
	job_access_type = /datum/job/cargo_tech
	detail_color = COLOR_BROWN

/obj/item/weapon/card/id/cargo/mining
	job_access_type = /datum/job/mining

/obj/item/weapon/card/id/cargo/head
	name = "identification card"
	desc = "A card which represents service and planning."
	job_access_type = /datum/job/qm
	extra_details = list("goldstripe")

/obj/item/weapon/card/id/civilian
	name = "identification card"
	desc = "A card issued to civilian staff."
	job_access_type = DEFAULT_JOB_TYPE
	detail_color = COLOR_CIVIE_GREEN

/obj/item/weapon/card/id/civilian/bartender
	job_access_type = /datum/job/bartender

/obj/item/weapon/card/id/civilian/chef
	job_access_type = /datum/job/chef

/obj/item/weapon/card/id/civilian/botanist
	job_access_type = /datum/job/hydro

/obj/item/weapon/card/id/civilian/janitor
	job_access_type = /datum/job/janitor

/obj/item/weapon/card/id/civilian/librarian
	job_access_type = /datum/job/librarian

/obj/item/weapon/card/id/civilian/internal_affairs_agent
	job_access_type = /datum/job/lawyer
	detail_color = COLOR_NAVY_BLUE

/obj/item/weapon/card/id/civilian/chaplain
	job_access_type = /datum/job/chaplain

/obj/item/weapon/card/id/civilian/head //This is not the HoP. There's no position that uses this right now.
	name = "identification card"
	desc = "A card which represents common sense and responsibility."
	extra_details = list("goldstripe")

/obj/item/weapon/card/id/merchant
	name = "identification card"
	desc = "A card issued to Merchants, indicating their right to sell and buy goods."
	access = list(access_merchant)
	color = COLOR_OFF_WHITE
	detail_color = COLOR_BEIGE
