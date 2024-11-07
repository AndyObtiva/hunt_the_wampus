require_relative 'agent'

class HuntTheWampus
  module Model
    class Game
      OBJECTS = [:agent, :wampus, :pit, :gold, :exit]
      EVIL_OBJECTS = [:wampus, :pit]
      SENSES = [:stench, :breeze, :gold]
      OBJECT_SENSES = {wampus: :stench, pit: :breeze}
    
      attr_accessor :board
      attr_reader :score, :status, :random_board
    
      def initialize(random_board: false)
        @random_board = random_board
        @agent = Agent.new
        restart
      end
      
      def restart
        @agent.restart
        @score = 0
        @status = :playing
        generate_board
      end
      
      def generate_board
        if random_board
          @board = empty_board
          objects = OBJECTS.dup
          object_locations = 4.times.to_a.permutation(2).to_a.shuffle.take(OBJECTS.size)
          objects.each_with_index do |object, object_index|
            object_location = object_locations[object_index]
            object_row, object_column = object_location
            if EVIL_OBJECTS.include?(object)
              @board[object_row][object_column] = [object]
            else
              @board[object_row][object_column] << object
            end
            add_senses(object, object_location)
          end
          @board
        else
          @board = [
            [[:stench], [], [], [:exit]],
            [[:wampus], [:gold, :stench], [], []],
            [[:stench], [], [:breeze], []],
            [[:agent], [:breeze], [:pit], [:breeze]],
          ]
        end
      end
      
      def empty_board
        4.times.map do |row|
          4.times.map do |column|
            []
          end
        end
      end
    
      def agent_location
        @agent.location
      end
    
      def agent_location=(location)
        @agent.location = location
      end
      
      def has_arrow?
        @agent.has_arrow?
      end
      
      def agent_alive?
        @agent.alive?
      end
      
      def agent_dead?
        @agent.dead?
      end
      
      def move_up
        move_agent(-1, 0)
      end
      
      def move_right
        move_agent(0, 1)
      end
      
      def move_down
        move_agent(1, 0)
      end
      
      def move_left
        move_agent(0, -1)
      end

      def move_agent(row_diff, column_diff)
        return unless status == :playing
        @score -= 1
        agent_row, agent_column = agent_location
        board[agent_row][agent_column].delete(:agent)
        new_agent_row = [[agent_row + row_diff, 0].max, 3].min
        new_agent_column = [[agent_column + column_diff, 0].max, 3].min
        @agent.location = [new_agent_row, new_agent_column]
        board[new_agent_row][new_agent_column] << :agent
        board[new_agent_row][new_agent_column].sort!
        update_status
      end
      
      def grab_gold
        @score -= 1
        if agent_cell.include?(:gold)
          @score += 1000
          remove_object(:gold, agent_location)
        end
      end
      
      def shoot_arrow_up
        agent_shoots_arrow(-1, 0)
      end
      
      def shoot_arrow_down
        agent_shoots_arrow(1, 0)
      end
      
      def shoot_arrow_right
        agent_shoots_arrow(0, 1)
      end
      
      def shoot_arrow_left
        agent_shoots_arrow(0, -1)
      end
      
      private
      
      def update_status
        if !agent_cell.intersection([:wampus, :pit]).empty?
          @status = :lost
          @agent.alive = false
        elsif agent_cell.include?(:exit)
          @status = :won
        end
      end
      
      def agent_cell
        agent_row, agent_column = agent_location
        board[agent_row][agent_column]
      end
      
      def remove_object(object, location)
        row, column = location
        return unless row.between?(0, 3) && column.between?(0, 3)
        board[row][column].delete(object)
      end
      
      def add_object(object, location)
        row, column = location
        return unless row.between?(0, 3) && column.between?(0, 3)
        board[row][column] << object
        board[row][column].sort!
      end
      
      def add_senses(object, location)
        sense = OBJECT_SENSES[object]
        return unless sense
        row, column = location
        location1 = [row - 1, column]
        # TODO unless cell has wampus or breeze
        add_object(sense, location1) if board[location1[0]][location1[1]].intersection(EVIL_OBJECTS).empty?
        location2 = [row + 1, column]
        add_object(sense, location2) if board[location1[0]][location1[1]].intersection(EVIL_OBJECTS).empty?
        location3 = [row, column + 1]
        add_object(sense, location3) if board[location1[0]][location1[1]].intersection(EVIL_OBJECTS).empty?
        location4 = [row, column - 1]
        add_object(sense, location4) if board[location1[0]][location1[1]].intersection(EVIL_OBJECTS).empty?
      end
        
      def agent_shoots_arrow(row_diff, column_diff)
        return unless has_arrow?
        @agent.has_arrow = false
        @score -= 1
        agent_row, agent_column = agent_location
        next_row = [[agent_row + row_diff, 0].max, 3].min
        next_column = [[agent_column + column_diff, 0].max, 3].min
        last_row = last_column = nil
        until next_row == last_row && next_column == last_column
          if board[next_row][next_column].include?(:wampus)
            @score += 100
            wampus_killed_location = [next_row, next_column]
            remove_object(:wampus, wampus_killed_location)
            stench1_location = [next_row + 1, next_column]
            remove_object(:stench, stench1_location)
            stench2_location = [next_row - 1, next_column]
            remove_object(:stench, stench2_location)
            stench3_location = [next_row, next_column + 1]
            remove_object(:stench, stench3_location)
            stench4_location = [next_row, next_column - 1]
            remove_object(:stench, stench4_location)
            return wampus_killed_location
          end
          last_row = next_row
          last_column = next_column
          next_row = [[next_row + row_diff, 0].max, 3].min
          next_column = [[next_column + column_diff, 0].max, 3].min
        end
      end
    end
  end
end
