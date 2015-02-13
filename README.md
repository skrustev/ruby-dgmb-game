Don't Get Mad Bro
==============

A game about ᕙ༼ຈلຈ༽ᕗ HARDER BETTER FASTER DONGER ᕙ༼ຈلຈ༽ᕗ

[Screenshot_1](http://gyazo.com/fb5a8dcd729bb2bf2416ac0c30c4b448.png) [Screnshot_2](http://gyazo.com/4034bcfa4820786f02eb812381d11554.png)

## How To Play(only Windows)
1. Clone or download this repo in a desired folder

2. Run Don'tGetMadBro.exe

## How to Install for Unix/Linux/Win
1. Download and install latest ruby.
 * Installer For Windows: http://rubyinstaller.org/ (Tick Add Ruby executables to your PATH)
 * For Unix/Linux install [rbenv](https://github.com/sstephenson/rbenv#installation)
  
2. Clone this repo in a desired folder

3. Open your console
4. Execute

	```
	gem install bundler
	```
**Note:** If you are having problem with SSL and it says that there's a problem connecting to the gem site see here for updating the gem version - [link](https://gist.github.com/luislavena/f064211759ee0f806c88)
5. Navigate using command 'cd' to your cloned repo main folder.

6. Run the following command to install the dependencies:
	```
	bundle
	```
7. To start the game use:

	```
	ruby game_window.rb
	```

## Rules:
**Goals of the game:**
* Everyone competes against each other to get all their 4 pawns to the finish. Each player's finish is colored in.
* There are maximum 4 player.

**Turns:**
* Players turns rotate counter clockwise starting from the blue player
* Each players during their turn can roll(like a dice but a random number will be chosen).
* If player roll 6 he can roll again after he has made his move.

**Moving the pawns:**

* Every player has 4 pawns in their color.
* At start all have their pawns at their 'home' positions.
* When in their home position the pawns cannot be selected and moved.
* To place a pawn on the board a player need to roll 6 first.
* Once on a board a pawn that has been selected moves as many positions as the player has rolled during their turn.
* If a pawn steps on an enemy pawn, the enemy pawn gets reset at it's 'home' position and needs to be placed on the board again to be movable.
* Once a pawn has made a full lap it gets in the colored area for that pawn.
* To get a pawn into the finish area you need to roll exactly the number needed to step on into it.


##Used gems:

* [RSpec](https://github.com/rspec/rspec)
* [Guard](https://github.com/guard/guard)
* [Gosu](http://www.libgosu.org/)
* [Ocra](https://github.com/larsch/ocra/)
