var/list/uniform_list = list("Classic Red" = /obj/item/clothing/under/rank/security, "Corporate Black" = /obj/item/clothing/under/rank/security/corp, "Navy n' White" = /obj/item/clothing/under/rank/security/navyblue)


proc/ConfigureUniforms()
	uniform_name = pick(uniform_list)
	var/new_uniform = uniform_list[uniform_name]
	uniform = new new_uniform
	AnnounceUniforms()

proc/AnnounceUniforms()
	world << "<B><FONT COLOR=RED>The chosen security uniform for the round is<FONT COLOR=#000> \icon[uniform] [uniform_name]</FONT></B></FONT>"