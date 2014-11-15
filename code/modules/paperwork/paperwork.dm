#define DEFAULT_FONT	"Verdana"
#define SIGNATURE_FONT	"Times New Roman"
#define CRAYON_FONT		"Comic Sans MS"

/obj/item/weapon/paperwork
    name = "paperwork"

//Generates the HTML content and returns it as a string.
//A mob may be optionally supplied in case the content varies with the viewer.
//If user is null then the paperwork should display the contents as plainly as possible (i.e. for admins)
/obj/item/weapon/paperwork/proc/render_content(mob/user=null)
	return ""

//Displays the content to a mob
/obj/item/weapon/paperwork/proc/show_content(mob/user)
	return

/obj/item/weapon/paperwork/proc/copy(newloc)
	return

//Called when the paperwork is being bundled with another paperwork item
/obj/item/weapon/paperwork/proc/create_bundle(obj/item/weapon/paperwork/other, mob/user)
	if (istype(P, /obj/item/weapon/paper/carbon))
		var/obj/item/weapon/paper/carbon/C = P
		if (!C.iscopy && !C.copied)
			user << "<span class='notice'>Take off the carbon copy first.</span>"
			add_fingerprint(user)
			return
	
	var/obj/item/weapon/paper_bundle/B = new(src.loc)
	if (name != initial(name))
		B.name = name
	
	user.drop_from_inventory(P)
	if (istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/h_user = user
		if (h_user.r_hand == src)
			h_user.drop_from_inventory(src)
			h_user.put_in_r_hand(B)
		else if (h_user.l_hand == src)
			h_user.drop_from_inventory(src)
			h_user.put_in_l_hand(B)
		else if (h_user.l_store == src)
			h_user.drop_from_inventory(src)
			B.loc = h_user
			B.layer = 20
			h_user.l_store = B
			h_user.update_inv_pockets()
		else if (h_user.r_store == src)
			h_user.drop_from_inventory(src)
			B.loc = h_user
			B.layer = 20
			h_user.r_store = B
			h_user.update_inv_pockets()
		else if (h_user.head == src)
			h_user.u_equip(src)
			h_user.put_in_hands(B)
		else if (!istype(src.loc, /turf))
			src.loc = get_turf(h_user)
			if(h_user.client)	h_user.client.screen -= src
			h_user.put_in_hands(B)
	user << "<span class='notice'>You clip \the [P] to \the [src].</span>"
	src.loc = B
	P.loc = B
	B.update_icon()

/obj/item/weapon/paperwork/attackby(obj/item/weapon/P as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/flame))
		burnpaper(W, user)
		return
	..()

/obj/item/weapon/paperwork/examine(mob/user)
	if(in_range(user, src))
		show_content(user)
	else
		user << "<span class='notice'>It is too far away.</span>"

/obj/item/weapon/paperwork/proc/burnpaper(obj/item/weapon/flame/P, mob/user)
	var/class = "<span class='warning'>"

	if(P.lit && !user.restrained())
		if(istype(P, /obj/item/weapon/flame/lighter/zippo))
			class = "<span class='rose'>"

		user.visible_message("[class][user] holds \the [P] up to \the [src], it looks like \he's trying to burn it!", \
		"[class]You hold \the [P] up to \the [src], burning it slowly.")

		if (do_after(user, 20) && P.lit)
			user.visible_message("[class][user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.", \
			"[class]You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.")

			if(user.get_inactive_hand() == src)
				user.drop_from_inventory(src)

			new /obj/effect/decal/cleanable/ash(src.loc)
			del(src)
		else
			user << "\red You must hold \the [P] steady to burn \the [src]."


/obj/item/weapon/paperwork/verb/rename(mob/user)
	set name = "Rename paperwork"
	set category = "Object"
	set src in usr

	var/n_name = copytext(sanitize(input(user, "What would you like to label \the [src]?", "Paper Labelling", null)  as text), 1, MAX_NAME_LEN)
	if((loc == usr && !usr.stat))
		name = "[(n_name ? "[n_name]" : initial(name))]"
	add_fingerprint(usr)
	return

//there's got to be a better way to handle literacy
/obj/item/weapon/paperwork/proc/can_read(mob/user)
	if (istype(user, /mob/living/carbon/human) || istype(user, /mob/dead/observer) || istype(user, /mob/living/silicon))
		return 1
	return 0

//prompts the user for pencode input and produces a sequence of strings split on [field] tags
/proc/paperwork_input(mob/user, obj/item/implement, var/prompt="Enter what you want to write:")
	if(!implement) return

	var/t = input(user, "Enter what you want to write:", "Write", null, null) as message //what the hell is the message type?
	if (!t) return

	var/iscrayon = 0
	var/font = DEFAULT_FONT
	var/colour
	if (istype(implement, /obj/item/weapon/pen))
		var/obj/item/weapon/pen/P = implement
		colour = P.colour? P.colour : "black"
	
	else if (istype(implement, /obj/item/toy/crayon))
		var/obj/item/toy/crayon/P = implement
		iscrayon = 1
		font = CRAYON_FONT
		colour = P.colour? P.colour : "black"
	
	else return
	
	//parse pen code then split on field tags
	t = html_encode(t)
	t = replacetext(t, "\[field\]", "<>") //all angle brackets should have been removed by html_encode()
	t = parsepencode(t, user, iscrayon)   // Encode everything from pencode to html //TODO#paperwork
	var/list/textlist = text2listEx(t, "<>")
	
	//could make textlist a list of datums if we ever need to track more metadata besides font and colour
	//maybe if we ever implement written languages, but for now YAGNI.
	. = list()
	for (var/S in textlist)
		. += "<font face='[font]' color=[colour]>[S]</font>"

/proc/parsepencode(var/t, mob/user as mob, var/iscrayon = 0)
	t = replacetext(t, "\n", "<BR>")
	
	t = replacetext(t, "\[center\]", "<center>")
	t = replacetext(t, "\[/center\]", "</center>")
	t = replacetext(t, "\[br\]", "<BR>")
	t = replacetext(t, "\[b\]", "<B>")
	t = replacetext(t, "\[/b\]", "</B>")
	t = replacetext(t, "\[i\]", "<I>")
	t = replacetext(t, "\[/i\]", "</I>")
	t = replacetext(t, "\[u\]", "<U>")
	t = replacetext(t, "\[/u\]", "</U>")
	t = replacetext(t, "\[large\]", "<font size=\"4\">")
	t = replacetext(t, "\[/large\]", "</font>")
	t = replacetext(t, "\[sign\]", "<font face=\"[signfont]\"><i>[user ? user.real_name : "Anonymous"]</i></font>")
	//t = replacetext(t, "\[field\]", "<span class=\"paper_field\"></span>")
	
	t = replacetext(t, "\[h1\]", "<H1>")
	t = replacetext(t, "\[/h1\]", "</H1>")
	t = replacetext(t, "\[h2\]", "<H2>")
	t = replacetext(t, "\[/h2\]", "</H2>")
	t = replacetext(t, "\[h3\]", "<H3>")
	t = replacetext(t, "\[/h3\]", "</H3>")
	
	if(!iscrayon)
		t = replacetext(t, "\[*\]", "<li>")
		t = replacetext(t, "\[hr\]", "<HR>")
		t = replacetext(t, "\[small\]", "<font size = \"1\">")
		t = replacetext(t, "\[/small\]", "</font>")
		t = replacetext(t, "\[list\]", "<ul>")
		t = replacetext(t, "\[/list\]", "</ul>")
		t = replacetext(t, "\[table\]", "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>")
		t = replacetext(t, "\[/table\]", "</td></tr></table>")
		t = replacetext(t, "\[grid\]", "<table>")
		t = replacetext(t, "\[/grid\]", "</td></tr></table>")
		t = replacetext(t, "\[row\]", "</td><tr>")
		t = replacetext(t, "\[cell\]", "<td>")
		t = replacetext(t, "\[logo\]", "<img src = html/images/ntlogo.png>")
	else // If it is a crayon, and he still tries to use these, make them empty!
		t = replacetext(t, "\[*\]", "")
		t = replacetext(t, "\[hr\]", "")
		t = replacetext(t, "\[small\]", "")
		t = replacetext(t, "\[/small\]", "")
		t = replacetext(t, "\[list\]", "")
		t = replacetext(t, "\[/list\]", "")
		t = replacetext(t, "\[table\]", "")
		t = replacetext(t, "\[/table\]", "")
		t = replacetext(t, "\[row\]", "")
		t = replacetext(t, "\[cell\]", "")
		t = replacetext(t, "\[logo\]", "")