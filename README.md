# Hunt The Wampus - Part 1 (The Model)
## Montreal.rb Nov 2024 Hack Night

Montreal.rb Nov 2024 Hack Night: Hunt The Wampus - Part 1 (The Model)

![Hunt The Wampus](/hunt-the-wumpus.png)

## Meetup:

https://www.meetup.com/montrealrb/events/303804858/

## Event:

Bring your laptop to this Montreal.rb Hack Night where everyone participates in building Hunt The Wampus in Ruby as per the game description at this webpage (Hack Night requirements will diverge):
https://www.javatpoint.com/the-wumpus-world-in-artificial-intelligence

In part 1, attendees will implement the engine of Hunt The Wampus as the Model layer of the game. They will be provided with game requirements in the form of integration tests, which they must pass to complete the implementation of the Model layer. Attendees may optionally write additional unit tests if they find that helpful in the development process.

The expected end result of Hack Night part 1 is to become ready for part 2 at the next meetup (Dec 4, 2024), which will focus on adding a View layer on top of the Model layer completed in this event, by utilizing any Ruby View approach, such as CLI, TUI, GUI, Web UI Backend, or Web UI Frontend (there will be no View related work in this event though).

It is encouraged that attendees collaborate when needed, ask each other questions, and help each other.

The goal of this Hack Night is to practice Ruby Software Engineering skills in a low-pressure fun environment while building a non-serious game.

## Game Rules:

![Hunt The Wampus](/hunt-the-wumpus.png)

The game "Hunt The Wampus" will be played on a 4x4 board, meaning a board with 4 rows, 4 columns, and 16 cells.

Cell locations are represented by 0-indexed [row, column] pairs starting from the top-left corner [0, 0] and ending in the bottom-right corner [3, 3].

```ruby
  0 1 2 3
0
1
2
3
```

Every game board is generated initially with the following objects in different cells (these objects cannot share the same cell in the initial state of the game):
- Agent: a player who:
  - Can move horizontally (right/left) and vertically (up/down)
  - Must avoid the Wampus and Pit
  - Can shoot an arrow horizontally (right/left) and vertically (up/down) to hit the Wampus from afar and score 100 (has 1 arrow only, which is gone if the Wampus is missed)
  - Can find the Gold and grab it to score 1000
  - Must reach the Exit to win the game.
- Wampus: a monster with a bad Stench that is sensed on every neighboring cell horizontally and vertically. The Wampus kills the Agent instantly if the Agent happens to move into the Wampus cell by mistake.
- Pit: a very deep pit with a Breeze that is sensed on every neighboring cell horizontally and vertically   that causes instant death to the Agent if he moves into its cell by mitake
- Gold: a bar of gold that can be picked up by the Agent for a score of 1000.
- Exit: the place at which the Agent will exit the game to win it alive.

These senses can occupy cells too, potentially shared with other objects from the ones mentioned above:
- Stench: the Stench of the Wampus will occupy every Wampus neighboring cell horizontally and vertically. If the Wampus was on [1, 1], there would be Stench on [0, 1], [1, 0], [2, 1], and [1, 2].
- Breeze: the Breeze of the Pit will occupy every Pit neighboring cell horizontally and vertically. If the Pit was on [3, 3], there would be Breeze on [3, 2] and [2, 3].

It is possible for a cell to have one or multiple senses in addition to an object at the beginning of the game.

After the game progresses, it is possible for a cell to contain multiple objects, like Gold, Stench, and the Agent (while the Agent is alive); or the Agent and the Wampus (if the Agent dies).

The Agent can shoot 1 arrow horizontally or vertically. The arrow moves across all subsequent cells in the direction the arrow was shot at. If the Wampus is at any of those subsequent cells, it is killed for a score of 100.

To keep the Hack Night simple, the expected initial implementation will always generate the same game board with the following exact content:

```ruby
[
  [[:stench], [], [], [:exit]],
  [[:wampus], [:gold, :stench], [], []],
  [[:stench], [], [:breeze], []],
  [[:agent], [:breeze], [:pit], [:breeze]],
]
```

## Game Scoring:

Game score starts at 0.

The Agent loses 1 point with every action taken (with the score potentially becoming negative), such as:
- Move up/right/down/left
- Shoot arrow up/right/down/left
- Grab gold

The Agent scores 100 points if he hits the Wampus with an arrow.

The Agent scores 1000 points if he grabs the gold.

## Game States:

Game states are:
- Playing: the Agent is still alive and has not reached the Exit yet.
- Won: the Agent is alive and has reached the Exit.
- Lost: the Agent died by meeting the Wampus or falling into the Pit.

## Game Requirements:

Game requirements are codified in integration tests in the file:

[test/hunt_the_wampus/model/game_test.rb](/test/hunt_the_wampus/model/game_test.rb)

Hack Night participants must implement `HuntTheWampus::Model::Game` Model to pass all the tests in the file mentioned above.

The game board data structure will be an Array of Arrays of Arrays of Symbols whereby:
- 1st level Array contains 2nd level row Arrays
- Every 2nd level row Array contains 3rd level cell Arrays
- Every 3rd level cell Array contains object Symbols

Example:

```ruby
[
  [[:stench], [], [], [:exit]],
  [[:wampus], [:gold, :stench], [], []],
  [[:stench], [], [:breeze], []],
  [[:agent], [:breeze], [:pit], [:breeze]],
]
```

Optionally, participants could implement extra objects following Object Oriented Programming or write additional Unit Tests if they find that helpful in the development process.

## Game Bonus Requirements:

Optionally, if participants finish the implementation required above early in the Hack Night, then they can replace the static implementation of the game board with a dynamic random implementation that generates a different game board on every start of the game.

## Copyright

Copyright (c) 2024 Andy Maleh.

[MIT](/LICENSE.txt)

See [LICENSE.txt](/LICENSE.txt) for further details.
