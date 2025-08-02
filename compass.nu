#!/usr/bin/env nu

# Get all Safari tabs and let user select one to switch to
def main [] {
    # Get all tabs from Safari's front window with URLs using ASCII 30 as delimiter
    let tabs = (
        osascript -e "
            tell application \"Safari\"
                -- Use record separator (ASCII 30) for delimeter
                set delimiter to ASCII character 30
                set tabList to {}

                repeat with t in tabs of front window
                    set tabName to name of t
                    set tabURL to URL of t
                    
                    -- Remove any existing ASCII 30 characters from the name
                    -- split by ASCII 30
                    set AppleScript's text item delimiters to delimiter
                    -- String -> [String]
                    set nameItems to text items of tabName
                    -- join with empty string
                    set AppleScript's text item delimiters to \"\"
                    -- [String] -> String
                    set tabName to nameItems as string
                    
                    -- Add local: prefix if needed
                    if tabURL starts with \"http://localhost\" or tabURL starts with \"https://localhost\" or tabURL starts with \"file:///\" then
                        set tabName to \"local: \" & tabName
                    end if

                    -- append tabName to tabList
                    set end of tabList to tabName
                end repeat

                set AppleScript's text item delimiters to delimiter
                -- [String] -> String
                return tabList as string
            end tell
        "
        | split row (char record_separator)
    )
    
    # Let user select a tab
    let selected = (
        $tabs 
        | input list --fuzzy "Select a Safari tab"
    )
    
    if (
        $selected 
        | is-not-empty
    ) {
        # Get the index of the selected tab (1-based for AppleScript)
        let index = (
            $tabs 
            | enumerate 
            | where item == $selected 
            | get index.0
        ) + 1
        
        # Switch to the selected tab
        osascript -e $"tell application \"Safari\" to set current tab of front window to tab ($index) of front window"
        osascript -e "tell application \"Safari\" to activate"
        
        print $"Switched to tab: ($selected)"
    }
}
