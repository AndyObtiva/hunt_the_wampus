require_relative '../../test_helper'

describe 'Hunt The Wampus' do
  subject { HuntTheWampus::Model::Game.new }
  
  let(:board) {
    [
      [:stench, nil, nil, nil],
      [:wampus, [:gold, :stench], nil, nil],
      [:stench, nil, :breeze, nil],
      [:agent, :breeze, :pit, :breeze],
    ]
  }
  
  it 'generates initial game board' do
    subject.board.must_equal board

    refute subject.stench?
    refute subject.gold?
    refute subject.breeze?
    refute subject.pit?
    refute subject.wampus?
    assert subject.alive?
    refute subject.dead?
  end
  
  it 'allows agent to move up and feel the stench of the wampus' do
    subject.move_up
    
    new_board = [
      [:stench, nil, nil, nil],
      [:wampus, [:gold, :stench], nil, nil],
      [[:agent, :stench], nil, :breeze, nil],
      [nil, :breeze, :pit, :breeze],
    ]
    subject.board.must_equal new_board
    
    assert subject.stench?
    refute subject.gold?
    refute subject.breeze?
    refute subject.pit?
    refute subject.wampus?
    assert subject.alive?
    refute subject.dead?
  end
  
  it 'allows agent to move right and feel the breeze of the pit' do
    subject.move_right
    
    new_board = [
      [:stench, nil, nil, nil],
      [:wampus, [:gold, :stench], nil, nil],
      [:stench, nil, :breeze, nil],
      [nil, [:agent, :breeze], :pit, :breeze],
    ]
    subject.board.must_equal new_board
    
    refute subject.stench?
    refute subject.gold?
    assert subject.breeze?
    refute subject.pit?
    refute subject.wampus?
    assert subject.alive?
    refute subject.dead?
  end
  
  it 'allows agent to move up and move right and feel nothing' do
    subject.move_up
    subject.move_right
    
    new_board = [
      [:stench, nil, nil, nil],
      [:wampus, [:gold, :stench], nil, nil],
      [:stench, :agent, :breeze, nil],
      [nil, :breeze, :pit, :breeze],
    ]
    subject.board.must_equal new_board
    
    refute subject.stench?
    refute subject.gold?
    refute subject.breeze?
    refute subject.pit?
    refute subject.wampus?
    assert subject.alive?
    refute subject.dead?
  end
  
  it 'allows agent to move up, move right, and move down and feel the breeze of the pit' do
    subject.move_up
    subject.move_right
    subject.move_down
    
    new_board = [
      [:stench, nil, nil, nil],
      [:wampus, [:gold, :stench], nil, nil],
      [:stench, nil, :breeze, nil],
      [nil, [:agent, :breeze], :pit, :breeze],
    ]
    subject.board.must_equal new_board
    
    refute subject.stench?
    refute subject.gold?
    assert subject.breeze?
    refute subject.pit?
    refute subject.wampus?
    assert subject.alive?
    refute subject.dead?
  end
  
  it 'allows agent to move up, move right, move down, and move left and feel nothing' do
    subject.move_up
    subject.move_right
    subject.move_down
    subject.move_left
    
    subject.board.must_equal board

    refute subject.stench?
    refute subject.gold?
    refute subject.breeze?
    refute subject.pit?
    refute subject.wampus?
    assert subject.alive?
    refute subject.dead?
  end
  
  it 'allows agent to move up twice, hitting the wampus and dying' do
    subject.move_up
    subject.move_up
    
    new_board = [
      [:stench, nil, nil, nil],
      [[:agent, :wampus], [:gold, :stench], nil, nil],
      [:stench, nil, :breeze, nil],
      [nil, :breeze, :pit, :breeze],
    ]
    subject.board.must_equal new_board

    refute subject.stench?
    refute subject.gold?
    refute subject.breeze?
    refute subject.pit?
    assert subject.wampus?
    refute subject.alive?
    assert subject.dead?
  end
  
  it 'allows agent to move right twice, falling into the pit and dying' do
    subject.move_right
    subject.move_right
    
    new_board = [
      [:stench, nil, nil, nil],
      [:wampus, [:gold, :stench], nil, nil],
      [:stench, nil, :breeze, nil],
      [nil, :breeze, [:agent, :pit], :breeze],
    ]
    subject.board.must_equal new_board

    refute subject.stench?
    refute subject.gold?
    refute subject.breeze?
    assert subject.pit?
    refute subject.wampus?
    refute subject.alive?
    assert subject.dead?
  end
  
  it 'allows agent to move right, then move up twice, sensing gold and the stench of the wampus, then grabbing gold to score 1000' do
    subject.move_right
    subject.score.must_equal -1
    subject.move_up
    subject.score.must_equal -2
    subject.move_up
    subject.score.must_equal -3
    
    new_board = [
      [:stench, nil, nil, nil],
      [:wampus, [:agent, :gold, :stench], nil, nil],
      [:stench, nil, :breeze, nil],
      [nil, :breeze, :pit, :breeze],
    ]
    subject.board.must_equal new_board

    assert subject.stench?
    assert subject.gold?
    refute subject.breeze?
    refute subject.pit?
    refute subject.wampus?
    assert subject.alive?
    refute subject.dead?
    
    subject.grab_gold
    subject.score.must_equal (1000 - 4)
    
    new_board = [
      [:stench, nil, nil, nil],
      [:wampus, [:agent, :stench], nil, nil],
      [:stench, nil, :breeze, nil],
      [nil, :breeze, :pit, :breeze],
    ]
    subject.board.must_equal new_board

    assert subject.stench?
    refute subject.gold?
    refute subject.breeze?
    refute subject.pit?
    refute subject.wampus?
    assert subject.alive?
    refute subject.dead?
  end
  
  
  it 'allows agent to shoot arrow up and kill the wampus' do
    wampus_killed_location = subject.shoot_arrow_up
    
    wampus_killed_location.must_equal([1, 0])
    subject.score.must_equal (100 - 1)
    
    subject.move_up
    subject.move_up
    subject.score.must_equal (100 - 3)
    
    new_board = [
      [nil, nil, nil, nil],
      [:agent, :gold, nil, nil],
      [nil, nil, :breeze, nil],
      [nil, :breeze, :pit, :breeze],
    ]
    subject.board.must_equal new_board
    
    refute subject.stench?
    refute subject.gold?
    refute subject.breeze?
    refute subject.pit?
    refute subject.wampus?
    assert subject.alive?
    refute subject.dead?
  end
  
  it 'allows agent to move right, then move up twice, then shoot arrow left and kill the wampus' do
    subject.move_right
    subject.move_up
    subject.move_up
    subject.score.must_equal -3
    
    wampus_killed_location = subject.shoot_arrow_left
    
    wampus_killed_location.must_equal([1, 0])
    subject.score.must_equal (100 - 4)
    
    subject.move_left
    subject.score.must_equal (100 - 5)
    
    new_board = [
      [nil, nil, nil, nil],
      [:agent, :gold, nil, nil],
      [nil, nil, :breeze, nil],
      [nil, :breeze, :pit, :breeze],
    ]
    subject.board.must_equal new_board
    
    refute subject.stench?
    refute subject.gold?
    refute subject.breeze?
    refute subject.pit?
    refute subject.wampus?
    assert subject.alive?
    refute subject.dead?
  end
  
  it 'allows agent to move right, then move up three times, then move left, then shoot arrow down and kill the wampus' do
    subject.move_right
    subject.move_up
    subject.move_up
    subject.move_up
    subject.move_left
    subject.score.must_equal -5
    
    wampus_killed_location = subject.shoot_arrow_down
    
    wampus_killed_location.must_equal([1, 0])
    subject.score.must_equal (100 - 6)
    
    subject.move_down
    subject.score.must_equal (100 - 7)
    
    new_board = [
      [nil, nil, nil, nil],
      [:agent, :gold, nil, nil],
      [nil, nil, :breeze, nil],
      [nil, :breeze, :pit, :breeze],
    ]
    subject.board.must_equal new_board
    
    refute subject.stench?
    refute subject.gold?
    refute subject.breeze?
    refute subject.pit?
    refute subject.wampus?
    assert subject.alive?
    refute subject.dead?
  end
  
  it 'allows agent to move up twice, then shoot arrow right and kill the wampus' do
    subject.board = [
      [nil, [:gold, :stench], nil, nil],
      [:stench, :wampus, :stench, nil],
      [nil, :stench, :breeze, nil],
      [:agent, :breeze, :pit, :breeze],
    ]
    
    subject.move_up
    subject.move_up
    subject.score.must_equal -2
    
    wampus_killed_location = subject.shoot_arrow_right
    
    wampus_killed_location.must_equal([1, 1])
    subject.score.must_equal (100 - 3)
    
    subject.move_right
    subject.score.must_equal (100 - 4)
    
    new_board = [
      [nil, :gold, nil, nil],
      [nil, :agent, nil, nil],
      [nil, nil, :breeze, nil],
      [nil, :breeze, :pit, :breeze],
    ]
    subject.board.must_equal new_board
    
    refute subject.stench?
    refute subject.gold?
    refute subject.breeze?
    refute subject.pit?
    refute subject.wampus?
    assert subject.alive?
    refute subject.dead?
  end
end
