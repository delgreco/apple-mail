# apple-mail

Fetch email from Apple Mail and store it in plain text as JSON.

Specifically, only Sent messages are fetched by this script.

## run manually in verbose mode

    osascript get.scpt -v

## keep it fresh every day at 5pm

    0 17 * * * cd $HOME/apple-mail; ./run.sh >> out.log 2>&1

Note that a wrapper script is used to run the Applescript.  This is to get normal shell output to the log, which Applescript is fussy about.

Depending on the conditions Apple sets, cron execution may yield 'Operation Not Permitted' until you go to

    System Settings -> Privacy & Security -> Full Disk Access

and grant access to /bin/bash.  However, since you must select from the UI, use <cmd>-<shift>-G to open a dialog where you can type

    /bin/bash

to add it for Full Disk Access.

Additionally, cron will not run on MacOS if the system is sleeping.  Go to

    System Settings -> Battery -> Options

and turn ON 

    Prevent automatic sleeping on power adapter when the display is off

## result

Your sent mail data will be stored in a local mail/ folder, in the following format:

    YYYYMMDD_HHMMSS_[message_id].json

Therefore:

    $ ls mail
    20260112_153818_1041.json  20260116_085923_1013.json  [etc...]



