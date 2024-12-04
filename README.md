# Hunt The Wampus - Part 2 (The View)
## Montreal.rb Dec 2024 Hack Night

Montreal.rb Dec 2024 Hack Night: Hunt The Wampus - Part 2 (The View)

![Hunt The Wampus](/hunt-the-wumpus.png)

## Meetup:

https://www.meetup.com/montrealrb/events/304095501/

## Event:

Bring your laptop to this Montreal.rb Hack Night where everyone participates in building Hunt The Wampus in Ruby as per the game description at this webpage (Hack Night requirements will diverge):
https://www.javatpoint.com/the-wumpus-world-in-artificial-intelligence

In part 2, attendees are provided with a [complete Model layer implementation of Hunt The Wampus](https://github.com/AndyObtiva/hunt_the_wampus/tree/hack-night-part2-view), and they must add a View layer on top of it by utilizing any Ruby View approach, such as:
- CLI: Command Line Interface (e.g. using puts and gets)
- TUI: Textual User Interface (e.g. using Curses)
- GUI: Graphical User Interface (e.g. using Glimmer DSL for LibUI [has canvas support, but no image support] or Glimmer DSL for SWT [has canvas and image support])
- Web UI: Backend Web User Interface (e.g. using Rails and ERB, with or without Hotwire)
- Web UI: Frontend Web User Interface (e.g. using Rails, Opal Ruby, and Glimmer DSL for Web)

There is no requirement for previous participation in part 1, but attendees who participated in [Hack Night part 1 (Nov 6. 2024 meetup)](https://github.com/AndyObtiva/hunt_the_wampus/tree/hack-night-part1-model), which was about building the Model layer, could alternatively use their own Model layer implementation as the basis for adding the View layer.

It is OK to:
- Modify the provided Model layer if needed.
- Display only words or letters on the screen that signify game objects/senses in case displaying graphics takes too much effort for the Hack Night allotted time.

It is encouraged that:
- Attendees try out Ruby technologies they do not have much experience with.
- Attendees collaborate when needed, ask each other questions, and help each other.

The goal of this Hack Night is to practice Ruby Software Engineering skills in a low-pressure fun environment while building a non-serious game in addition to learning new or undiscovered Ruby technologies.

## Initial Code:

You can clone the github repo [hack-night-part2-view](https://github.com/AndyObtiva/hunt_the_wampus/tree/hack-night-part2-view) branch to find a complete Model layer implementation of Hunt The Wampus that you can use as a starting point for adding the View in Ruby.

```
git clone https://github.com/AndyObtiva/hunt_the_wampus.git
```

```
git checkout hack-night-part2-view
```

## Game Requirements:

- Display game board with only the agent cell visible.
- Support moving up, down, left, and right (one cell at a time) with keyboard keys or clickable mouse buttons. As the agent moves, the new cell the agent lands on becomes visible, and the old cell becomes no longer visible. The visible cell will display objects (like gold) and senses (like stench and breeze).
- Support grabbing gold if the current agent cell has gold.
- Support shooting arrow up, down, left, and right, indicating if the wampus was killed after the arrow is shot.
- Support dying if the agent encounters the wampus or the pit.
- Support winning if the agent encounters the exit.
- Show live score, which gets updated correctly after every move as per [Game Scoring](#game-scoring) details below.
- Support restarting the game.
- (bonus) Support random generation of boards (passing `random_board: false` to the `HuntTheWampus::Model::Game` object.

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

## Copyright

Copyright (c) 2024 Andy Maleh.

[MIT](/LICENSE.txt)

See [LICENSE.txt](/LICENSE.txt) for further details.
