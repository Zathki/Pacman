%%%%%%%%%%BY: ALEX KIDD%%%%%%%%%%
%%%%%%%%%%VERSION 11.2%%%%%%%%%%

%%%%%%%%%%SETUP SCREEN%%%%%%%%%%
import GUI
randomize
setscreen ("offscreenonly,graphics,nocursor")
colourback (black)
colour (grey)
cls

%%%%%%%%%%VARIABLES%%%%%%%%%%
var ver : string := '11.2' %Version
var nextlevel : int %What Next Level should be
var power : int %Wether Power is activated
var extralife, lives : int %# of lives and # of points needed for extra life
var waitdir : array 1 .. 10 of int %Waits before changing ghost direction again
var upwall, downwall, leftwall, rightwall : boolean %Wether there is a wall near the ghost
var radio : array 1 .. 8 of int %Radio Buttons
var helpbox : int %Help Text Box
var contbtn, playbtn, mapbtn : int %Buttons
var mapbar, speedbar, compbar : int %ScrollBars
var font1, font2, font3, font4, font5 : int %Fonts
var x0, y0 : int %X,Y Pacman in Title
var co : int %Open/Close for Pacman that eat Title Page
var chars : array char of boolean %Checks what key is pressed
var x, y : array 1 .. 2 of int %X,Y Pacman
var ghostx, ghosty : array 1 .. 10 of int %X,Y Ghosts
var move : array 1 .. 2 of string %What Direction to Move
var oc : array 1 .. 2 of int %Open/Close for Pacman
var speed, score, level, dotnum : int %Game Speed,Score,Level,Dot Number
var speed2, score2, level2, dotnum2 : string %Converts Speed,Score,Level,Dot Number to String
var higher : array 1 .. 2 of boolean %Is Mouth Opening/Closing
var count : int %Open/Close Title Pacman Set #
var foodx, foody, wallx, wally, draw : flexible array 1 .. 238 of int %X,Y for Food,Wall, What to Draw
var blockx, blocky : array 0 .. 3 of int %X,Y for Block Select
var sidex, sidey : array 1 .. 62 of int %X,Y for Sides of Level
var mapname : flexible array 0 .. 10 of string %Map Names
var a, b, c, d, e : int %Used to Set Up X,Y for Food/Wall
var map : int %What Map to Use
var f, temp : int %File
var xmouse, ymouse, button : int %Mouse Position
var drawblock : int %What to Draw
var game : int %What to Run
var readtitle : flexible array 0 .. 0 of string %Level Name
var readblock, readborder : flexible array 1 .. 0 of int %What to Draw
var titlecount, blockcount, bordercount : int %How many of Each thing there are
var readfile, line : int %File Var and # of lines in levels.txt
var num : string %Next Character in levels.txt
var continue : boolean %Checks if Continue Button has been Pressed
var typename : string (30) %Name to Save Level made in Mapmaker
var writemap, data : string %Writes Mapmaker map to levels.txt
var startlevel : int %Wether Mapmaker or Actual Game will be run
var ai, compnum : int %AI Skill and # of Ghosts
var g1 : array 1 .. 7 of int := init (39, 42, 46, 50, 54, 58, 61) %Bottom of Ghosts
var g2 : array 1 .. 7 of int := init (89, 92, 89, 92, 89, 92, 89) %Bottom of Ghosts
var moveg : array 1 .. 10 of string %What Direction Ghost if Moving
var ghost : array 0 .. 10 of int %Ghost Pic
var randdir : int %Change Ghost Direction
var newdir : string %Change Ghost Direction
var eaten : array 1 .. 10 of boolean %Checks if Ghost has already been Eaten
var players : int := 1
var z : int := 0

%%%%%%%%%%DEFINING VARIABLES%%%%%%%%%%
compnum := 5
procedure resetvar
    for i : 1 .. 10
	waitdir (i) := 46
	ghost (i) := Pic.New (0, 0, 0, 0)
	eaten (i) := false
    end for
    nextlevel := 5
    power := 1
    dotnum := 0
    dotnum2 := '0'
    extralife := 1000
    lives := 3
    upwall := true
    downwall := true
    leftwall := true
    rightwall := true
    ai := 2
    startlevel := 1
    drawblock := 0
    co := 0
    x0 := 300
    y0 := 230
    ghostx (1) := 199
    ghosty (1) := 204
    ghostx (2) := 225
    ghosty (2) := 204
    ghostx (3) := 251
    ghosty (3) := 204
    for i : 4 .. 10
	ghostx (i) := 225
	ghosty (i) := 204
    end for
    for i : 1 .. 2
	move (i) := ' '
	x (i) := 236
	y (i) := 33
	oc (i) := 0
	higher (i) := false
    end for
    game := 0
    line := -1
    readfile := 0
    speed := 0
    speed2 := '0'
    level := 1
    level2 := '1'
    count := 0
    score := 0
    score2 := '0'
    map := 0
    continue := false
    a := 29
    b := maxy - 28
    c := 15
    d := 358
    font1 := Font.New ("Showcard Gothic:50")
    font2 := Font.New ("Herman:26")
    font3 := Font.New ("Showcard Gothic:20")
    font4 := Font.New ("RoaringFire:10")
    font5 := Font.New ("Arial:10")
end resetvar
resetvar

procedure clear (gui : int)
    %%%%%%%%%%CLEAR PAGE%%%%%%%%%%
    %Moves Pacman across screen &
    %Slowly Turns Screen Black
    for i : 1 .. maxx + 5
	if co >= 39 then
	    higher (1) := false
	end if
	if co <= 0 then
	    higher (1) := true
	end if
	if higher (1) = false then
	    co := co - 1
	else
	    co := co + 1
	end if
	for i2 : 13 .. 415 by 62
	    drawfillarc (i, i2, 15, 15, 40 - co, 320 + co, yellow)
	    drawfillarc (i, i2 + 31, 15, 15, 1 + co, 359 - co, yellow)
	end for
	View.Update
	delay (2)
	for i2 : 13 .. 415 by 62
	    drawfillarc (i, i2, 15, 15, 40 - co, 320 + co, black)
	    drawfillarc (i, i2 + 31, 15, 15, 10 + co, 350 - co, black)
	end for
    end for
    if gui = 1 then
	GUI.Dispose (playbtn)
	GUI.Dispose (mapbtn)
	GUI.Dispose (helpbox)
    elsif gui = 2 then
	GUI.Dispose (contbtn)
	GUI.Dispose (mapbar)
    end if
    cls
end clear

%%%%%%%%%%SPLASH PAGE%%%%%%%%%%
procedure splash
    Font.Draw ("PACMAN", 164, 345, font1, brightgreen)
    Font.Draw ("By: Alex Kidd", 204, 50, font2, red)
    %Opens/Closes Pacman Mouth
    loop
	if co >= 39 then
	    higher (1) := false
	end if
	if co <= 0 then
	    count := count + 1
	    higher (1) := true
	end if
	if higher (1) = false then
	    co := co - 1
	else
	    co := co + 1
	end if
	drawfillarc (300, 230, 100, 100, 220 - co, 140 + co, yellow)
	View.Update
	delay (6)
	drawfillarc (300, 230, 100, 100, 220 - co, 140 + co, black)
	exit when count = 4
    end loop
    %Shrinks Pacman to top right corner
    for decreasing i : 100 .. 50 by 2
	drawfilloval (x0, y0, i + 5, i + 5, black)
	x0 := x0 + 10
	y0 := y0 + 2
	drawfillarc (x0, y0, i, i, 220, 140, yellow)
	View.Update
	delay (100)
    end for
end splash

%%%%%%%%%%TITLE PAGE/INSTRUCTIONS%%%%%%%%%%
procedure runmapmaker
    startlevel := 0
    game := 1
    continue := true
end runmapmaker
procedure rungame
    startlevel := 1
    game := 0
    continue := true
end rungame

procedure title
    Font.Draw ("PACMAN", 164, 345, font1, brightgreen)
    Font.Draw ("By: Alex Kidd", 204, 50, font2, red)
    drawfillarc (560, 282, 50, 50, 220, 140, yellow)
    locate (5, 33)
    put "Version ", ver ..
    helpbox := GUI.CreateTextBox (150, 100, 300, 180)
    GUI.SetScrollOnAdd (helpbox, false)
    GUI.AddLine (helpbox, "                 GAME PLAY INFORMATION")
    GUI.AddLine (helpbox, "                   Use the Arrow Keys to Move")
    GUI.AddLine (helpbox, "    You will continue to move in the same direction")
    GUI.AddLine (helpbox, "   until you hit a wall or press a different arrow key.")
    GUI.AddLine (helpbox, " ")
    GUI.AddLine (helpbox, "              Eat all the dots to go to next level.")
    GUI.AddLine (helpbox, "           If you touch a ghost you will lose a life.")
    GUI.AddLine (helpbox, "  If you eat a big green dot the ghosts will turn blue")
    GUI.AddLine (helpbox, "      they can then be eaten and they will disappear")
    GUI.AddLine (helpbox, "                   and return to the center area.")
    GUI.AddLine (helpbox, " ")
    GUI.AddLine (helpbox, "                          MAPMAKER HELP")
    GUI.AddLine (helpbox, "Select the Type of Piece you would like to draw with")
    GUI.AddLine (helpbox, "      using the mouse, then click on the map area")
    GUI.AddLine (helpbox, "                     to draw that piece there.")
    GUI.AddLine (helpbox, " ")
    GUI.AddLine (helpbox, "   To create a warp to the other side of the screen")
    GUI.AddLine (helpbox, "     click where you want it on the green border.")
    GUI.AddLine (helpbox, " ")
    GUI.AddLine (helpbox, "             To save your map press the s key,")
    GUI.AddLine (helpbox, " type in the name of your level and press enter.")
    playbtn := GUI.CreateButtonFull (100, 40, 50, "Play", rungame, 0, KEY_ENTER, true)
    mapbtn := GUI.CreateButton (maxx - 150, 40, 50, "Mapmaker", runmapmaker)
    setscreen ('nooffscreenonly')
    loop
	exit when GUI.ProcessEvent
	exit when continue = true
    end loop
    continue := false
    setscreen ('offscreenonly')
end title

%%%%%%%%%%SCROLL BAR EFFECTS%%%%%%%%%%
procedure mapchoice (value : int)
    drawfillbox (230, 100, 400, 175, black)
    map := value
    if map not= startlevel then
	locate (15, 31)
	put map - 1 ..
	put '  ' ..
	put readtitle (map - 1) ..
    end if
    locate (16, 31)
    put map ..
    put '  ' ..
    put readtitle (map) ..
    drawbox (238, 145, 258, 160, brightgreen)
    if map not= titlecount then
	locate (17, 31)
	put map + 1 ..
	put '  ' ..
	put readtitle (map + 1) ..
    end if
end mapchoice

%%%%%%%%%%SPEED BAR EFFECTS%%%%%%%%%%
procedure changespeed (value : int)
    speed := value
    speed2 := intstr (speed) %Converts Speed String to Integer
    locate (8, 34)
    put "Speed: ", speed ..
end changespeed

%%%%%%%%%%AI SELECTION%%%%%%%%%%
procedure aiselect
    for i : 1 .. 3
	if radio (i) = GUI.GetEventWidgetID then
	    ai := i
	end if
    end for
end aiselect

procedure nextselect
    for i : 4 .. 6
	if radio (i) = GUI.GetEventWidgetID then
	    nextlevel := i
	end if
    end for
end nextselect

procedure changecomp (value : int)
    compnum := value
    locate (16, 56)
    put "Ghosts: ", compnum, " " ..
end changecomp

procedure playerselect
    if GUI.GetEventWidgetID = radio (7) then
	players := 1
    else
	players := 2
    end if
end playerselect

%%%%%%%%%%SETTINGS%%%%%%%%%%
procedure processevent
    continue := true
end processevent

procedure settings
    mapchoice (startlevel)
    Font.Draw ("PACMAN", 156, 345, font1, brightgreen)
    if game = 1 then
	Font.Draw ("Select Level to Load", 240, 180, font4, brightgreen)
    end if
    mapbar := GUI.CreateVerticalScrollBar (200, 100, 100, startlevel, titlecount, startlevel, mapchoice)
    GUI.SetSliderReverse (mapbar)
    contbtn := GUI.CreateButtonFull (260, 40, 0, "Continue", processevent, 0, KEY_ENTER, true)
    if game = 0 then
	Font.Draw ("Select Level to Play", 240, 190, font4, brightgreen)
	changespeed (0)
	changecomp (4)
	speedbar := GUI.CreateHorizontalScrollBar (220, 250, 150, 0, 20, 0, changespeed)
	compbar := GUI.CreateHorizontalScrollBar (430, 118, 90, 1, 10, 4, changecomp)
	drawfillbox (430, 190, 520, 280, white)
	drawbox (430, 190, 520, 280, brightgreen)
	Font.Draw ("Ghost AI", 440, 260, font4, black)
	radio (2) := GUI.CreateRadioButton (450, 220, "Dumb", 0, aiselect)
	radio (3) := GUI.CreateRadioButton (450, 200, "Justin", radio (2), aiselect)
	radio (1) := GUI.CreateRadioButton (450, 240, "Smart", radio (3), aiselect)
	GUI.Disable (radio (1))
	drawfillbox (40, 100, 150, 190, white)
	drawbox (40, 100, 150, 190, brightgreen)
	Font.Draw ("Next Level", 50, 170, font4, black)
	radio (5) := GUI.CreateRadioButton (60, 150, "Random", 0, nextselect)
	radio (6) := GUI.CreateRadioButton (60, 110, "Next in List", radio (5), nextselect)
	radio (4) := GUI.CreateRadioButton (60, 130, "Same", radio (6), nextselect)
	drawfillbox (55, 250, 145, 300, white)
	drawbox (55, 250, 145, 300, brightgreen)
	radio (7) := GUI.CreateRadioButton (70, 280, "1 Player", 0, playerselect)
	radio (8) := GUI.CreateRadioButton (70, 260, "2 Player", radio (7), playerselect)
    end if
    setscreen ('nooffscreenonly')
    loop
	Mouse.Where (xmouse, ymouse, button)
	if button = 1 and xmouse > 156 and xmouse < 400 and ymouse > 345 and ymouse < 420 then
	    locate (5, 25)
	    put "Secret Cheap AI Activated"
	    ai := 0
	end if
	exit when GUI.ProcessEvent
	exit when continue = true
    end loop
    continue := false
    setscreen ('offscreenonly')
end settings

%%%%%%%%%%SETUP BORDER%%%%%%%%%%
procedure side
    e := 358
    for i : 1 .. 14
	sidex (i) := 0
	sidey (i) := e
	sidex (i + 14) := maxx - 182
	sidey (i + 14) := e
	e := e - 26
    end for
    e := 15
    for i : 29 .. 45
	sidex (i) := e
	sidey (i) := maxy - 15
	sidex (i + 17) := e
	sidey (i + 17) := 0
	e := e + 26
    end for
    drawfillbox (maxx - 167, 0, maxx, maxy, brightgreen)         %Right
    drawline (maxx - 167, 0, maxx - 167, maxy, black)     %Right Line
    Font.Draw ("PACMAN", 496, 375, font3, darkgrey)     %Title
    Font.Draw ("By: Alex Kidd", 500, 10, font4, red)     %Name
end side

%%%%%%%%%%DRAWS BORDER%%%%%%%%%%
procedure sidedraw
    for i : 1 .. 28
	if readborder (i) = 0 then
	    drawfillbox (sidex (i), sidey (i), sidex (i) + 15, sidey (i) + 26, black)
	end if
    end for
    for i : 29 .. 62
	if readborder (i) = 0 then
	    drawfillbox (sidex (i), sidey (i), sidex (i) + 26, sidey (i) + 20, black)
	end if
    end for
    for i : 1 .. 28
	if readborder (i) = 1 then
	    drawfillbox (sidex (i), sidey (i), sidex (i) + 15, sidey (i) + 26, brightgreen)
	end if
    end for
    for i : 29 .. 62
	if readborder (i) = 1 then
	    drawfillbox (sidex (i), sidey (i), sidex (i) + 26, sidey (i) + 20, brightgreen)
	end if
    end for
    drawfillbox (0, 0, 15, 20, brightgreen)
    drawfillbox (0, maxy - 15, 15, maxy, brightgreen)
    drawfillbox (maxx - 182, 0, maxx - 167, 20, brightgreen)
    drawfillbox (maxx - 182, maxy - 15, maxx - 167, maxy, brightgreen)
end sidedraw

%%%%%%%%%%SIDE INFORMATION%%%%%%%%%%
procedure info
    drawfillbox (maxx - 167, 0, maxx, maxy, brightgreen)     %Right
    drawline (maxx - 167, 0, maxx - 167, maxy, black)     %Right Line
    Font.Draw ("PACMAN", 496, 375, font3, darkgrey)     %Title
    Font.Draw ("By: Alex Kidd", 500, 10, font4, red)     %Name
    Font.Draw ("Lives", 496, 330, font5, black)     %Lives
    for i : 1 .. lives * 12 by 12
	drawfillarc (560 + i, 333, 5, 5, 40, 320, yellow)
    end for
    Font.Draw ("Level", 496, 300, font5, black)     %Level
    Font.Draw (level2, 560, 300, font5, black)
    Font.Draw ("Score", 496, 270, font5, black)         %Score
    Font.Draw (score2, 560, 270, font5, black)
    Font.Draw ("Speed", 496, 240, font5, black)     %Speed
    Font.Draw (speed2, 560, 240, font5, black)
    Font.Draw ("Dots Left", 496, 210, font5, black)         %Dots Left
    Font.Draw (dotnum2, 560, 210, font5, black)
end info

%%%%%%%%%%MOVE PACMAN%%%%%%%%%%
procedure movepacman
    for i : 1 .. players
	if move (i) = 'up' and whatdotcolour (x (i) - 12, y (i) + 13) not= grey and whatdotcolour (x (i) + 12, y (i) + 13) not= grey and
		whatdotcolour (x (i) - 12, y (i) + 13) not= brightgreen and whatdotcolour (x (i) + 12, y (i) + 13) not= brightgreen
		or move (i) = 'up' and y (i) > maxy - 15 then
	    if y (i) > maxy + 11 then
		y (i) := -11
	    else
		y (i) := y (i) + 1
	    end if
	elsif move (i) = 'down' and whatdotcolour (x (i) - 12, y (i) - 13) not= grey and whatdotcolour (x (i) + 12, y (i) - 13) not= grey and
		whatdotcolour (x (i) - 12, y (i) - 13) not= brightgreen and whatdotcolour (x (i) + 12, y (i) - 13) not= brightgreen then
	    if y (i) < -11 then
		y (i) := maxy + 11
	    else
		y (i) := y (i) - 1
	    end if
	elsif move (i) = 'left' and whatdotcolour (x (i) - 13, y (i) - 12) not= grey and whatdotcolour (x (i) - 13, y (i) + 12) not= grey
		and whatdotcolour (x (i) - 13, y (i) - 12) not= brightgreen and whatdotcolour (x (i) - 13, y (i) + 12) not= brightgreen
		or move (i) = 'left' and x (i) > maxx - 167 or move (i) = 'left' and x (i) < 15 then
	    if x (i) < -11 then
		x (i) := maxx - 152
	    else
		x (i) := x (i) - 1
	    end if
	elsif move (i) = 'right' and whatdotcolour (x (i) + 13, y (i) - 12) not= grey and whatdotcolour (x (i) + 13, y (i) + 12) not= grey
		and move (i) = 'right' and whatdotcolour (x (i) + 13, y (i) - 12) not= brightgreen and whatdotcolour (x (i) + 13, y (i) + 12) not= brightgreen
		or move (i) = 'right' and x (i) > maxx - 180 then
	    if x (i) > maxx - 152 then
		x (i) := -11
	    else
		x (i) := x (i) + 1
	    end if
	end if
    end for
end movepacman

%%%%%%%%%%DRAW PACMAN%%%%%%%%%%
procedure drawpacman
    for decreasing i : players .. 1
	if oc (i) >= 39 then
	    higher (i) := false
	end if
	if oc (i) <= 0 then
	    higher (i) := true
	end if
	if move (i) not= ' ' then
	    if higher (i) = false then
		oc (i) := oc (i) - 1
	    else
		oc (i) := oc (i) + 1
	    end if
	end if
	if move (i) = 'right' then
	    drawfillarc (x (i), y (i), 11, 11, 40 - oc (i), 320 + oc (i), 45 - i)
	elsif move (i) = 'left' then
	    drawfillarc (x (i), y (i), 11, 11, 220 - oc (i), 140 + oc (i), 45 - i)
	elsif move (i) = 'up' then
	    drawfillarc (x (i), y (i), 11, 11, 130 - oc (i), 50 + oc (i), 45 - i)
	elsif move (i) = 'down' then
	    drawfillarc (x (i), y (i), 11, 11, 310 - oc (i), 230 + oc (i), 45 - i)
	else
	    drawfillarc (x (i), y (i), 11, 11, 40, 320, 45 - i)
	end if
    end for
end drawpacman

%%%%%%%%%%CHECKS FOR KEY PRESS%%%%%%%%%%
procedure direction
    Input.KeyDown (chars)
    if chars (KEY_UP_ARROW) and whatdotcolour (x (1) - 12, y (1) + 13) not= grey and whatdotcolour (x (1) + 12, y (1) + 13) not= grey
	    and whatdotcolour (x (1), y (1) + 13) not= grey and whatdotcolour (x (1) - 12, y (1) + 13) not= brightgreen
	    and whatdotcolour (x (1) + 12, y (1) + 13) not= brightgreen and whatdotcolour (x (1), y (1) + 13) not= brightgreen then
	move (1) := 'up'
    elsif chars (KEY_DOWN_ARROW) and whatdotcolour (x (1) - 12, y (1) - 13) not= grey and whatdotcolour (x (1) + 12, y (1) - 13) not= grey
	    and whatdotcolour (x (1), y (1) - 13) not= grey and whatdotcolour (x (1) - 12, y (1) - 13) not= brightgreen
	    and whatdotcolour (x (1) + 12, y (1) - 13) not= brightgreen and whatdotcolour (x (1), y (1) - 13) not= brightgreen then
	move (1) := 'down'
    elsif chars (KEY_LEFT_ARROW) and whatdotcolour (x (1) - 13, y (1) - 12) not= grey and whatdotcolour (x (1) - 13, y (1) + 12) not= grey
	    and whatdotcolour (x (1) - 13, y (1)) not= grey and whatdotcolour (x (1) - 13, y (1) - 12) not= brightgreen
	    and whatdotcolour (x (1) - 13, y (1) + 12) not= brightgreen and whatdotcolour (x (1) - 13, y (1)) not= brightgreen then
	move (1) := 'left'
    elsif chars (KEY_RIGHT_ARROW) and whatdotcolour (x (1) + 13, y (1) - 12) not= grey and whatdotcolour (x (1) + 13, y (1) + 12) not= grey
	    and whatdotcolour (x (1) + 13, y (1)) not= grey and whatdotcolour (x (1) + 13, y (1) - 12) not= brightgreen
	    and whatdotcolour (x (1) + 13, y (1) + 12) not= brightgreen and whatdotcolour (x (1) + 13, y (1)) not= brightgreen then
	move (1) := 'right'
    end if
    if players = 2 then
	if chars ('w') and whatdotcolour (x (2) - 12, y (2) + 13) not= grey and whatdotcolour (x (2) + 12, y (2) + 13) not= grey
		and whatdotcolour (x (2), y (2) + 13) not= brightgreen and whatdotcolour (x (2) - 12, y (2) + 13) not= brightgreen
		and whatdotcolour (x (2) + 12, y (2) + 13) not= brightgreen and whatdotcolour (x (2), y (2) + 13) not= brightgreen then
	    move (2) := 'up'
	elsif chars ('s') and whatdotcolour (x (2) - 12, y (2) - 13) not= grey and whatdotcolour (x (2) + 12, y (2) - 13) not= grey
		and whatdotcolour (x (2), y (2) - 13) not= grey and whatdotcolour (x (2) - 12, y (2) - 13) not= brightgreen
		and whatdotcolour (x (2) + 12, y (2) - 13) not= brightgreen and whatdotcolour (x (2), y (2) - 13) not= brightgreen then
	    move (2) := 'down'
	elsif chars ('a') and whatdotcolour (x (2) - 13, y (2) - 12) not= grey and whatdotcolour (x (2) - 13, y (2) + 12) not= grey
		and whatdotcolour (x (2) - 13, y (2)) not= grey and whatdotcolour (x (2) - 13, y (2) - 12) not= brightgreen
		and whatdotcolour (x (2) - 13, y (2) + 12) not= brightgreen and whatdotcolour (x (2) - 13, y (2)) not= brightgreen then
	    move (2) := 'left'
	elsif chars ('d') and whatdotcolour (x (2) + 13, y (2) - 12) not= grey and whatdotcolour (x (2) + 13, y (2) + 12) not= grey
		and whatdotcolour (x (2) + 13, y (2)) not= grey and whatdotcolour (x (2) + 13, y (2) - 12) not= brightgreen
		and whatdotcolour (x (2) + 13, y (2) + 12) not= brightgreen and whatdotcolour (x (2) + 13, y (2)) not= brightgreen then
	    move (2) := 'right'
	end if
    end if
end direction

%%%%%%%%%%SETUP MAP%%%%%%%%%%
procedure getnum (fileName : string)
    open : f, fileName, get
    dotnum := 0
    titlecount := -1
    blockcount := 0
    bordercount := 0
    readfile := 0
    line := -1
    new readtitle, 0
    new readblock, 0
    new readborder, 0
    loop
	exit when eof (f)
	get : f, num : 1
	if num = '8' then
	    line := line + 1
	    titlecount := titlecount + 1
	    new readtitle, titlecount
	    readtitle (titlecount) := ' '
	    readfile := 0
	end if
	if num = '9' or num = '8' then
	    readfile := readfile + 1
	    get : f, num : 1
	end if
	if readfile = 1 then
	    readtitle (titlecount) := readtitle (titlecount) + num
	end if
	if line = map then
	    if readfile = 2 then
		blockcount := blockcount + 1
		new readblock, blockcount
		readblock (blockcount) := strint (num)
		if num = '2' or num = '3' then
		    dotnum := dotnum + 1
		end if
	    elsif readfile = 3 then
		bordercount := bordercount + 1
		new readborder, (bordercount)
		readborder (bordercount) := strint (num)
	    end if
	end if
    end loop
    close : f
    dotnum2 := intstr (dotnum)
end getnum

procedure setupmap
    getnum ('levels.txt')
end setupmap

%%%%%%%%%%CORDINATES FOR WALL%%%%%%%%%%
procedure wall
    c := 15
    d := 358
    for i : 1 .. 238
	wallx (i) := c
	wally (i) := d
	c := c + 26
	if c > 431 then
	    c := 15
	    d := d - 26
	end if
    end for
end wall

%%%%%%%%%%CORDINATES FOR FOOD%%%%%%%%%%
procedure food
    a := 29
    b := maxy - 28
    for i : 1 .. 238
	foodx (i) := a
	foody (i) := b
	a := a + 26
	if a > maxx - 190 then
	    a := 29
	    b := b - 26
	end if
    end for
end food

%%%%%%%%%%DRAW FOOD/WALLS%%%%%%%%%%
procedure drawmap
    drawfillbox (15, 20, maxx - 183, maxy - 15, black)
    for i : 1 .. 238
	if readblock (i) = 1 then
	    drawfillbox (wallx (i), wally (i), wallx (i) + 26, wally (i) + 26, grey)
	elsif readblock (i) = 2 then
	    drawfilloval (foodx (i), foody (i), 2, 2, 68)
	elsif readblock (i) = 3 then
	    drawfilloval (foodx (i), foody (i), 5, 5, green)
	end if
    end for
end drawmap

%%%%%%%%%%DELETE FOOD IF EATEN%%%%%%%%%%
procedure eatfood
    for i2 : 1 .. players
	for i : 1 .. 238
	    if foodx (i) < x (i2) + 5 and foodx (i) > x (i2) - 5 and
		    foody (i) > y (i2) - 5 and foody (i) < y (i2) + 5 then
		drawfilloval (foodx (i), foody (i), 2, 2, black)
		foodx (i) := -5
		foody (i) := -5
		if readblock (i) = 2 then
		    score := score + 5
		    dotnum := dotnum - 1
		elsif readblock (i) = 3 then
		    score := score + 25
		    power := 500
		    dotnum := dotnum - 1
		end if
		dotnum2 := intstr (dotnum)
		score2 := intstr (score)
		if score > extralife then
		    lives := lives + 1
		    extralife := extralife + 1000
		end if
	    end if
	end for
    end for
end eatfood

%%%%%%%%%%TYPE TO DRAW IN MAPMAKER%%%%%%%%%%
procedure typeselect
    blockx (0) := 500
    blocky (0) := 200
    blockx (1) := 550
    blocky (1) := 200
    blockx (2) := 513
    blocky (2) := 150
    blockx (3) := 563
    blocky (3) := 150
    drawfillbox (blockx (0), blocky (0), blockx (0) + 26, blocky (0) + 26, black)
    drawfillbox (blockx (1), blocky (1), blockx (1) + 26, blocky (1) + 26, grey)
    drawfilloval (blockx (2), blocky (2), 2, 2, 68)
    drawfilloval (blockx (3), blocky (3), 5, 5, green)
    Font.Draw ("Press s to Save", 496, 100, font5, black)
end typeselect

%%%%%%%%%%MAPMAKER%%%%%%%%%%
procedure mapmaker
    Mouse.Where (xmouse, ymouse, button)
    if button = 1 then
	for i : 1 .. 238
	    if xmouse > wallx (i) and ymouse > wally (i) and xmouse < wallx (i) + 26 and ymouse < wally (i) + 26 then
		if i not= 110 and i not= 111 and i not= 112 and i not= 230 then
		    readblock (i) := drawblock
		    drawfillbox (15, 20, maxx - 182, maxy - 15, black)
		    drawmap
		end if
	    end if
	end for
	for i : 0 .. 3
	    if i = 0 or i = 1 then
		if xmouse > blockx (i) and ymouse > blocky (i) and xmouse < blockx (i) + 26 and ymouse < blocky (i) + 26 then
		    drawblock := i
		end if
	    else
		if xmouse > blockx (i) - 13 and ymouse > blocky (i) - 13 and xmouse < blockx (i) + 13 and ymouse < blocky (i) + 13 then
		    drawblock := i
		end if
	    end if
	end for
	for i : 1 .. 28
	    if xmouse > sidex (i) and ymouse > sidey (i) and xmouse < sidex (i) + 15 and ymouse < sidey (i) + 26 then
		if readborder (i) = 1 then
		    readborder (i) := 0
		    if i <= 14 then
			readborder (i + 14) := 0
		    else
			readborder (i - 14) := 0
		    end if
		else
		    readborder (i) := 1
		    if i <= 14 then
			readborder (i + 14) := 1
		    else
			readborder (i - 14) := 1
		    end if
		end if
		sidedraw
		loop
		    Mouse.Where (xmouse, ymouse, button)
		    exit when button = 0
		end loop
	    end if
	end for
	for i : 29 .. 62
	    if xmouse > sidex (i) and ymouse > sidey (i) and xmouse < sidex (i) + 26 and ymouse < sidey (i) + 20 then
		if readborder (i) = 1 then
		    readborder (i) := 0
		    if i <= 45 then
			readborder (i + 17) := 0
		    else
			readborder (i - 17) := 0
		    end if
		else
		    readborder (i) := 1
		    if i <= 45 then
			readborder (i + 17) := 1
		    else
			readborder (i - 17) := 1
		    end if
		end if
		sidedraw
		loop
		    Mouse.Where (xmouse, ymouse, button)
		    exit when button = 0
		end loop
	    end if
	end for
    end if
end mapmaker

procedure save
    Input.KeyDown (chars)
    if chars ('s') then
	setscreen ('nooffscreenonly,cursor')
	drawfillbox (120, 150, 380, 250, black)
	drawbox (120, 150, 380, 250, brightgreen)
	locate (11, 22)
	put "Enter Level Name? " ..
	locate (13, 17)
	get typename
	drawfillbox (120, 150, 380, 250, black)
	drawbox (120, 150, 380, 250, brightgreen)
	locate (11, 21)
	put "Saving Please Wait " ..
	File.Copy ('levels.txt', 'temp.txt')
	open : f, 'levels.txt', get
	open : temp, 'temp.txt', put
	loop
	    exit when eof (f)     %exits when you get to the end of the file
	    get : f, data : 255     %get the name from the first file
	    put : temp, data ..     %write to the temp file
	end loop
	writemap := '8'
	writemap += typename
	put : temp, writemap ..
	writemap := '9'
	for i : 1 .. 238
	    writemap += intstr (readblock (i))
	end for
	put : temp, writemap ..
	writemap := '9'
	for i : 1 .. 62
	    writemap += intstr (readborder (i))
	end for
	writemap += '9'
	put : temp, writemap
	locate (13, 25)
	put "Save Complete" ..
	close : f
	close : temp
	File.Delete ("levels.txt")     %deletes the old one
	File.Rename ("temp.txt", "levels.txt")
	setscreen ('offscreenonly,nocursor')
	delay (300)
	cls
	side
	sidedraw
	drawmap
	typeselect
    end if
end save

moveg (1) := 'left'
moveg (2) := 'right'
moveg (3) := 'up'
moveg (4) := 'down'

procedure aipic (ghostcol : int)
    drawfilloval (50, 100, 11, 11, ghostcol)
    drawfillbox (39, 89, 61, 100, ghostcol)
    drawfilloval (45, 100, 2, 2, darkgrey)
    drawfilloval (55, 100, 2, 2, darkgrey)
    drawfillpolygon (g1, g2, 7, black)
    if ghostcol = brightblue then
	ghost (0) := Pic.New (39, 89, 61, 111)
	Pic.SetTransparentColor (ghost (0), black)
    else
	z := z + 1
    end if
    ghost (z) := Pic.New (39, 89, 61, 111)
    Pic.SetTransparentColor (ghost (z), black)
    cls
end aipic

procedure changedir
    randint (randdir, 1, 4)
    if randdir = 1 then
	newdir := 'up'
    elsif randdir = 2 then
	newdir := 'right'
    elsif randdir = 3 then
	newdir := 'down'
    elsif randdir = 4 then
	newdir := 'left'
    end if
end changedir

%%%%%%%%%%MOVE GHOSTS%%%%%%%%%%
procedure moveghost
    if ai = 0 then
	for i : 1 .. compnum
	    randint (randdir, 1, 3)
	    if randdir = 2 or randdir = 3 then
		randdir := -1
	    end if
	    if ghostx (i) + 11 < x (i) then
		ghostx (i) := ghostx (i) - randdir
	    elsif ghostx (i) + 11 > x (i) then
		ghostx (i) := ghostx (i) + randdir
	    end if
	    if ghosty (i) + 11 < y (i) then
		ghosty (i) := ghosty (i) - randdir
	    elsif ghosty (i) + 11 > y (i) then
		ghosty (i) := ghosty (i) + randdir
	    end if
	end for
    elsif ai = 3 or ai = 2 then
	for i : 1 .. compnum
	    changedir
	    if ghostx (i) = 225 and ghosty (i) = 204 then
		moveg (i) := newdir
	    end if
	    if ai = 2 then
		upwall := true
		downwall := true
		leftwall := true
		rightwall := true
		if waitdir (i) < 46 then
		    waitdir (i) := waitdir (i) + 1
		end if
		if waitdir (i) = 46 then
		    if whatdotcolour (ghostx (i) - 1, ghosty (i) + 24) = black and whatdotcolour (ghostx (i) + 23, ghosty (i) + 24) = black
			    and whatdotcolour (ghostx (i) + 11, ghosty (i) + 24) = black then
			upwall := false
		    end if
		    if whatdotcolour (ghostx (i) - 1, ghosty (i) - 2) = black and whatdotcolour (ghostx (i) + 23, ghosty (i) - 2) = black
			    and whatdotcolour (ghostx (i) + 11, ghosty (i) - 2) = black then
			downwall := false
		    end if
		    if whatdotcolour (ghostx (i) - 2, ghosty (i) - 1) = black and whatdotcolour (ghostx (i) - 2, ghosty (i) + 23) = black
			    and whatdotcolour (ghostx (i) - 2, ghosty (i) + 11) = black then
			leftwall := false
		    end if
		    if whatdotcolour (ghostx (i) + 24, ghosty (i) - 1) = black and whatdotcolour (ghostx (i) + 24, ghosty (i) + 23) = black
			    and whatdotcolour (ghostx (i) + 24, ghosty (i) + 11) = black then
			rightwall := false
		    end if
		end if
	    end if
	    if moveg (i) = 'up' then
		if rightwall = false or leftwall = false then
		    if newdir not= 'down' then
			moveg (i) := newdir
			waitdir (i) := 0
		    end if
		elsif whatdotcolour (ghostx (i) - 1, ghosty (i) + 24) not= grey and whatdotcolour (ghostx (i) + 23, ghosty (i) + 24) not= grey and
			whatdotcolour (ghostx (i) - 1, ghosty (i) + 24) not= brightgreen and whatdotcolour (ghostx (i) + 23, ghosty (i) + 24) not= brightgreen
			or ghosty (i) > maxx - 15 then
		    if ghosty (i) > maxy + 11 then
			ghosty (i) := -11
		    else
			ghosty (i) := ghosty (i) + 1
		    end if
		else
		    if ai = 2 and newdir not= 'down' then
			moveg (i) := newdir
			waitdir (i) := 0
		    else
			if newdir = 'up' then
			    moveg (i) := 'down'
			else
			    moveg (i) := newdir
			end if
		    end if
		end if
	    elsif moveg (i) = 'down' then
		if rightwall = false or leftwall = false then
		    if newdir not= 'up' then
			moveg (i) := newdir
			waitdir (i) := 0
		    end if
		elsif whatdotcolour (ghostx (i) - 1, ghosty (i) - 2) not= grey and whatdotcolour (ghostx (i) + 23, ghosty (i) - 2) not= grey and
			whatdotcolour (ghostx (i) - 1, ghosty (i) - 2) not= brightgreen and whatdotcolour (ghostx (i) + 23, ghosty (i) - 2) not= brightgreen then
		    if ghosty (i) < -11 then
			ghosty (i) := maxy + 11
		    else
			ghosty (i) := ghosty (i) - 1
		    end if
		else
		    if ai = 2 and newdir not= 'up' then
			moveg (i) := newdir
			waitdir (i) := 0
		    else
			if newdir = 'down' then
			    moveg (i) := 'up'
			else
			    moveg (i) := newdir
			end if
		    end if
		end if
	    elsif moveg (i) = 'left' then
		if upwall = false or downwall = false then
		    if newdir not= 'right' then
			moveg (i) := newdir
			waitdir (i) := 0
		    end if
		elsif whatdotcolour (ghostx (i) - 2, ghosty (i) - 1) not= grey and whatdotcolour (ghostx (i) - 2, ghosty (i) + 23) not= grey and
			whatdotcolour (ghostx (i) - 2, ghosty (i) - 1) not= brightgreen and whatdotcolour (ghostx (i) - 2, ghosty (i) + 23) not= brightgreen
			or ghostx (i) > maxx - 167 or moveg (i) = 'left' and ghostx (i) < 15 then
		    if ghostx (i) < -11 then
			ghostx (i) := maxx - 152
		    else
			ghostx (i) := ghostx (i) - 1
		    end if
		else
		    if ai = 2 and newdir not= 'right' then
			moveg (i) := newdir
			waitdir (i) := 0
		    else
			if newdir = 'left' then
			    moveg (i) := 'right'
			else
			    moveg (i) := newdir
			end if
		    end if
		end if
	    elsif moveg (i) = 'right' then
		if upwall = false or downwall = false then
		    if newdir not= 'left' then
			moveg (i) := newdir
			waitdir (i) := 0
		    end if
		elsif whatdotcolour (ghostx (i) + 24, ghosty (i) - 1) not= grey and whatdotcolour (ghostx (i) + 24, ghosty (i) + 23) not= grey and
			whatdotcolour (ghostx (i) + 24, ghosty (i) - 1) not= brightgreen and whatdotcolour (ghostx (i) + 24, ghosty (i) + 23) not= brightgreen
			or moveg (i) = 'right' and ghostx (i) > maxx - 200 then
		    if ghostx (i) > maxx - 152 then
			ghostx (i) := -11
		    else
			ghostx (i) := ghostx (i) + 1
		    end if
		else
		    if ai = 2 and newdir not= 'left' then
			moveg (i) := newdir
			waitdir (i) := 0
		    else
			if newdir = 'right' then
			    moveg (i) := 'left'
			else
			    moveg (i) := newdir
			end if
		    end if
		end if
	    end if
	end for
    end if
end moveghost

%%%%%%%%%%DRAW GHOSTS%%%%%%%%%%
procedure drawghost
    if power > 0 then
	power := power - 1
    end if
    if power = 1 then
	for i : 1 .. compnum
	    eaten (i) := false
	end for
    end if
    for decreasing i : compnum .. 1
	if power = 0 or eaten (i) = true then
	    Pic.Draw (ghost (i), ghostx (i), ghosty (i), picMerge)
	else
	    Pic.Draw (ghost (0), ghostx (i), ghosty (i), picMerge)
	end if
	for i2 : 1 .. 100 by 5
	    if i2 = power then
		Pic.Draw (ghost (i), ghostx (i), ghosty (i), picMerge)
	    end if
	end for
    end for
end drawghost

%%%%%%%%%%CHECKS FOR GHOST HIT%%%%%%%%%%
procedure killed
    for i : 1 .. compnum
	if whatdotcolour (ghostx (i) + 20, ghosty (i) + 2) = yellow or whatdotcolour (ghostx (i) + 20, ghosty (i) + 20) = yellow or
		whatdotcolour (ghostx (i) + 2, ghosty (i) + 2) = yellow or whatdotcolour (ghostx (i) + 2, ghosty (i) + 20) = yellow or
		whatdotcolour (ghostx (i) + 20, ghosty (i) + 2) = 43 or whatdotcolour (ghostx (i) + 20, ghosty (i) + 20) = 43 or
		whatdotcolour (ghostx (i) + 2, ghosty (i) + 2) = 43 or whatdotcolour (ghostx (i) + 2, ghosty (i) + 20) = 43 then
	    if power = 0 or eaten (i) = true then
		for i2 : 1 .. players
		    oc (i2) := 0
		end for
		loop
		    for i2 : 1 .. players
			drawfilloval (x (i2), y (i2), 12, 12, black)
		    end for
		    for i2 : 1 .. compnum
			Pic.Draw (ghost (i), ghostx (i), ghosty (i), picMerge)
		    end for
		    for i2 : 1 .. players
			oc (i2) := oc (i2) + 1
			if oc (i2) < 90 then
			    drawfillarc (x (i2), y (i2), 11, 11, 90 + oc (i2), 90 - oc (i2), yellow)
			else
			    drawfillarc (x (i2), y (i2), 11, 11, 90 + oc (i2), 450 - oc (i2), yellow)
			end if
		    end for
		    exit when oc (1) = 177
		    View.Update
		    delay (10)
		end loop
		View.Update
		power := 1
		lives := lives - 1
		ghostx (1) := 199
		ghosty (1) := 204
		ghostx (2) := 225
		ghosty (2) := 204
		ghostx (3) := 251
		ghosty (3) := 204
		for i2 : 4 .. 10
		    ghostx (i2) := 225
		    ghosty (i2) := 204
		end for
		for i2 : 1 .. players
		    x (i2) := 236
		    y (i2) := 33
		    oc (i2) := 0
		    move (i2) := ' '
		end for
	    else
		eaten (i) := true
		ghostx (i) := 225
		ghosty (i) := 204
		score := score + 100
		score2 := intstr (score)
		if score > extralife then
		    lives := lives + 1
		    extralife := extralife + 1000
		end if
	    end if
	end if
    end for
end killed

%%%%%%%%%%RUN GAME%%%%%%%%%%
drawghost
splash
loop
    food
    wall
    title
    clear (1)
    setupmap
    settings
    clear (2)
    cls
    z := 0
    aipic (brightblue)
    aipic (red)
    aipic (green)
    aipic (blue)
    aipic (42)
    aipic (white)
    aipic (5)
    aipic (11)
    aipic (69)
    aipic (13)
    aipic (40)
    side
    sidedraw
    setupmap
    if game = 1 then
	drawmap
	typeselect
	loop
	    mapmaker
	    save
	    View.Update
	end loop
    else
	loop
	    loop
		killed
		direction
		movepacman
		moveghost
		eatfood
		drawmap
		sidedraw
		drawghost
		drawpacman
		info
		View.Update
		delay (speed)
		exit when lives = 0
		exit when dotnum = 0
	    end loop
	    exit when lives = 0
	    Font.Draw ("YOU WIN", 80, 200, font1, green)
	    View.Update
	    delay (1000)
	    ghostx (1) := 199
	    ghosty (1) := 204
	    ghostx (2) := 225
	    ghosty (2) := 204
	    ghostx (3) := 251
	    ghosty (3) := 204
	    ghostx (4) := 225
	    ghosty (4) := 204
	    for i : 1 .. players
		x (i) := 236
		y (i) := 33
		oc (i) := 0
		move (i) := ' '
	    end for
	    power := 1
	    if nextlevel = 5 then
		randint (map, 1, line)
	    elsif nextlevel = 6 then
		if map = line then
		    map := 1
		else
		    map := map + 1
		end if
	    end if
	    level := level + 1
	    level2 := intstr (level)
	    food
	    setupmap
	    drawmap
	    Font.Draw ("Level", 120, 200, font1, green)
	    Font.Draw (level2, 300, 200, font1, green)
	    View.Update
	    delay (1000)
	end loop
    end if
    if lives = 0 then
	Font.Draw ("GAME OVER", 60, 200, font1, green)
	View.Update
	delay (1000)
    end if
    clear (3)
    resetvar
end loop
