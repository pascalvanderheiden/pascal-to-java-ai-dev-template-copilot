program TextAdventureGame;

uses crt;

var
  choice: string;

begin
  clrscr;
  writeln('Welcome to the Adventure Game!');
  writeln('You find yourself in a dark forest. There are two paths ahead.');
  writeln('Do you want to go left or right? (type "left" or "right")');
  readln(choice);

  if choice = 'left' then
  begin
    writeln('You walk down the left path and encounter a friendly elf.');
    writeln('The elf gives you a magical sword. You win!');
  end
  else if choice = 'right' then
  begin
    writeln('You walk down the right path and fall into a pit of spikes.');
    writeln('Game Over.');
  end
  else
  begin
    writeln('Invalid choice. You stand still and a wild bear finds you.');
    writeln('Game Over.');
  end;

  writeln('Thanks for playing!');
  readln;
end.
