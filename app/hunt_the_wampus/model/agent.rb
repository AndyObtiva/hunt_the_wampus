class HuntTheWampus
  module Model
    class Agent
      attr_reader :game
      attr_accessor :location, :alive, :has_arrow
    
      def initialize(game)
        @game = game
        restart
      end
      
      def restart
        self.has_arrow = true
        self.alive = true
        self.location = [3, 0]
      end
      
      def has_arrow?
        @has_arrow
      end
      
      def alive?
        @alive
      end
      
      def dead?
        !alive?
      end
      
      def sense_stench?
        game.agent_cell.include?(:stench)
      end
      
      def sense_breeze?
        game.agent_cell.include?(:breeze)
      end
      
      def sense_gold?
        game.agent_cell.include?(:gold)
      end
      
      def cell
        agent_row, agent_column = location
        game.board[agent_row][agent_column]
      end
    end
  end
end
