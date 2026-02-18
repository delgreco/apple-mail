on run argv
	set verboseMode to false
	if "-v" is in argv then
		set verboseMode to true
	end if

	-- Get the HFS path of the directory containing this script
	tell application "System Events"
		set scriptContainer to container of (path to me)
		set projectPath to path of scriptContainer
		set mailDir to projectPath & "mail:"

		if not (exists folder mailDir) then
			make new folder at scriptContainer with properties {name:"mail"}
		end if
		
		-- Pre-load the list of existing files for efficiency
		try
			set existingFiles to name of every file in folder mailDir
		on error
			-- The directory might be empty
			set existingFiles to {}
		end try
	end tell

	tell application "Mail"
		set targetMessages to messages of sent mailbox
		
		set maxMessagesToProcess to 50
		set messageCount to count targetMessages
		
		if messageCount > maxMessagesToProcess then
			set messageCount to maxMessagesToProcess
		end if
		
		repeat with i from 1 to messageCount
			set theMessage to item i of targetMessages
			
			set msgDateReceived to date received of theMessage
			set messageId to id of theMessage
			
			-- Format date for filename
			set formattedDate to my formatDateForFilename(msgDateReceived)
			set fileName to formattedDate & "_" & messageId & ".json"
			
			if fileName is in existingFiles then
				if verboseMode then
					log "Skipping already saved JSON: " & fileName
				end if
			else
				set msgSubject to subject of theMessage
				set msgSender to sender of theMessage
				set messageContent to content of theMessage
				
				set recipientAddresses to {}
				tell theMessage
					repeat with aRecipient in recipients
						set end of recipientAddresses to address of aRecipient
					end repeat
				end tell

					-- Save original delimiters
					set oldDelimiters to AppleScript's text item delimiters

					-- Join recipient addresses into a comma-separated string
					set AppleScript's text item delimiters to ", "
					set msgToAddressesString to recipientAddresses as string
					set AppleScript's text item delimiters to oldDelimiters -- restore original delimiters

				-- Replace carriage returns with linefeeds in the message body
				set AppleScript's text item delimiters to return
				set textItems to text items of messageContent
				set AppleScript's text item delimiters to linefeed
				set messageContent to textItems as string
				set AppleScript's text item delimiters to oldDelimiters
				
				-- Convert date to string for JSON
				set dateString to msgDateReceived as string
				
				-- Manually construct JSON object string for the current message
				set jsonObjectString to "{" & ¬
					"\"Subject\": " & my escapeJsonString(msgSubject) & ", " & ¬
					"\"From\": " & my escapeJsonString(msgSender) & ", " & ¬
					"\"To\": " & my escapeJsonString(msgToAddressesString) & ", " & ¬
					"\"Date\": " & my escapeJsonString(dateString) & ", " & ¬
					"\"Body\": " & my escapeJsonString(messageContent) & ¬
				"}"
				
				set filePath to mailDir & fileName
				
				try
					set fileRef to open for access filePath with write permission
					set eof of fileRef to 0 -- Clear file content
					write jsonObjectString to fileRef as «class utf8»
					close access fileRef
					log "Saved JSON for message " & messageId & " to " & filePath
				on error errMsg
					log "Error writing JSON file for message " & messageId & ": " & errMsg
					try
						close access file filePath
					end try
				end try
			end if
		end repeat
	end tell
end run


on formatDateForFilename(theDate)
    set yearNum to year of theDate
    set monthNum to month of theDate as number
    set dayNum to day of theDate
    set hourNum to hours of theDate
    set minuteNum to minutes of theDate
    set secondNum to seconds of theDate

    set yearStr to yearNum as string
    set monthStr to text -2 thru -1 of ("00" & monthNum)
    set dayStr to text -2 thru -1 of ("00" & dayNum)
    set hourStr to text -2 thru -1 of ("00" & hourNum)
    set minuteStr to text -2 thru -1 of ("00" & minuteNum)
    set secondStr to text -2 thru -1 of ("00" & secondNum)

    return yearStr & monthStr & dayStr & "_" & hourStr & minuteStr & secondStr
end formatDateForFilename

on escapeJsonString(theString)
    set tempString to theString
    -- Escape backslashes first
    set AppleScript's text item delimiters to "\\"
    set textItems to text items of tempString
    set AppleScript's text item delimiters to "\\\\"
    set tempString to textItems as string
    
    -- Escape double quotes
    set AppleScript's text item delimiters to "\""
    set textItems to text items of tempString
    set AppleScript's text item delimiters to "\\\""
    set tempString to textItems as string
    
    -- Escape newlines (linefeed)
    set AppleScript's text item delimiters to linefeed
    set textItems to text items of tempString
    set AppleScript's text item delimiters to "\\n"
    set tempString to textItems as string

    -- Escape tabs
    set AppleScript's text item delimiters to tab
    set textItems to text items of tempString
    set AppleScript's text item delimiters to "\\t"
    set tempString to textItems as string
    
    -- Reset delimiters
    set AppleScript's text item delimiters to ""
    
    return "\"" & tempString & "\""
end escapeJsonString