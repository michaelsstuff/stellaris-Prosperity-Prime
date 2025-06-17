# Steam Workshop Auto-Publishing Template

Here's a simplified template for your Steam Workshop VDF file that you can customize:

## workshop_item_template.vdf

```vdf
"workshopitem"
{
    "appid" "281990"                                    // Stellaris App ID
    "publishedfileid" "YOUR_WORKSHOP_ID_HERE"          // Replace with your Workshop ID
    "contentfolder" "."                                 // Current directory (your mod folder)
    "previewfile" "preview.jpg"                        // Your preview image
    "visibility" "0"                                    // 0=public, 1=friends only, 2=private
    "title" "Your Mod Title"
    "description" "Your mod description in Steam BBCode format"
    "changenote" "Update notes for this version"
    "tags" {
        "item" "Gameplay"
        "item" "Galaxy Generation" 
        "item" "Economy"
    }
}
```

## GitHub Secrets Required

Add these to your repository secrets:

- `STEAM_USERNAME` - Your Steam username
- `STEAM_PASSWORD` - Your Steam password  
- `STEAM_WORKSHOP_ID` - Your mod's Workshop ID (from the URL)

## SteamCMD Commands

Basic commands for manual testing:

```bash
# Login and publish
steamcmd +login username password +workshop_build_item workshop_item.vdf +quit

# Check workshop item status
steamcmd +login username password +workshop_status YOUR_WORKSHOP_ID +quit
```

## Steam App IDs

Common Paradox game App IDs:
- Stellaris: 281990
- Hearts of Iron IV: 394360
- Europa Universalis IV: 236850
- Crusader Kings II: 203770
- Crusader Kings III: 1158310
