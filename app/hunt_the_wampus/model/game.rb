class HuntTheWampus
  module Model
    class Game
      attr_accessor :board, :agent_location, :score, :has_arrow
      alias has_arrow? has_arrow
      
      def initialize
        start
      end
      
      def start
        self.agent_location = [3, 0]
        self.score = 0
        self.has_arrow = true
        generate_board
      end
      alias restart start
    
      def generate_board
        self.board = [
          [[:stench], [], [], [:exit]],
          [[:wampus], [:gold, :stench], [], []],
          [[:stench], [], [:breeze], []],
          [[:agent], [:breeze], [:pit], [:breeze]],
        ]
      end
      
      def move_up
        move_agent_location { |agent_location| agent_location[0] = [agent_location[0] - 1, 0].max }
      end
      
      def move_down
        move_agent_location { |agent_location| agent_location[0] = [agent_location[0] + 1, 3].min }
      end
      
      def move_left
        move_agent_location { |agent_location| agent_location[1] = [agent_location[1] - 1, 0].max }
      end
      
      def move_right
        move_agent_location { |agent_location| agent_location[1] = [agent_location[1] + 1, 3].min }
      end
      
      def grab_gold
        return unless status == :playing
        removal_success = remove_object_from_board(:gold, *@agent_location)
        self.score -= 1
        self.score += 1000 if removal_success
      end
      
      def shoot_arrow_up
        shoot_arrow_vertically(0..(@agent_location[0] - 1))
      end
      
      def shoot_arrow_down
        shoot_arrow_vertically((@agent_location[0] + 1)..3)
      end
      
      def shoot_arrow_left
        shoot_arrow_horizontally(0..(@agent_location[1] - 1))
      end
      
      def shoot_arrow_right
        shoot_arrow_horizontally((@agent_location[1] + 1)..3)
      end
      
      def shoot_arrow_vertically(location_range)
        return unless status == :playing && has_arrow?
        wampus_killed_location = nil
        self.has_arrow = false
        self.score -= 1
        location_range.each do |row|
          column = @agent_location[1]
          wampus_killed_location ||= check_if_wampus_dead_at_location(row, column)
        end
        wampus_killed_location
      end
      
      def shoot_arrow_horizontally(location_range)
        return unless status == :playing && has_arrow?
        wampus_killed_location = nil
        self.has_arrow = false
        self.score -= 1
        location_range.each do |column|
          row = @agent_location[0]
          wampus_killed_location ||= check_if_wampus_dead_at_location(row, column)
        end
        wampus_killed_location
      end
      
      def check_if_wampus_dead_at_location(row, column)
        wampus_killed_location = nil
        if board_has_object_at_location?(:wampus, row, column)
          wampus_killed_location = [row, column]
          remove_object_from_board(:wampus, *wampus_killed_location)
          remove_object_from_board(:stench, wampus_killed_location[0] - 1, wampus_killed_location[1])
          remove_object_from_board(:stench, wampus_killed_location[0] + 1, wampus_killed_location[1])
          remove_object_from_board(:stench, wampus_killed_location[0], wampus_killed_location[1] - 1)
          remove_object_from_board(:stench, wampus_killed_location[0], wampus_killed_location[1] + 1)
          self.score += 100
        end
        wampus_killed_location
      end
      
      def board_has_object_at_location?(object, row, column)
        cell = @board.dig(row, column)
        cell == object || (cell.is_a?(Array) && cell.include?(object))
      end
      
      def agent_alive?
        !agent_dead?
      end
      
      def agent_dead?
        cell = @board.dig(*@agent_location)
        cell.is_a?(Array) && (cell.include?(:pit) || cell.include?(:wampus))
      end
      
      def status
        if board_has_object_at_location?(:exit, *agent_location)
          :won
        elsif agent_dead?
          :lost
        else
          :playing
        end
      end
      
      private
      
      def move_agent_location(&agent_location_updater)
        return unless status == :playing
        old_agent_location = @agent_location.clone
        agent_location_updater.call(@agent_location)
        remove_object_from_board(:agent, *old_agent_location)
        add_object_to_board(:agent, *@agent_location)
        self.score -= 1
      end
      
      def remove_object_from_board(object, row, column)
        return false unless row.between?(0, 3) && column.between?(0, 3)
        
        cell = @board.dig(row, column)
        if cell.include?(object)
          @board[row][column].delete(object)
          true
        end
      end
      
      def add_object_to_board(object, row, column)
        cell = @board.dig(row, column)
        if !cell.include?(object)
          @board[row][column] << object
          @board[row][column] = @board[row][column].sort
        end
      end
    end
  end
end
