
/obj/machinery/artillerycontrol
	var/reload = 180
	name = "bluespace artillery control"
	icon_state = "control_boxp1"
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	density = 1
	anchored = 1

/obj/machinery/artillerycontrol/Process()
	if(src.reload<180)
		src.reload++

/obj/structure/artilleryplaceholder
	name = "artillery"
	icon = 'icons/obj/machines/artillery.dmi'
	anchored = 1
	density = 1
	desc = "The ship's old bluespace artillery cannon. Looks inoperative."

/obj/structure/artilleryplaceholder/decorative
	density = 0

/obj/machinery/artillerycontrol/attack_hand(mob/user as mob)
	user.set_machine(src)
	var/dat = "<B>Bluespace Artillery Control:</B><BR>"
	dat += "Locked on<BR>"
	dat += "<B>Charge progress: [reload]/180:</B><BR>"
	dat += "<A href='byond://?src=\ref[src];fire=1'>Open Fire</A><BR>"
	dat += "Deployment of weapon authorized by <br>[GLOB.using_map.company_name] Naval Command<br><br>Remember, friendly fire is grounds for termination of your contract and life.<HR>"
	user << browse(dat, "window=scroll")
	onclose(user, "scroll")
	return

/obj/machinery/artillerycontrol/Topic(href, href_list, state = GLOB.physical_state)
	if(..())
		return 1

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		var/area/thearea = input("Area to jump bombard", "Open Fire") as null|anything in teleportlocs
		thearea = thearea ? teleportlocs[thearea] : thearea
		if (!thearea || CanUseTopic(usr, GLOB.physical_state) != STATUS_INTERACTIVE)
			return
		if (src.reload < 180)
			return
		if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
			command_announcement.Announce("Bluespace artillery fire detected. Brace for impact.")
			message_admins("[key_name_admin(usr)] has launched an artillery strike.", 1)
			var/list/L = list()
			for(var/turf/T in get_area_turfs(thearea))
				L+=T
			var/loc = pick(L)
			explosion(loc,2,5,11)
			reload = 0
