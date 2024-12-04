require_relative '../../test_helper'

describe 'Hunt The Wampus' do
  subject { HuntTheWampus::Model::Game.new }
  
  let(:board) {
    [
      [[:stench], [], [], [:exit]],
      [[:wampus], [:gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[:agent], [:breeze], [:pit], [:breeze]],
    ]
  }
  
  it 'generates initial game board' do
    _(subject.board).must_equal board
    _(subject.agent_location).must_equal [3, 0]
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    _(subject.score).must_equal 0
    _(subject.status).must_equal :playing
    refute subject.agent_senses_stench?
    refute subject.agent_senses_breeze?
    refute subject.agent_senses_gold?
  end
  
  it 'enables agent to move up and feel the stench of the wampus' do
    subject.move_up
    
    _(subject.agent_location).must_equal [2, 0]
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    _(subject.score).must_equal(-1)
    _(subject.status).must_equal :playing
    assert subject.agent_senses_stench?
    refute subject.agent_senses_breeze?
    refute subject.agent_senses_gold?
    
    new_board = [
      [[:stench], [], [], [:exit]],
      [[:wampus], [:gold, :stench], [], []],
      [[:agent, :stench], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  end
  
  it 'enables agent to move right and feel the breeze of the pit' do
    subject.move_right
    
    _(subject.agent_location).must_equal [3, 1]
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    _(subject.score).must_equal(-1)
    _(subject.status).must_equal :playing
    refute subject.agent_senses_stench?
    assert subject.agent_senses_breeze?
    refute subject.agent_senses_gold?
    
    new_board = [
      [[:stench], [], [], [:exit]],
      [[:wampus], [:gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:agent, :breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  end
  
  it 'enables agent to move up and move right and feel nothing' do
    subject.move_up
    subject.move_right
    
    _(subject.agent_location).must_equal [2, 1]
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    _(subject.score).must_equal(-2)
    _(subject.status).must_equal :playing
    refute subject.agent_senses_stench?
    refute subject.agent_senses_breeze?
    refute subject.agent_senses_gold?
    
    new_board = [
      [[:stench], [], [], [:exit]],
      [[:wampus], [:gold, :stench], [], []],
      [[:stench], [:agent], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  end
  
  it 'enables agent to move up, move right, and move down and feel the breeze of the pit' do
    subject.move_up
    subject.move_right
    subject.move_down
    
    _(subject.agent_location).must_equal [3, 1]
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    _(subject.score).must_equal(-3)
    _(subject.status).must_equal :playing
    refute subject.agent_senses_stench?
    assert subject.agent_senses_breeze?
    refute subject.agent_senses_gold?
    
    new_board = [
      [[:stench], [], [], [:exit]],
      [[:wampus], [:gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:agent, :breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  end
  
  it 'enables agent to move up, move right, move down, and move left and feel nothing' do
    subject.move_up
    subject.move_right
    subject.move_down
    subject.move_left
    
    _(subject.agent_location).must_equal [3, 0]
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    _(subject.score).must_equal(-4)
    _(subject.status).must_equal :playing
    refute subject.agent_senses_stench?
    refute subject.agent_senses_breeze?
    refute subject.agent_senses_gold?
    
    _(subject.board).must_equal board
  end
  
  it 'prevents agent from moving left against wall boundary' do
    subject.move_left
    
    _(subject.agent_location).must_equal [3, 0]
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    _(subject.score).must_equal(-1)
    _(subject.status).must_equal :playing
    
    _(subject.board).must_equal board
  end
  
  it 'prevents agent from moving down against wall boundary' do
    subject.move_down
    
    _(subject.agent_location).must_equal [3, 0]
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    _(subject.score).must_equal(-1)
    _(subject.status).must_equal :playing
    
    _(subject.board).must_equal board
  end
  
  it 'prevents agent from moving up against wall boundary' do
    subject.board = [
      [[:stench], [:agent], [], [:exit]],
      [[:wampus], [:gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    subject.agent_location = [0, 1]
    subject.move_up
    
    _(subject.agent_location).must_equal [0, 1]
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    _(subject.score).must_equal(-1)
    _(subject.status).must_equal :playing
    
    new_board = [
      [[:stench], [:agent], [], [:exit]],
      [[:wampus], [:gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  end
  
  it 'prevents agent from moving right against wall boundary' do
    subject.board = [
      [[:stench], [], [], [:agent]],
      [[:wampus], [:gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    subject.agent_location = [0, 3]
    subject.move_right
    
    _(subject.agent_location).must_equal [0, 3]
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    _(subject.score).must_equal(-1)
    _(subject.status).must_equal :playing
    
    new_board = [
      [[:stench], [], [], [:agent]],
      [[:wampus], [:gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  end
  
  it 'enables agent to move up twice, hitting the wampus and dying' do
    subject.move_up
    subject.move_up
    
    _(subject.agent_location).must_equal [1, 0]
    _(subject.score).must_equal(-2)
    _(subject.status).must_equal :lost
    assert subject.has_arrow?
    refute subject.agent_alive?
    assert subject.agent_dead?
    
    new_board = [
      [[:stench], [], [], [:exit]],
      [[:agent, :wampus], [:gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
    
    subject.move_up
    _(subject.agent_location).must_equal [1, 0]
    subject.move_right
    _(subject.agent_location).must_equal [1, 0]
    subject.move_down
    _(subject.agent_location).must_equal [1, 0]
    subject.move_left
    _(subject.agent_location).must_equal [1, 0]
  end
  
  it 'enables agent to move right twice, falling into the pit and dying' do
    subject.move_right
    subject.move_right
    
    _(subject.agent_location).must_equal [3, 2]
    _(subject.score).must_equal(-2)
    _(subject.status).must_equal :lost
    assert subject.has_arrow?
    refute subject.agent_alive?
    assert subject.agent_dead?
    
    new_board = [
      [[:stench], [], [], [:exit]],
      [[:wampus], [:gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:breeze], [:agent, :pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  
    subject.move_up
    _(subject.agent_location).must_equal [3, 2]
    subject.move_right
    _(subject.agent_location).must_equal [3, 2]
    subject.move_down
    _(subject.agent_location).must_equal [3, 2]
    subject.move_left
    _(subject.agent_location).must_equal [3, 2]
  end
  
  it 'enables agent to move right, then move up twice, sensing gold and the stench of the wampus, then grabbing gold to score 1000' do
    subject.move_right
    _(subject.agent_location).must_equal [3, 1]
    _(subject.score).must_equal(-1)
    subject.move_up
    _(subject.agent_location).must_equal [2, 1]
    _(subject.score).must_equal(-2)
    subject.move_up
    _(subject.agent_location).must_equal [1, 1]
    _(subject.score).must_equal(-3)
    
    _(subject.status).must_equal :playing
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    assert subject.agent_senses_stench?
    refute subject.agent_senses_breeze?
    assert subject.agent_senses_gold?
    
    new_board = [
      [[:stench], [], [], [:exit]],
      [[:wampus], [:agent, :gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
    
    subject.grab_gold
    
    _(subject.score).must_equal(1000 - 4)
    assert subject.agent_senses_stench?
    refute subject.agent_senses_breeze?
    refute subject.agent_senses_gold?
    
    new_board = [
      [[:stench], [], [], [:exit]],
      [[:wampus], [:agent, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  end
  
  
  it 'enables agent to shoot arrow up and kill the wampus' do
    wampus_killed_location = subject.shoot_arrow_up
    
    _(wampus_killed_location).must_equal([1, 0])
    _(subject.score).must_equal(100 - 1)
    
    subject.move_up
    subject.move_up
    
    _(subject.score).must_equal(100 - 3)
    _(subject.status).must_equal :playing
    refute subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
        
    new_board = [
      [[], [], [], [:exit]],
      [[:agent], [:gold], [], []],
      [[], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  end
  
  it 'prevents agent from shooting arrow up to kill the wampus after shooting arrow right and wasting it' do
    wampus_killed_location = subject.shoot_arrow_right
    _(wampus_killed_location).must_be_nil
    _(subject.score).must_equal(-1)
    refute subject.has_arrow?
    wampus_killed_location = subject.shoot_arrow_up
    
    _(wampus_killed_location).must_be_nil
    _(subject.score).must_equal(-1)
    
    subject.move_up
    subject.move_up
    
    _(subject.score).must_equal(-3)
    _(subject.status).must_equal :lost
    refute subject.has_arrow?
    refute subject.agent_alive?
    assert subject.agent_dead?
        
    new_board = [
      [[:stench], [], [], [:exit]],
      [[:agent, :wampus], [:gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  end
  
  it 'enables agent to move right, then move up twice, then shoot arrow left and kill the wampus' do
    subject.move_right
    subject.move_up
    subject.move_up
    
    _(subject.score).must_equal(-3)
    
    wampus_killed_location = subject.shoot_arrow_left
    
    _(wampus_killed_location).must_equal([1, 0])
    _(subject.score).must_equal(100 - 4)
    
    subject.move_left
    
    _(subject.score).must_equal(100 - 5)
    _(subject.status).must_equal :playing
    refute subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    
    new_board = [
      [[], [], [], [:exit]],
      [[:agent], [:gold], [], []],
      [[], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  end
  
  it 'enables agent to move right, then move up three times, then move left, then shoot arrow down and kill the wampus' do
    subject.move_right
    subject.move_up
    subject.move_up
    subject.move_up
    subject.move_left
    _(subject.score).must_equal(-5)
    
    wampus_killed_location = subject.shoot_arrow_down
    
    _(wampus_killed_location).must_equal([1, 0])
    _(subject.score).must_equal(100 - 6)
    
    subject.move_down
    
    _(subject.score).must_equal(100 - 7)
    _(subject.status).must_equal :playing
    refute subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    
    new_board = [
      [[], [], [], [:exit]],
      [[:agent], [:gold], [], []],
      [[], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  end
  
  it 'enables agent to move up twice, then shoot arrow right and kill the wampus' do
    subject.board = [
      [[], [:gold, :stench], [], [:exit]],
      [[:stench], [:wampus], [:stench], []],
      [[], [:stench], [:breeze], []],
      [[:agent], [:breeze], [:pit], [:breeze]],
    ]
    
    subject.move_up
    subject.move_up
    _(subject.score).must_equal(-2)
    
    wampus_killed_location = subject.shoot_arrow_right
    
    _(wampus_killed_location).must_equal([1, 1])
    _(subject.score).must_equal(100 - 3)
    
    subject.move_right
    
    _(subject.score).must_equal(100 - 4)
    _(subject.status).must_equal :playing
    refute subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    
    new_board = [
      [[], [:gold], [], [:exit]],
      [[], [:agent], [], []],
      [[], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
  end
  
  
  it 'enables agent to move right, move up three times, move right twice to reach exit, and game ends with a win (agent cannot move afterwards)' do
    subject.move_right
    subject.move_up
    subject.move_up
    subject.move_up
    subject.move_right
    subject.move_right
    
    _(subject.score).must_equal(-6)
    _(subject.agent_location).must_equal [0, 3]
    _(subject.status).must_equal :won
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    
    new_board = [
      [[:stench], [], [], [:agent, :exit]],
      [[:wampus], [:gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
    
    subject.move_down
    _(subject.agent_location).must_equal [0, 3]
  end
  
  it 'enables agent to move up twice, hitting the wampus and dying, then the game is restarted' do
    subject.move_up
    subject.move_up
    
    _(subject.agent_location).must_equal [1, 0]
    _(subject.score).must_equal(-2)
    _(subject.status).must_equal :lost
    assert subject.has_arrow?
    refute subject.agent_alive?
    assert subject.agent_dead?
    
    new_board = [
      [[:stench], [], [], [:exit]],
      [[:agent, :wampus], [:gold, :stench], [], []],
      [[:stench], [], [:breeze], []],
      [[], [:breeze], [:pit], [:breeze]],
    ]
    _(subject.board).must_equal new_board
    
    subject.restart
    
    _(subject.board).must_equal board
    _(subject.agent_location).must_equal [3, 0]
    assert subject.has_arrow?
    assert subject.agent_alive?
    refute subject.agent_dead?
    _(subject.score).must_equal 0
    _(subject.status).must_equal :playing
  end
  
  def assert_object_in_neighbording_cell_of_evil_object(object, evil_object:, cell:)
    opposite_object = evil_object == :wampus ? :pit : :wampus
    assert (cell.nil? || cell&.include?(object) || cell&.include?(opposite_object))
  end
  
  def assert_object_in_top_cell_of_evil_object(object, evil_object:, board:, row:, column:)
    new_row = row - 1
    return if new_row < 0
    new_column = column
    new_cell = board[new_row][new_column]
    assert_object_in_neighbording_cell_of_evil_object(object, evil_object:, cell: new_cell)
  end
  
  def assert_object_in_bottom_cell_of_evil_object(object, evil_object:, board:, row:, column:)
    new_row = row + 1
    return if new_row > 3
    new_column = column
    new_cell = board[new_row][new_column]
    assert_object_in_neighbording_cell_of_evil_object(object, evil_object:, cell: new_cell)
  end
  
  def assert_object_in_right_cell_of_evil_object(object, evil_object:, board:, row:, column:)
    new_row = row
    new_column = column + 1
    return if new_column > 3
    new_cell = board[new_row][new_column]
    assert_object_in_neighbording_cell_of_evil_object(object, evil_object:, cell: new_cell)
  end
  
  def assert_object_in_left_cell_of_evil_object(object, evil_object:, board:, row:, column:)
    new_row = row
    new_column = column - 1
    return if new_column < 0
    new_cell = board[new_row][new_column]
    assert_object_in_neighbording_cell_of_evil_object(object, evil_object:, cell: new_cell)
  end
  
  def assert_object_in_neighboring_cells_of_evil_object(object, evil_object:, board:, row:, column:)
    assert_object_in_top_cell_of_evil_object(object, evil_object:, board:, row:, column:)
    assert_object_in_bottom_cell_of_evil_object(object, evil_object:, board:, row:, column:)
    assert_object_in_right_cell_of_evil_object(object, evil_object:, board:, row:, column:)
    assert_object_in_left_cell_of_evil_object(object, evil_object:, board:, row:, column:)
  end
  
  it '(bonus) creates a game with a random board having one of each of the objects and evil object senses' do
    10.times do # test random generation 10 times to help ensure no bugs
      subject = HuntTheWampus::Model::Game.new(random_board: true)
      subject.board.each_with_index do |row_cells, row|
        row_cells.each_with_index do |cell, column|
          assert cell.intersection(HuntTheWampus::Model::Game::OBJECTS).size <= 1
          if cell.include?(:wampus)
            refute cell.include?(:pit)
            refute cell.include?(:agent)
            refute cell.include?(:gold)
            refute cell.include?(:exit)
            assert_object_in_neighboring_cells_of_evil_object(:stench, evil_object: :wampus, board: subject.board, row:, column:)
          elsif cell.include?(:pit)
            refute cell.include?(:wampus)
            refute cell.include?(:agent)
            refute cell.include?(:gold)
            refute cell.include?(:exit)
            assert_object_in_neighboring_cells_of_evil_object(:breeze, evil_object: :pit, board: subject.board, row:, column:)
          elsif cell.include?(:agent)
            refute cell.include?(:wampus)
            refute cell.include?(:pit)
            refute cell.include?(:gold)
            refute cell.include?(:exit)
          elsif cell.include?(:gold)
            refute cell.include?(:wampus)
            refute cell.include?(:agent)
            refute cell.include?(:pit)
            refute cell.include?(:exit)
          elsif cell.include?(:exit)
            refute cell.include?(:wampus)
            refute cell.include?(:agent)
            refute cell.include?(:gold)
            refute cell.include?(:pit)
          end
        end
      end
    end
  end
end
