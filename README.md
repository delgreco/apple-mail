# apple-mail
Fetch email from Apple Mail and store it in plain text as JSON.

Specifically, only Sent messages are fetched by this script.

## run manually in verbose mode

    osascript get.scpt -v

## keep it fresh hourly

    0 17 * * * cd $HOME/Desktop/projects/apple-mail; osascript get.scpt >> out.log

## result

Mail will be stored in a local mail/ folder, in the following format:

    YYYYMMDD_HHMMSS_[message_id].json

Therefore:

    $ ls mail
    20260112_153818_1041.json  20260116_085923_1013.json  [etc...]



