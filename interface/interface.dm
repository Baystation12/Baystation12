/client/proc/link_url(url, name, skip_confirmation)
	if (!url)
		to_chat(src, SPAN_WARNING("The server configuration does not include \a [name] URL."))
		return
	if (!skip_confirmation)
		var/cancel = alert("You will open [url]. Are you sure?", "Visit [name]", "Yes", "No") != "Yes"
		if (cancel)
			return
	send_link(src, url)


/client/verb/link_wiki()
	set name = "link wiki"
	set hidden = TRUE
	link_url(config.wiki_url, "Wiki", TRUE)


/client/verb/link_source()
	set name = "link source"
	set hidden = TRUE
	link_url(config.source_url, "Source", TRUE)


/client/verb/link_issue()
	set name = "link issue"
	set hidden = TRUE
	link_url(config.issue_url, "Issue", TRUE)


/client/verb/link_forum()
	set name = "link forum"
	set hidden = TRUE
	link_url(config.forum_url, "Forum", TRUE)


/client/verb/link_rules()
	set name = "link rules"
	set hidden = TRUE
	link_url(config.rules_url, "Rules", TRUE)


/client/verb/link_lore()
	set name = "link lore"
	set hidden = TRUE
	link_url(config.lore_url, "Lore", TRUE)

/client/verb/link_discord()
	set name = "link discord"
	set hidden = TRUE
	link_url(config.discord_url, "Discord", TRUE)
