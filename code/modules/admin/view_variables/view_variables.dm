
// Variables to not even show in the list.
// step_* and bound_* are here because they literally break the game and do nothing else.
// parent_type is here because it's pointless to show in VV.
// others are here because they expose sensitive information
/var/list/view_variables_hide_vars = list("bound_x", "bound_y", "bound_height", "bound_width", "bounds", "parent_type", "step_x", "step_y", "step_size", "sqladdress", "forumsqladdress", "sqlport", "forumsqlport", "sqldb", "forumsqldb", "sqllogin", "forumsqllogin", "sqlpass", "forumsqlpass", "sqlfdbkdb", "sqlfdbklogin", "sqlfdbkpass")
// Variables not to expand the lists of. Vars is pointless to expand, and overlays/underlays cannot be expanded.
/var/list/view_variables_dont_expand = list("overlays", "underlays", "vars")
// Variables that runtime if you try to test associativity of the lists they contain by indexing
/var/list/view_variables_no_assoc = list("verbs", "contents","screen","images")

// Acceptable 'in world', as VV would be incredibly hampered otherwise
/client/proc/debug_variables(datum/D in world)
	set category = "Debug"
	set name = "View Variables"

	if(!check_rights(0))
		return

	if(!D)
		return

	var/icon/sprite
	if(istype(D, /atom))
		var/atom/A = D
		if(A.icon && A.icon_state)
			sprite = icon(A.icon, A.icon_state)
			usr << browse_rsc(sprite, "view_vars_sprite.png")

	send_rsc(usr,'code/js/view_variables.js', "view_variables.js")

	var/html = {"
		<html>
		<head>
			<script src='view_variables.js'></script>
			<title>[D] (\ref[D] - [D.type])</title>
			<style>
				body { font-family: Verdana, sans-serif; font-size: 9pt; }
				.value { font-family: "Courier New", monospace; font-size: 8pt; }
			</style>
		</head>
		<body onload='selectTextField(); updateSearch()'; onkeyup='updateSearch()'>
			<div align='center'>
				<table width='100%'><tr>
					<td width='50%'>
						<table align='center' width='100%'><tr>
							[sprite ? "<td><img src='view_vars_sprite.png'></td>" : ""]
							<td><div align='center'>[D.get_view_variables_header()]</div></td>
						</tr></table>
						<div align='center'>
							<b><font size='1'>[replacetext("[D.type]", "/", "/<wbr>")]</font></b>
							[holder.marked_datum() == D ? "<br/><font size='1' color='red'><b>Marked Object</b></font>" : ""]
						</div>
					</td>
					<td width='50%'>
						<div align='center'>
							<a href='?_src_=vars;datumrefresh=\ref[D]'>Refresh</a>
							<form>
								<select name='file'
								        size='1'
								        onchange='loadPage(this.form.elements\[0\])'
								        target='_parent._top'
								        onmouseclick='this.focus()'
								        style='background-color:#ffffff'>
									<option>Select option</option>
									<option />
									<option value='?_src_=vars;mark_object=\ref[D]'>Mark Object</option>
									<option value='?_src_=vars;call_proc=\ref[D]'>Call Proc</option>
									[D.get_view_variables_options()]
								</select>
							</form>
						</div>
					</td>
				</tr></table>
			</div>
			<hr/>
			<font size='1'>
				<b>E</b> - Edit, tries to determine the variable type by itself.<br/>
				<b>C</b> - Change, asks you for the var type first.<br/>
				<b>M</b> - Mass modify: changes this variable for all objects of this type.<br/>
			</font>
			<hr/>
			<table width='100%'><tr>
				<td width='20%'>
					<div align='center'>
						<b>Search:</b>
					</div>
				</td>
				<td width='80%'>
					<input type='text'
					       id='filter'
					       name='filter_text'
					       value=''
					       style='width:100%;' />
				</td>
			</tr></table>
			<hr/>
			<ol id='vars'>
				[make_view_variables_var_list(D)]
			</ol>
		</body>
		</html>
		"}

	usr << browse(html, "window=variables\ref[D];size=475x650")


/proc/make_view_variables_var_list(datum/D)
	. = list()
	var/list/variables = list()
	for(var/x in D.get_variables())
		if(x in view_variables_hide_vars)
			continue
		variables += x
	variables = sortList(variables)
	for(var/x in variables)
		. += make_view_variables_var_entry(D, x, D.get_variable_value(x))
	return jointext(., null)

/proc/make_view_variables_value(value, varname = "*")
	var/vtext = ""
	var/extra = list()
	if(isnull(value))
		vtext = "null"
	else if(istext(value))
		vtext = "\"[value]\""
	else if(isicon(value))
		vtext = "[value]"
	else if(isfile(value))
		vtext = "'[value]'"
	else if(istype(value, /datum))
		var/datum/DA = value
		if("[DA]" == "[DA.type]" || !"[DA]")
			vtext = "<a href='?_src_=vars;Vars=\ref[DA]'>\ref[DA]</a> - [DA.type]"
		else
			vtext = "<a href='?_src_=vars;Vars=\ref[DA]'>\ref[DA]</a> - [DA] ([DA.type])"
	else if(istype(value, /client))
		var/client/C = value
		vtext = "<a href='?_src_=vars;Vars=\ref[C]'>\ref[C]</a> - [C] ([C.type])"
	else if(islist(value))
		var/list/L = value
		vtext = "/list ([L.len])"
		if(!(varname in view_variables_dont_expand) && L.len > 0 && L.len < 100)
			extra += "<ul>"
			for (var/index = 1 to L.len)
				var/entry = L[index]
				if(!isnum(entry) && !isnull(entry) && !(varname in view_variables_no_assoc) && L[entry] != null)
					extra += "<li>[index]: [make_view_variables_value(entry)] -> [make_view_variables_value(L[entry])]</li>"
				else
					extra += "<li>[index]: [make_view_variables_value(entry)]</li>"
			extra += "</ul>"
	else
		vtext = "[value]"

	return "<span class=value>[vtext]</span>[jointext(extra, null)]"

/proc/make_view_variables_var_entry(datum/D, varname, value, level=0)
	var/ecm = null

	if(D)
		ecm = D.make_view_variables_variable_entry(varname, value)

	var/valuestr = make_view_variables_value(value, varname)

	return "<li>[ecm][varname] = [valuestr]</li>"
