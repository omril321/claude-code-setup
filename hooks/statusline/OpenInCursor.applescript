on open location theURL
    -- Extract path from URL (remove "open-cursor://" prefix)
    set thePath to text 15 thru -1 of theURL

    -- Open in Cursor and bring to front
    do shell script "open -a Cursor " & quoted form of thePath
    delay 0.3
    tell application "Cursor" to activate
end open location
