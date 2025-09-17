program TheHeistOfThermmirekeep_Full;
{ Turbo Pascal / Free Pascal compatible text adventure with save/load, expanded combat, and minigames }
uses crt, sysutils, classes;

const
  MAX_ITEMS = 60;
  MAX_ROOMS = 40;
  SAVE_FILE = 'heist_save.txt';

type
  TItem = record
    id: integer;
    name: string[40];
    desc: string[200];
    takeable: boolean;
  end;

  TRoom = record
    id: integer;
    name: string[40];
    desc: string[255];
    exits: array[1..6] of integer; { N,E,S,W,U,D -> room id or 0 }
    items: array[1..MAX_ITEMS] of integer; { item ids or 0 }
  end;

  TPlayer = record
    location: integer;
    hp: integer;
    maxhp: integer;
    ac: integer;
    gold: integer;
    inventory: array[1..15] of integer;
    invCount: integer;
    hasKey: boolean;
    reputation: integer;
    level: integer;
    xp: integer;
    potions: integer;
  end;

var
  rooms: array[1..MAX_ROOMS] of TRoom;
  items: array[1..MAX_ITEMS] of TItem;
  player: TPlayer;
  gameRunning: boolean;

{ ---------------- Utility ---------------- }
procedure Pause; begin writeln; writeln('Press ENTER to continue...'); readln; end;

function StrToLower(s: string): string;
var i: integer;
begin
  for i := 1 to length(s) do s[i] := LowerCase(s[i]);
  StrToLower := s;
end;

function TrimLower(s: string): string;
begin
  TrimLower := StrToLower(Trim(s));
end;

procedure WriteLnCentered(msg: string);
var pad: integer;
begin
  pad := (80 - length(msg)) div 2;
  if pad < 0 then pad := 0;
  writeln(StringOfChar(' ', pad) + msg);
end;

{ ---------------- Item & Room helpers ---------------- }
function FindItemByName(name: string): integer;
var i: integer; lname: string;
begin
  name := TrimLower(name);
  FindItemByName := 0;
  for i := 1 to MAX_ITEMS do
    if (items[i].id <> 0) then begin
      lname := TrimLower(items[i].name);
      if lname = name then begin FindItemByName := items[i].id; exit; end;
    end;
end;

procedure AddToInventory(pid: integer);
var i: integer;
begin
  if player.invCount >= 15 then begin
    writeln('Your inventory is full.'); exit;
  end;
  inc(player.invCount);
  player.inventory[player.invCount] := pid;
  writeln('You put the ', items[pid].name, ' in your pack.');
end;

function InInventory(pid: integer): boolean;
var i: integer;
begin
  InInventory := false;
  for i := 1 to player.invCount do if player.inventory[i] = pid then InInventory := true;
end;

procedure RemoveFromRoom(rid, pid: integer);
var i: integer;
begin
  for i := 1 to MAX_ITEMS do
    if rooms[rid].items[i] = pid then rooms[rid].items[i] := 0;
end;

procedure PlaceItemInRoom(rid, pid: integer);
var i: integer;
begin
  for i := 1 to MAX_ITEMS do
    if rooms[rid].items[i] = 0 then begin rooms[rid].items[i] := pid; exit; end;
end;

{ ---------------- Initialization ---------------- }
procedure InitItems;
begin
  FillChar(items, SizeOf(items), 0);
  items[1].id := 1; items[1].name := 'yule dagger'; items[1].desc := 'A cold dagger with frosty edge.'; items[1].takeable := true;
  items[2].id := 2; items[2].name := 'winter axe'; items[2].desc := 'A heavy greataxe inscribed with runes.'; items[2].takeable := true;
  items[3].id := 3; items[3].name := 'vault key'; items[3].desc := 'A heavy iron key stamped with Thermmire insignia.'; items[3].takeable := true;
  items[4].id := 4; items[4].name := 'poisoned crate'; items[4].desc := 'A crate of bad vegetables (quest item).'; items[4].takeable := false;
  items[5].id := 5; items[5].name := 'gold sack'; items[5].desc := 'A sack of gold coins.'; items[5].takeable := true;
  items[6].id := 6; items[6].name := 'note from hoffman'; items[6].desc := 'A folded note: "Meet me at dusk."'; items[6].takeable := true;
  items[7].id := 7; items[7].name := 'winter shard'; items[7].desc := 'A small glimmering shard.'; items[7].takeable := true;
  items[8].id := 8; items[8].name := 'armwrestle token'; items[8].desc := 'A token for the Frostival games.'; items[8].takeable := true;
  items[9].id := 9; items[9].name := 'unicorn plush'; items[9].desc := 'A prize from the ball toss.'; items[9].takeable := true;
  items[10].id := 10; items[10].name := 'talking stone'; items[10].desc := 'A magical stone that hums.'; items[10].takeable := true;
  items[11].id := 11; items[11].name := 'dragon toy'; items[11].desc := 'A flying dragon toy prize.'; items[11].takeable := true;
  items[12].id := 12; items[12].name := 'small potion'; items[12].desc := 'Restores 15 HP.'; items[12].takeable := true;
  items[13].id := 13; items[13].name := 'scroll of stealth'; items[13].desc := 'One-use scroll that aids stealth.'; items[13].takeable := true;
  items[14].id := 14; items[14].name := 'map fragment'; items[14].desc := 'A fragment showing Thermmire vault layout.'; items[14].takeable := true;
end;

procedure InitRooms;
var i,j: integer;
begin
  for i := 1 to MAX_ROOMS do begin
    rooms[i].id := 0;
    for j := 1 to 6 do rooms[i].exits[j] := 0;
    for j := 1 to MAX_ITEMS do rooms[i].items[j] := 0;
  end;

  rooms[1].id := 1; rooms[1].name := 'Orathal Square';
  rooms[1].desc := 'The village square. Stalls, the festival grounds and town hall are here.';
  rooms[1].exits[2] := 2; { E -> Tavern }
  PlaceItemInRoom(1,6);

  rooms[2].id := 2; rooms[2].name := 'The Frozen Booz Tavern';
  rooms[2].desc := 'Warm hearth, loud locals. You can ask about the Frostival.';
  rooms[2].exits[4] := 1;
  rooms[2].exits[2] := 3;

  rooms[3].id := 3; rooms[3].name := 'Smith';
  rooms[3].desc := 'The blacksmith hammers steel.';
  rooms[3].exits[4] := 2;

  rooms[4].id := 4; rooms[4].name := 'Wine Shop';
  rooms[4].desc := 'Beneotti sells fine wines; crates are in the cellar.';
  rooms[4].exits[1] := 5; rooms[4].exits[4] := 1;
  PlaceItemInRoom(4,4);

  rooms[5].id := 5; rooms[5].name := 'Festival Tent';
  rooms[5].desc := 'Frostival games happen here. Guards are elsewhere tonight.';
  rooms[5].exits[3] := 4;

  rooms[10].id := 10; rooms[10].name := 'Hundi Pass';
  rooms[10].desc := 'A narrow mountain pass; a broken bridge spans a chasm.';
  rooms[10].exits[4] := 1;
  PlaceItemInRoom(10,1);

  rooms[20].id := 20; rooms[20].name := 'ThermmireKeep Gate';
  rooms[20].desc := 'An old stone gate; the door looking eerily open.';
  rooms[20].exits[3] := 21; rooms[20].exits[4] := 1;

  rooms[21].id := 21; rooms[21].name := 'Main Hall - ThermmireKeep';
  rooms[21].desc := 'Marble floor, guards play dragon chess. Vault is nearby.';
  rooms[21].exits[1] := 20; rooms[21].exits[3] := 22;
  PlaceItemInRoom(21,14); { map fragment near vault }

  rooms[22].id := 22; rooms[22].name := 'Guard Room';
  rooms[22].desc := 'Beds, bookcases and a sleepy guard.';
  rooms[22].exits[1] := 21;

  rooms[23].id := 23; rooms[23].name := 'Library';
  rooms[23].desc := 'Shelves of old tomes. General Binks studies here.';
  rooms[23].exits[1] := 21;
  PlaceItemInRoom(23,2);

  rooms[30].id := 30; rooms[30].name := 'Sewers';
  rooms[30].desc := 'Dark, damp tunnels. Smells awful.';
  rooms[30].exits[1] := 1;
  PlaceItemInRoom(30,7);
end;

procedure InitPlayer;
var i: integer;
begin
  player.location := 1;
  player.hp := 40;
  player.maxhp := 40;
  player.ac := 12;
  player.gold := 0;
  player.invCount := 0;
  player.hasKey := false;
  player.reputation := 0;
  player.level := 1;
  player.xp := 0;
  player.potions := 1;
  for i := 1 to 15 do player.inventory[i] := 0;
end;

{ ---------------- Display ---------------- }
procedure DescribeCurrentRoom;
var i: integer; any: boolean; exits: string;
begin
  writeln;
  writeln('--- ', rooms[player.location].name, ' ---');
  writeln(rooms[player.location].desc);
  any := false;
  for i := 1 to MAX_ITEMS do
    if rooms[player.location].items[i] <> 0 then begin
      if not any then begin writeln('Items here:'); any := true; end;
      writeln(' - ', items[rooms[player.location].items[i]].name);
    end;
  exits := '';
  if rooms[player.location].exits[1]<>0 then exits := exits + 'N ';
  if rooms[player.location].exits[2]<>0 then exits := exits + 'E ';
  if rooms[player.location].exits[3]<>0 then exits := exits + 'S ';
  if rooms[player.location].exits[4]<>0 then exits := exits + 'W ';
  writeln('Exits: (', Trim(exits), ')');
end;

procedure ShowHelp;
begin
  writeln('Available commands: look, go <n/s/e/w>, take <item>, inventory, talk, stats, use <item>, heist, playminigame, steal key, save, load, quit, help');
end;

procedure ShowInventory;
var i: integer;
begin
  writeln;
  writeln('Inventory (', player.invCount, '/15):');
  if player.invCount = 0 then writeln(' - empty');
  for i := 1 to player.invCount do writeln(' - ', items[player.inventory[i]].name);
  writeln('Potions: ', player.potions);
end;

procedure ShowStats;
begin
  writeln;
  writeln('HP: ', player.hp, '/', player.maxhp, '  AC: ', player.ac, '  Gold: ', player.gold, '  Reputation: ', player.reputation);
  writeln('Level: ', player.level, '  XP: ', player.xp);
end;

procedure MovePlayer(dir: string);
var target: integer;
begin
  dir := TrimLower(dir);
  if (dir='n') then target := rooms[player.location].exits[1]
  else if (dir='e') then target := rooms[player.location].exits[2]
  else if (dir='s') then target := rooms[player.location].exits[3]
  else if (dir='w') then target := rooms[player.location].exits[4]
  else target := 0;

  if target = 0 then writeln('You cannot go that way.') else begin
    player.location := target;
    DescribeCurrentRoom;
  end;
end;

{ ---------------- Commands ---------------- }
procedure CommandTake(arg: string);
var pid: integer; i: integer; aname: string;
begin
  aname := TrimLower(arg);
  if aname = '' then begin writeln('Take what?'); exit; end;
  pid := 0;
  for i := 1 to MAX_ITEMS do
    if rooms[player.location].items[i] <> 0 then
      if TrimLower(items[rooms[player.location].items[i]].name) = aname then pid := rooms[player.location].items[i];

  if pid = 0 then begin writeln('No such item here.'); exit; end;
  if not items[pid].takeable then begin writeln('You cannot take that.'); exit; end;
  RemoveFromRoom(player.location, pid);
  AddToInventory(pid);
end;

procedure CommandUse(arg: string);
var pid: integer;
begin
  pid := FindItemByName(arg);
  if pid = 0 then begin writeln('You do not have that item.'); exit; end;
  if not InInventory(pid) then begin writeln('It is not in your inventory.'); exit; end;

  if pid = 3 then begin { vault key }
    if player.location = 21 then begin
      writeln('You use the vault key on the vault. The lock clicks open!');
      writeln('You found sacks of gold and artifacts!');
      player.gold := player.gold + 450;
      player.hasKey := true;
      writeln('You hide the key away.');
    end else writeln('There is no vault here.');
  end else if pid = 12 then begin { small potion }
    writeln('You drink the potion. Restores 15 HP.');
    player.hp := player.hp + 15;
    if player.hp > player.maxhp then player.hp := player.maxhp;
    { remove potion from inventory }
    { find and delete one potion item slot }
    { for simplicity, potions are counted separately in player.potions }
    player.potions := player.potions - 1;
    if player.potions < 0 then player.potions := 0;
  end else if pid = 6 then begin { note from hoffman }
    writeln('The note: "Meet Mr. Hoffman at dusk near the statue. Bring a plan."');
    player.reputation := player.reputation + 1;
  end else writeln('Nothing happens when you use that.');
end;

procedure CommandTalk;
begin
  if player.location = 2 then begin
    writeln('Tavern patron: "Heard Mr. Hoffman is recruiting for a heist at Thermmirekeep."');
    player.reputation := player.reputation + 1;
  end else if player.location = 4 then begin
    writeln('Beneotti: "We expect many visitors at the Frostival; guards will be thin in the keep."');
    player.reputation := player.reputation + 1;
  end else if player.location = 23 then begin
    writeln('You find General Binks studying. He carries a heavy key on the table.');
    writeln('You may try to pickpocket (use "steal key") or fight him later.');
  end else writeln('No one to talk to here.');
end;

{ ---------------- Combat ---------------- }
type TEnemy = record
  name: string[30];
  hp: integer;
  ac: integer;
  damageMin: integer;
  damageMax: integer;
  xpReward: integer;
end;

function RandInt(a,b: integer): integer;
begin
  RandInt := a + Random(b - a + 1);
end;

procedure ShowEnemy(e: TEnemy);
begin
  writeln('Enemy: ', e.name, '  HP: ', e.hp, '  AC: ', e.ac);
end;

function AttackRoll(attackerBonus: integer): integer;
begin
  AttackRoll := RandInt(1,20) + attackerBonus;
end;

procedure PlayerAttack(var e: TEnemy);
var roll, dmg: integer;
begin
  roll := AttackRoll(2 + player.level div 2);
  writeln('You attack! Attack roll: ', roll);
  if roll >= e.ac then begin
    dmg := RandInt(2 + player.level, 6 + player.level);
    writeln('Hit! You deal ', dmg, ' damage.');
    e.hp := e.hp - dmg;
  end else writeln('Missed!');
end;

procedure EnemyAttack(var e: TEnemy);
var roll, dmg: integer;
begin
  roll := RandInt(1,20);
  writeln(e.name, ' attacks! Attack roll: ', roll);
  if roll >= player.ac then begin
    dmg := RandInt(e.damageMin, e.damageMax);
    writeln('You are hit for ', dmg, ' damage.');
    player.hp := player.hp - dmg;
  end else writeln('Enemy missed!');
end;

procedure GrantXP(amount: integer);
begin
  player.xp := player.xp + amount;
  writeln('You gained ', amount, ' XP.');
  if player.xp >= player.level * 50 then begin
    player.xp := player.xp - player.level * 50;
    inc(player.level);
    inc(player.maxhp,5);
    player.hp := player.maxhp;
    writeln('You leveled up to level ', player.level, '! HP increased.');
  end;
end;

procedure CombatEncounter(var e: TEnemy);
var userInput: string;
begin
  writeln;
  writeln('--- Combat Encounter: ', e.name, ' ---');
  ShowEnemy(e);
  while (e.hp > 0) and (player.hp > 0) do begin
    writeln;
    writeln('Your HP: ', player.hp, '/', player.maxhp);
    writeln('Choose action: attack, use potion, flee');
    write('> '); readln(userInput);
    userInput := TrimLower(userInput);
    if userInput = 'attack' then begin PlayerAttack(e); end
    else if userInput = 'use potion' then begin
      if player.potions > 0 then begin
        writeln('You drink a potion, heal 20 HP.'); player.hp := player.hp + 20; if player.hp > player.maxhp then player.hp := player.maxhp; dec(player.potions);
      end else writeln('No potions left.');
    end else if userInput = 'flee' then begin
      if RandInt(1,100) < 60 then begin writeln('You flee successfully.'); exit; end else writeln('Failed to flee.');
    end else writeln('Unknown action.');
    if e.hp > 0 then EnemyAttack(e);
  end;
  if player.hp <= 0 then begin writeln('You have died.'); gameRunning := false; exit; end;
  if e.hp <= 0 then begin writeln('You defeated ', e.name, '!'); GrantXP(e.xpReward); end;
end;

procedure FightGuards;
var guard: TEnemy; i: integer;
begin
  guard.name := 'Guard';
  guard.hp := 18;
  guard.ac := 14;
  guard.damageMin := 3;
  guard.damageMax := 6;
  guard.xpReward := 20;
  CombatEncounter(guard);
end;

procedure FightGeneralBinks;
var binks: TEnemy;
begin
  binks.name := 'General Binks';
  binks.hp := 45;
  binks.ac := 14;
  binks.damageMin := 4;
  binks.damageMax := 8;
  binks.xpReward := 120;
  CombatEncounter(binks);
end;

{ ---------------- Heist ---------------- }
procedure HeistSequence;
var choice: string;
begin
  writeln;
  writeln('--- Heist: Thermmirekeep ---');
  if player.reputation < 1 then writeln('You feel unprepared. You might have missed gathering intel.');
  writeln('Approach the gate? (yes/no)');
  readln(choice);
  if TrimLower(choice) = 'no' then begin writeln('You back off. Heist aborted.'); exit; end;

  if InInventory(3) or player.hasKey then begin
    writeln('You slip into the keep and use the key to open the vault.');
    writeln('You escape with the loot!');
    player.gold := player.gold + 600;
    writeln('Heist succeeded. Gold: ', player.gold);
    writeln('Ending: Successful Heist!');
    gameRunning := false;
    exit;
  end;

  writeln('You try to sneak in but lack the key. Guards notice you!');
  writeln('Fight or flee? (fight/flee)');
  readln(choice);
  if TrimLower(choice) = 'flee' then begin writeln('You flee to Orathal, wounded. Heist failed.'); player.hp := player.hp - 5; exit; end;

  writeln('You fight through guards...');
  FightGuards;
  if not gameRunning then exit;
  writeln('You confront General Binks.');
  FightGeneralBinks;
  if not gameRunning then exit;
  if player.hp > 0 then begin
    writeln('You defeated General Binks and take his key!');
    AddToInventory(3);
    writeln('You open the vault and take the gold.');
    player.gold := player.gold + 450;
    writeln('Heist succeeded but you are wounded. HP -10.');
    player.hp := player.hp - 10;
    gameRunning := false;
  end else begin
    writeln('Binks proved too strong. You are captured.');
    gameRunning := false;
  end;
end;

{ ---------------- Minigames ---------------- }
function MiniBallToss: boolean;
var target, roll: integer;
begin
  writeln('--- Ball Toss ---');
  writeln('Aim for the unicorn plush. Type a number 1-20 to throw (higher better).');
  write('Your throw (1-20): '); readln(roll);
  if (roll < 1) or (roll > 20) then roll := RandInt(1,20);
  target := RandInt(8,17);
  writeln('Target difficulty: ', target);
  if roll >= target then begin writeln('Nice throw! You win a unicorn plush.'); AddToInventory(9); MiniBallToss := true; end
  else begin writeln('Missed. Better luck next time.'); MiniBallToss := false; end;
end;

function MiniArchery: boolean;
var aim, difficulty: integer;
begin
  writeln('--- Archery Target ---');
  writeln('Choose aim 1-20: higher = better precision.');
  write('Aim (1-20): '); readln(aim);
  if (aim < 1) or (aim > 20) then aim := RandInt(1,20);
  difficulty := RandInt(7,17);
  writeln('Target value: ', difficulty);
  if aim >= difficulty then begin writeln('Bullseye! You win a talking stone.'); AddToInventory(10); MiniArchery := true; end
  else begin writeln('You missed the bullseye.'); MiniArchery := false; end;
end;

function MiniArmWrestle: boolean;
var strengthRoll: integer;
begin
  writeln('--- Arm Wrestling ---');
  writeln('Roll a strength check (1-20).');
  write('Roll (1-20): '); readln(strengthRoll);
  if (strengthRoll < 1) or (strengthRoll > 20) then strengthRoll := RandInt(1,20);
  if strengthRoll + player.level >= 15 then begin writeln('You won the match! Prize: dragon toy.'); AddToInventory(11); MiniArmWrestle := true; end
  else begin writeln('You lost the match.'); MiniArmWrestle := false; end;
end;

procedure PlayMinigame;
var choice: string;
begin
  writeln;
  writeln('Minigames available: balltoss, archery, armwrestle');
  write('Which minigame? '); readln(choice);
  choice := TrimLower(choice);
  if choice = 'balltoss' then MiniBallToss
  else if choice = 'archery' then MiniArchery
  else if choice = 'armwrestle' then MiniArmWrestle
  else writeln('Unknown minigame.');
end;

{ ---------------- Save / Load ---------------- }
procedure SaveGame;
var f: TextFile; i, j: integer; s: string;
begin
  Assign(f, SAVE_FILE);
  Rewrite(f);
  Writeln(f, 'LOCATION=', player.location);
  Writeln(f, 'HP=', player.hp);
  Writeln(f, 'MAXHP=', player.maxhp);
  Writeln(f, 'AC=', player.ac);
  Writeln(f, 'GOLD=', player.gold);
  Writeln(f, 'REPUTATION=', player.reputation);
  Writeln(f, 'LEVEL=', player.level);
  Writeln(f, 'XP=', player.xp);
  Writeln(f, 'POTIONS=', player.potions);
  Writeln(f, 'HASKEY=', Ord(player.hasKey));
  Writeln(f, 'INVCOUNT=', player.invCount);
  for i := 1 to player.invCount do Writeln(f, 'INV'+IntToStr(i)+'='+IntToStr(player.inventory[i]));
  { Save room items (simple): for rooms 1..MAX_ROOMS write list of item ids present }
  for i := 1 to MAX_ROOMS do begin
    Writeln(f, 'ROOM'+IntToStr(i)+'ITEMS=');
    { list items separated by commas }
    s:='';
    for j := 1 to MAX_ITEMS do
      if rooms[i].items[j] <> 0 then begin
        if s <> '' then s := s + ',';
        s := s + IntToStr(rooms[i].items[j]);
      end;
    Writeln(f, s);
  end;
  Close(f);
  writeln('Game saved to ', SAVE_FILE);
end;

procedure LoadGame;
var f: TextFile; line: string; key, val: string; i: integer;
    invIndex, idx, j, pid: integer; numstr: string; parts: TStringList;
begin
  if not FileExists(SAVE_FILE) then begin writeln('No save file found.'); exit; end;
  Assign(f, SAVE_FILE);
  Reset(f);
  while not Eof(f) do begin
    Readln(f, line);
    if line = '' then continue;
    i := Pos('=', line);
    if i = 0 then continue;
    key := Copy(line,1,i-1);
    val := Copy(line,i+1,255);
    if key = 'LOCATION' then player.location := StrToIntDef(val, player.location)
    else if key = 'HP' then player.hp := StrToIntDef(val, player.hp)
    else if key = 'MAXHP' then player.maxhp := StrToIntDef(val, player.maxhp)
    else if key = 'AC' then player.ac := StrToIntDef(val, player.ac)
    else if key = 'GOLD' then player.gold := StrToIntDef(val, player.gold)
    else if key = 'REPUTATION' then player.reputation := StrToIntDef(val, player.reputation)
    else if key = 'LEVEL' then player.level := StrToIntDef(val, player.level)
    else if key = 'XP' then player.xp := StrToIntDef(val, player.xp)
    else if key = 'POTIONS' then player.potions := StrToIntDef(val, player.potions)
    else if key = 'HASKEY' then player.hasKey := (StrToIntDef(val,0) = 1)
    else if key = 'INVCOUNT' then player.invCount := StrToIntDef(val,0)
    else if Copy(key,1,3)='INV' then begin
      invIndex := StrToIntDef(Copy(key,4,10),0);
      if (invIndex>=1) and (invIndex<=15) then player.inventory[invIndex] := StrToIntDef(val,0);
    end
    else if Copy(key,1,4)='ROOM' then begin
      { ROOMxITEMS=csv }
      idx := StrToIntDef(Copy(key,5,3),0); { room index }
      if idx>=1 then begin
        { clear room items first }
        for j := 1 to MAX_ITEMS do rooms[idx].items[j] := 0;
        if val <> '' then begin
          parts := TStringList.Create;
          parts.CommaText := val;
          for j := 0 to parts.Count-1 do begin
            pid := StrToIntDef(parts[j],0);
            if pid<>0 then PlaceItemInRoom(idx,pid);
          end;
          parts.Free;
        end;
      end;
    end;
  end;
  Close(f);
  writeln('Game loaded from ', SAVE_FILE);
  DescribeCurrentRoom;
end;

{ ---------------- Main Loop ---------------- }
procedure MainLoop;
var input, cmd, arg: string; i: integer;
begin
  gameRunning := true;
  DescribeCurrentRoom;
  ShowHelp;
  while gameRunning do begin
    write('> '); readln(input);
    input := Trim(input);
    if input = '' then continue;
    i := Pos(' ', input);
    if i > 0 then begin cmd := Copy(input,1,i-1); arg := Copy(input,i+1,255); end
    else begin cmd := input; arg := ''; end;
    cmd := TrimLower(cmd);
    if (cmd = 'help') then ShowHelp
    else if (cmd = 'look') then DescribeCurrentRoom
    else if (cmd = 'go') then begin if arg = '' then writeln('Go where? (n/e/s/w)') else MovePlayer(arg); end
    else if (cmd = 'take') then CommandTake(arg)
    else if (cmd = 'inventory') then ShowInventory
    else if (cmd = 'stats') then ShowStats
    else if (cmd = 'talk') then CommandTalk
    else if (cmd = 'use') then CommandUse(arg)
    else if (cmd = 'steal') then begin if TrimLower(arg) = 'key' then begin CommandTalk; writeln('Attempting to steal key...'); if RandInt(1,100) < 40 then begin AddToInventory(3); writeln('Stole the key!'); end else begin writeln('Failed.'); player.hp := player.hp - 8; end; end else writeln('Steal what?'); end
    else if (cmd = 'heist') then HeistSequence
    else if (cmd = 'playminigame') then PlayMinigame
    else if (cmd = 'save') then SaveGame
    else if (cmd = 'load') then LoadGame
    else if (cmd = 'quit') then begin writeln('Quit? (yes/no)'); readln(input); if TrimLower(input)='yes' then gameRunning := false; end
    else writeln('Unknown command. Type help for commands.');
    if player.hp <= 0 then begin writeln('You have died. Game over.'); gameRunning := false; end;
  end;
  writeln('Thank you for playing The Heist of Thermmirekeep.');
end;

{ ---------------- Program start ---------------- }
begin
  randomize;
  clrscr;
  writeln('=== The Heist of Thermmirekeep - Expanded Version ===');
  writeln('Includes save/load, expanded combat and minigames.');
  writeln('Type "help" for commands.');
  InitItems;
  InitRooms;
  InitPlayer;
  MainLoop;
end.
