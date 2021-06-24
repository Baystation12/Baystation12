/browser
	var/mob/user
	var/title
	var/window_id
	var/width
	var/height
	var/atom/ref
	var/window_options = "focus=0;can_close=1;can_minimize=1;can_maximize=0;can_resize=1;titlebar=1;"
	var/list/stylesheets
	var/list/scripts
	var/title_image
	var/head
	var/body
	var/title_buttons
	var/title_attributes


/browser/New(_user, _window_id, _title, _width, _height, atom/_ref)
	user = _user
	window_id = _window_id
	if (_title)
		title = format_text(_title)
	if (_width)
		width = _width
	if (_height)
		height = _height
	if (_ref)
		ref = _ref
	user = resolve_client(_user)
	stylesheets = list("common" = 'html/browser/common.css')


/browser/proc/set_window_options(_options)
	window_options = _options


/browser/proc/set_content(_content)
	body = _content


/browser/proc/get_content()
	if (isnull(head))
		head = ""
		for (var/key in stylesheets)
			var/filename = "[ckey(key)].css"
			send_rsc(user, stylesheets[key], filename)
			head += "<link rel='stylesheet' type='text/css' href='[filename]'>"
		for (var/key in scripts)
			var/filename = "[ckey(key)].js"
			send_rsc(user, scripts[key], filename)
			head += "<script type='text/javascript' src='[filename]'></script>"
		title_attributes = title_image ? "class='uiTitle icon' style='background-image: url([title_image]);'" : "class='uiTitle'"
	var/temp = ""
	if (title)
		temp = "<div class=\"uiTitleWrapper\"><div [title_attributes]><tt>[title]</tt></div><div class=\"uiTitleButtons\">[title_buttons]</div></div>"
	return HTML_PAGE_FULL(head, "<div class=\"uiWrapper\">[temp]<div class=\"uiContent\">[body]</div></div>")


/browser/proc/open(_onclose = TRUE)
	var/window_size = ""
	if (width && height)
		window_size = "size=[width||0]x[height||0];"
	show_browser(user, get_content(), "window=[window_id];[window_size][window_options]")
	if (_onclose)
		onclose(user, window_id, ref)


/browser/proc/update(_force, _onclose = TRUE)
	if (_force)
		open(_onclose)
	else
		send_output(user, get_content(), "[window_id].browser")


/browser/proc/close()
	close_browser(user, "window=[window_id]")


/// Register windowclose to be called, optionally with _ref, when the window _window_id is closed
/proc/onclose(mob/_user, _window_id, atom/_ref)
	var/actor = resolve_client(_user)
	if (!actor)
		return
	var/param = _ref ? "\ref[_ref]" : "null"
	winset(actor, _window_id, "on-close=\".windowclose [param]\"")


/// Notifies atom _ref or otherwise clears the clients machine when a window registered by onclose closes
/client/verb/windowclose(_ref as text)
	set name = ".windowclose"
	set hidden = TRUE
	if (_ref != "null")
		_ref = locate(_ref)
		if (_ref)
			usr = src?.mob
			Topic("close=1", list("close" = "1"), _ref)
			return
	if (src?.mob)
		mob.unset_machine()

