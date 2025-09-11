program FlameOfBriarsHollow;

{*****************************************************************
 * The Flame of Briar's Hollow - A D&D Style Text Adventure
 * 
 * Story: In the land of Elarion, the Crystal Spire has shattered,
 * spreading chaos across the realm. The village of Briar's Hollow
 * faces destruction by the Ashen Vanguard unless the stolen
 * Flame of Elarion can be recovered.
 *
 * Features: Multiple character classes with unique abilities,
 * branching storylines, and strategic combat choices.
 *****************************************************************}

uses crt;

type
  CharacterClass = (Paladin, Ranger, Cleric, Barbarian, Warlock);

var
  choice: string;
  playerClass: CharacterClass;
  playerName: string;
  hasFlame: boolean;

{*****************************************************************
 * Displays the game introduction and setting
 *****************************************************************}
procedure ShowIntroduction;
begin
  writeln('========================================');
  writeln('   THE FLAME OF BRIAR''S HOLLOW');
  writeln('    A D&D-Style Text Adventure');
  writeln('========================================');
  writeln();
  writeln('The land of Elarion once thrived under the light of the Crystal Spire,');
  writeln('a beacon of balance and hope. But when the Spire shattered, chaos');
  writeln('spread across the realm. Dark factions rise, villages burn, and');
  writeln('whispers of ancient relics stir in forgotten ruins.');
  writeln();
end;

{*****************************************************************
 * Handles character class selection with unique descriptions
 *****************************************************************}
procedure SelectCharacterClass;
begin
  writeln('Choose your hero for this adventure:');
  writeln();
  writeln('1. Human Paladin - An honor-bound knight seeking redemption');
  writeln('2. Elf Ranger - A keen-eyed tracker of the wilds');  
  writeln('3. Dwarf Cleric - A devoted healer wielding divine wrath');
  writeln('4. Half-Orc Barbarian - A loyal warrior fueled by strength');
  writeln('5. Tiefling Warlock - A mysterious figure bound by a dark pact');
  writeln();
  write('Enter your choice (1-5): ');
  readln(choice);
  
  if choice = '1' then
  begin
    playerClass := Paladin;
    writeln('You are a Human Paladin, sworn to protect the innocent.');
  end
  else if choice = '2' then
  begin
    playerClass := Ranger;
    writeln('You are an Elf Ranger, one with nature and its secrets.');
  end
  else if choice = '3' then
  begin
    playerClass := Cleric;
    writeln('You are a Dwarf Cleric, blessed with divine power.');
  end
  else if choice = '4' then
  begin
    playerClass := Barbarian;
    writeln('You are a Half-Orc Barbarian, fierce and unstoppable.');
  end
  else if choice = '5' then
  begin
    playerClass := Warlock;
    writeln('You are a Tiefling Warlock, wielding forbidden magic.');
  end
  else
  begin
    writeln('Invalid choice. Defaulting to Human Paladin.');
    playerClass := Paladin;
  end;
  
  writeln();
  write('What is your name, hero? ');
  readln(playerName);
  writeln();
end;

{*****************************************************************
 * The opening scene in Briar's Hollow village
 *****************************************************************}
procedure BriarsHollowScene;
begin
  writeln('--- BRIAR''S HOLLOW ---');
  writeln();
  writeln('You arrive in the small farming village of Briar''s Hollow, where');
  writeln('smoke curls on the horizon. The villagers panic - rumors spread that');
  writeln('the Ashen Vanguard, a ruthless mercenary army, is marching toward them.');
  writeln();
  writeln('The village elder, a weathered man with desperate eyes, approaches you:');
  writeln();
  writeln('"' + playerName + ', we have no walls, no soldiers. Only hope.');
  writeln('Long ago, we were protected by the Flame of Elarion, a relic of');
  writeln('light and courage... but it was stolen. Without it, we are lost."');
  writeln();
  writeln('A strange pull draws you toward the ruined Crystal Spire, where');
  writeln('legends say the Flame was last seen.');
  writeln();
  writeln('What do you do?');
  writeln('1. Head immediately to the Crystal Spire');
  writeln('2. Gather information from the villagers first');
  writeln('3. Prepare weapons and supplies');
  write('Choose (1-3): ');
  readln(choice);
end;

{*****************************************************************
 * Handles preparation phase with class-specific options
 *****************************************************************}
procedure PreparationPhase;
begin
  writeln();
  if choice = '1' then
  begin
    writeln('You set out immediately for the Crystal Spire, driven by urgency.');
    writeln('Time is of the essence!');
  end
  else if choice = '2' then
  begin
    writeln('You speak with the villagers and learn valuable information:');
    writeln('- The Ashen Vanguard is led by General Malrek, a fallen knight');
    writeln('- The Flame was seen bound to dark armor');
    writeln('- The Crystal Spire is treacherous at night');
  end
  else if choice = '3' then
  begin
    writeln('You prepare for the journey ahead.');
    if playerClass = Paladin then
      writeln('You bless your sword and don your holy symbol.')
    else if playerClass = Ranger then
      writeln('You check your bow and gather tracking supplies.')
    else if playerClass = Cleric then
      writeln('You pray for divine protection and prepare healing herbs.')
    else if playerClass = Barbarian then
      writeln('You sharpen your axe and work yourself into battle fury.')
    else if playerClass = Warlock then
      writeln('You commune with your patron and prepare dark rituals.');
  end
  else
  begin
    writeln('Confused by the situation, you hesitate...');
  end;
  writeln();
end;

{*****************************************************************
 * The journey to and arrival at the Crystal Spire
 *****************************************************************}
procedure CrystalSpireScene;
begin
  writeln('--- THE CRYSTAL SPIRE ---');
  writeln();
  writeln('Under cover of night, you travel to the Spire. Shattered pillars');
  writeln('jut out of the ground like broken teeth. The air crackles with');
  writeln('residual magic, and shadows dance in unnatural ways.');
  writeln();
  writeln('There, commanding the Ashen Vanguard, stands General Malrek - a');
  writeln('fallen knight whose blackened armor pulses with stolen light.');
  writeln('The Flame of Elarion burns trapped within his chestplate!');
  writeln();
  writeln('Malrek''s voice booms across the ruins:');
  writeln('"Another fool comes to die! The Flame serves ME now!"');
  writeln();
  writeln('How do you approach this battle?');
  writeln('1. Challenge Malrek to honorable single combat');
  writeln('2. Use stealth to get close');
  writeln('3. Attack with magic/ranged abilities');
  write('Choose your strategy (1-3): ');
  readln(choice);
end;

{*****************************************************************
 * Combat resolution with class-specific abilities and outcomes
 *****************************************************************}
procedure ResolveCombat;
begin
  writeln();
  if choice = '1' then
  begin
    writeln('You step forward boldly, challenging Malrek directly.');
    if (playerClass = Paladin) then
    begin
      writeln('Your divine righteousness burns away his dark magic!');
      writeln('Steel clashes against steel in honorable combat.');
      hasFlame := true;
    end
    else if (playerClass = Barbarian) then
    begin
      writeln('You roar with primal fury, matching his strength!');
      writeln('Your relentless assault breaks through his defenses.');
      hasFlame := true;
    end
    else
    begin
      writeln('Though brave, you struggle in direct combat.');
      writeln('You barely escape with your life. The village is doomed.');
      hasFlame := false;
    end;
  end
  else if choice = '2' then
  begin
    if (playerClass = Ranger) then
    begin
      writeln('You use the shadows and ruins for cover, striking');
      writeln('at the perfect moment when his guard is down!');
      hasFlame := true;
    end
    else if (playerClass = Warlock) then
    begin
      writeln('You slip through shadows with supernatural grace,');
      writeln('using dark magic to confuse and disorient him.');
      hasFlame := true;
    end
    else
    begin
      writeln('You attempt stealth but lack the proper training.');
      writeln('Malrek spots you and his counterattack is devastating.');
      hasFlame := false;
    end;
  end
  else if choice = '3' then
  begin
    if (playerClass = Cleric) then
    begin
      writeln('You channel divine energy, creating blessed light');
      writeln('that burns away his dark protections!');
      hasFlame := true;
    end
    else if (playerClass = Warlock) then
    begin
      writeln('You unleash eldritch blasts and dark magic,');
      writeln('fighting fire with fire against his corruption.');
      hasFlame := true;
    end
    else if (playerClass = Ranger) then
    begin
      writeln('Your arrows find their mark with supernatural accuracy,');
      writeln('each shot guided by your connection to nature.');
      hasFlame := true;
    end
    else
    begin
      writeln('You lack the magical training for this approach.');
      writeln('Your attacks have little effect on his enchanted armor.');
      hasFlame := false;
    end;
  end
  else
  begin
    writeln('Hesitation in battle proves costly.');
    writeln('Malrek''s dark magic overwhelms you.');
    hasFlame := false;
  end;
end;

{*****************************************************************
 * The climactic moment of retrieving the Flame
 *****************************************************************}
procedure FlameRecovery;
begin
  if hasFlame then
  begin
    writeln();
    writeln('In a final surge of courage, you rip the Flame free from');
    writeln('Malrek''s chestplate! The crystal bursts with radiant power,');
    writeln('flooding the ruins with blinding light.');
    writeln();
    writeln('Malrek screams as the darkness consumes him, his body');
    writeln('collapsing into dust. The Flame of Elarion pulses warmly');
    writeln('in your hands, recognizing you as its true guardian.');
    writeln();
  end
  else
  begin
    writeln();
    writeln('Defeated and broken, you crawl away from the ruins.');
    writeln('The Flame remains in Malrek''s possession, and Briar''s');
    writeln('Hollow faces certain doom...');
    writeln();
  end;
end;

{*****************************************************************
 * The resolution - victory or defeat endings
 *****************************************************************}
procedure GameEnding;
begin
  if hasFlame then
  begin
    writeln('--- DAWN OF HOPE ---');
    writeln();
    writeln('At dawn, you return to Briar''s Hollow. The Flame of Elarion');
    writeln('glows brilliantly in your hands. As the Ashen Vanguard approaches');
    writeln('the village, the light flares across the fields.');
    writeln();
    writeln('Their courage breaks. One by one, the mercenaries turn and flee,');
    writeln('leaving the village untouched. The people cheer your name!');
    writeln();
    writeln('For them, you are no longer a stranger - you are their savior.');
    writeln();
    writeln('And so the bards will sing:');
    writeln('"' + playerName + ', Hero of Briar''s Hollow, who restored the');
    writeln('Flame of Elarion and lit hope in the age of darkness."');
    writeln();
    writeln('*** VICTORY! You have saved Briar''s Hollow! ***');
  end
  else
  begin
    writeln('--- THE DARK ENDING ---');
    writeln();
    writeln('You return to Briar''s Hollow empty-handed. The Ashen Vanguard');
    writeln('arrives at dawn, and without the Flame''s protection, the village');
    writeln('falls. The people remember your courage, but it was not enough.');
    writeln();
    writeln('Perhaps another hero will succeed where you failed...');
    writeln();
    writeln('*** DEFEAT - The darkness spreads... ***');
  end;
end;

{*****************************************************************
 * Main program execution
 *****************************************************************}
begin
  clrscr;
  hasFlame := false;
  
  ShowIntroduction;
  SelectCharacterClass;
  BriarsHollowScene;
  PreparationPhase;
  CrystalSpireScene;
  ResolveCombat;
  FlameRecovery;
  GameEnding;
  
  writeln();
  writeln('Thanks for playing The Flame of Briar''s Hollow!');
  writeln('Press Enter to exit...');
  readln;
end.
