/proc/utf_8_html(browser_content)
	if (isnull(browser_content) || isfile(browser_content))
		return browser_content
	else if(findtext(browser_content, "<html>"))
		return replacetext(browser_content, "<html>", "<html><meta charset='UTF-8'>")
	else
		return "<HTML><meta charset='UTF-8'><BODY>[browser_content]</BODY></HTML>"
