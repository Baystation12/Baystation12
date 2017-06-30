/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	var/associated_account_number = 0

	var/list/files = list(  )

/obj/item/weapon/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("data disk- '[]'", t)
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/*
 * ID CARDS
 */

/obj/item/weapon/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)

/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	var/uses = 10

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
		user.drop_item()
		var/obj/item/weapon/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)

	return 1

/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access."
	icon_state = "id"
	item_state = "card-id"

	var/access = list()
	var/registered_name = "Unknown" // The name registered_name on the card
	slot_flags = SLOT_ID

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

/obj/item/weapon/card/id/New()
	..()
	if(job_access_type)
		var/datum/job/j = job_master.GetJobByType(job_access_type)
		if(j)
			rank = j.title
			assignment = rank
			access |= j.get_access()

/obj/item/weapon/card/id/examine(mob/user)
	set src in oview(1)
	if(in_range(usr, src))
		show(usr)
		to_chat(usr, desc)
	else
		to_chat(usr, "<span class='warning'>It is too far away.</span>")

/obj/item/weapon/card/id/proc/prevent_tracking()
	return 0

/obj/item/weapon/card/id/proc/show(mob/user as mob)
	if(front && side)
		user << browse_rsc(front, "front.png")
		user << browse_rsc(side, "side.png")
	var/datum/browser/popup = new(user, "idcard", name, 600, 250)
	popup.set_content(dat())
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/item/weapon/card/id/proc/update_name()
	if(assignment)
		name = "[registered_name]'s ID Card ([assignment])"
	else
		name = "[registered_name]'s ID Card"

/obj/item/weapon/card/id/proc/set_id_photo(var/mob/M)
	front = getFlatIcon(M, SOUTH, always_use_defdir = 1)
	side = getFlatIcon(M, WEST, always_use_defdir = 1)

/mob/proc/set_id_info(var/obj/item/weapon/card/id/id_card)
	id_card.age = 0
	id_card.registered_name		= real_name
	id_card.sex 				= capitalize(gender)
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)
	id_card.update_name()

/mob/living/carbon/human/set_id_info(var/obj/item/weapon/card/id/id_card)
	..()
	id_card.age = age

	if(using_map.flags & MAP_HAS_BRANCH)
		id_card.military_branch = char_branch

	if(using_map.flags & MAP_HAS_RANK)
		id_card.military_rank = char_rank

/obj/item/weapon/card/id/proc/dat()
	var/list/dat = list("<table><tr><td>")
	dat += text("Name: []</A><BR>", registered_name)
	dat += text("Sex: []</A><BR>\n", sex)
	dat += text("Age: []</A><BR>\n", age)

	if(using_map.flags & MAP_HAS_BRANCH)
		dat += text("Branch: []</A><BR>\n", military_branch ? military_branch.name : "\[UNSET\]")
	if(using_map.flags & MAP_HAS_RANK)
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
	icon_state = "silver"
	item_state = "silver_id"
	job_access_type = /datum/job/hop

/obj/item/weapon/card/id/gold
	name = "identification card"
	desc = "A golden card which shows power and might."
	icon_state = "gold"
	item_state = "gold_id"
	job_access_type = /datum/job/captain

/obj/item/weapon/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(access_syndicate, access_external_airlocks)

/obj/item/weapon/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"

/obj/item/weapon/card/id/captains_spare/New()
	access = get_all_station_access()
	..()

/obj/item/weapon/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for lawed synthetics."
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Synthetic"

/obj/item/weapon/card/id/synthetic/New()
	access = get_all_station_access() + access_synth
	..()

/obj/item/weapon/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"
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

/obj/item/weapon/card/id/all_access
	name = "\improper Administrator's spare ID"
	desc = "The spare ID of the Lord of Lords himself."
	icon_state = "data"
	item_state = "tdgreen"
	registered_name = "Administrator"
	assignment = "Administrator"
/obj/item/weapon/card/id/all_access/New()
	access = get_access_ids()
	..()

// Department-flavor IDs
/obj/item/weapon/card/id/medical
	name = "identification card"
	desc = "A card issued to medical staff."
	icon_state = "med"
	job_access_type = /datum/job/doctor

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
	icon_state = "medGold"
	job_access_type = /datum/job/cmo

/obj/item/weapon/card/id/security
	name = "identification card"
	desc = "A card issued to security staff."
	icon_state = "sec"
	job_access_type = /datum/job/officer

/obj/item/weapon/card/id/security/warden
	job_access_type = /datum/job/warden

/obj/item/weapon/card/id/security/detective
	job_access_type = /datum/job/detective

/obj/item/weapon/card/id/security/head
	name = "identification card"
	desc = "A card which represents honor and protection."
	icon_state = "secGold"
	job_access_type = /datum/job/hos

/obj/item/weapon/card/id/engineering
	name = "identification card"
	desc = "A card issued to engineering staff."
	icon_state = "eng"
	job_access_type = /datum/job/engineer

/obj/item/weapon/card/id/engineering/atmos
	job_access_type = /datum/job/atmos

/obj/item/weapon/card/id/engineering/head
	name = "identification card"
	desc = "A card which represents creativity and ingenuity."
	icon_state = "engGold"
	job_access_type = /datum/job/chief_engineer

/obj/item/weapon/card/id/science
	name = "identification card"
	desc = "A card issued to science staff."
	icon_state = "sci"
	job_access_type = /datum/job/scientist

/obj/item/weapon/card/id/science/xenobiologist
	job_access_type = /datum/job/xenobiologist

/obj/item/weapon/card/id/science/roboticist
	job_access_type = /datum/job/roboticist

/obj/item/weapon/card/id/science/head
	name = "identification card"
	desc = "A card which represents knowledge and reasoning."
	icon_state = "sciGold"
	job_access_type = /datum/job/rd

/obj/item/weapon/card/id/cargo
	name = "identification card"
	desc = "A card issued to cargo staff."
	icon_state = "cargo"
	job_access_type = /datum/job/cargo_tech

/obj/item/weapon/card/id/cargo/mining
	job_access_type = /datum/job/mining

/obj/item/weapon/card/id/cargo/head
	name = "identification card"
	desc = "A card which represents service and planning."
	icon_state = "cargoGold"
	job_access_type = /datum/job/qm

/obj/item/weapon/card/id/civilian
	name = "identification card"
	desc = "A card issued to civilian staff."
	icon_state = "civ"
	job_access_type = /datum/job/assistant

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

/obj/item/weapon/card/id/civilian/chaplain
	job_access_type = /datum/job/chaplain

/obj/item/weapon/card/id/civilian/head //This is not the HoP. There's no position that uses this right now.
	name = "identification card"
	desc = "A card which represents common sense and responsibility."
	icon_state = "civGold"

/obj/item/weapon/card/id/merchant
	name = "identification card"
	desc = "A card issued to Merchants, indicating their right to sell and buy goods."
	icon_state = "trader"
	access = list(access_merchant)

