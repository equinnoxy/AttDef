#include <a_samp>
#undef MAX_PLAYERS
#define MAX_PLAYERS 16

// Only for the debug commands.
// When running a public server, simply remove this include and the commands.


#define KILLBOX_TEXT	"~r~Killfeed:~n~~w~"
#define MAX_KB_LINES	5 // Not tested new values, the textdraw fits 5 though
// I will update this to support a dynamic amount.
#define MAX_KN_LINE_LEN	70
#define MAX_KB_LEN		(16 + (MAX_KB_LINES*MAX_KN_LINE_LEN))

new
	Text:kbBack,
	Text:kbText,
	szKbString[MAX_KB_LEN] = {KILLBOX_TEXT};


public OnFilterScriptInit()
{
    LoadTD();
}
public OnFilterScriptExit()
{
    DestroyTD();
}


LoadTD()
{
	kbBack = TextDrawCreate(460.000000, 110.000000, "~n~~n~~n~~n~~n~~n~");
	TextDrawBackgroundColor(kbBack, 255);
	TextDrawFont(kbBack, 1);
	TextDrawLetterSize(kbBack, 0.300000, 1.399999);
	TextDrawColor(kbBack, -1);
	TextDrawSetOutline(kbBack, 0);
	TextDrawSetProportional(kbBack, 1);
	TextDrawSetShadow(kbBack, 1);
	TextDrawUseBox(kbBack, 1);
	TextDrawBoxColor(kbBack, 100);
	TextDrawTextSize(kbBack, 630.000000, 0.000000);

	kbText = TextDrawCreate(460.000000, 110.000000, "~r~Killfeed:~n~~w~(HLF)Southclaw M4 (HLF)Defiance~n~line2~n~line3~n~line4~n~line5");
	TextDrawBackgroundColor(kbText, 255);
	TextDrawFont(kbText, 1);
	TextDrawLetterSize(kbText, 0.260000, 1.399999);
	TextDrawColor(kbText, -1);
	TextDrawSetOutline(kbText, 0);
	TextDrawSetProportional(kbText, 1);
	TextDrawSetShadow(kbText, 1);
}
DestroyTD()
{
	TextDrawDestroy(kbBack);
	TextDrawDestroy(kbText);
}
UpdateKillBox(killer, victim, weapon)
{
	new
	    killerName[MAX_PLAYER_NAME],
	    victimName[MAX_PLAYER_NAME],
	    tmpWepName[17],
		tmpLine[70],
		iLoop,
		iChar = 16,
		len,
		tmpPos;

	// Format the new line to insert at the top of the kill list.
	GetPlayerName(killer, killerName, MAX_PLAYER_NAME);
	GetPlayerName(victim, victimName, MAX_PLAYER_NAME);
	GetWeaponName(weapon, tmpWepName, 17);
	format(tmpLine, 70, "%s %s %s~n~", killerName, tmpWepName, victimName);

	// Insert the new line at the top of the list,
	// This is after the heading of the killfeed.
	strins(szKbString, tmpLine, strlen(KILLBOX_TEXT), 70);

	// This next part will remove any unwanted newline characters
	// Because we only want 5 (Or whatever you set MAX_KB_LINES to)
	// lines after the heading

	len = strlen(szKbString);

	// Loop through the text while the number of found lines is below the max
	// and while the looping character cell is within the string.
	while(iLoop < MAX_KB_LINES && iChar < len)
	{
	    // Look for the nextline character
	    tmpPos = strfind(szKbString, "~n~", .pos=iChar);
	    // If one is found
		if(tmpPos != -1)
		{
		    iChar = tmpPos; // Set the char to the pos
			iLoop++; // Increase the number of lines found
		}
		iChar++; // Increase the char index for the next strfind
	}
	// If there are more than 5 lines found,
	// Set the 6th newline character to EOS (end of string)
	// I use -1 because the last iteration of the loop performs 'iChar++'
	if(iLoop >= 5)szKbString[iChar-1] = EOS;

	// Now the string has any overhang newlines removed, update it.
	TextDrawSetString(kbText, szKbString);
}
TogglePlayerKillBox(playerid, bool:toggle)
{
	if(toggle)
	{
	    TextDrawShowForPlayer(playerid, kbBack);
	    TextDrawShowForPlayer(playerid, kbText);
	}
	else
	{
	    TextDrawHideForPlayer(playerid, kbBack);
	    TextDrawHideForPlayer(playerid, kbText);
	}
}

// The following commands are used for testing purposes.

CMD:showkb(playerid, params[])
{
	TogglePlayerKillBox(playerid, true);
	return 1;
}
CMD:kbadd(playerid, params[])
{
	UpdateKillBox(0, 1, 34);
	return 1;
}

