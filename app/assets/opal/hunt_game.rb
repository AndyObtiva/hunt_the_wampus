require 'glimmer-dsl-web'

require_relative 'hunt_the_wampus/model/game'

class HuntGame
  include Glimmer::Web::Component
  
  before_render do
    @game = HuntTheWampus::Model::Game.new #(random_board: true)
  end
  
  markup {
    div {
      h1 { 'Hunt The Wampus' }
      h2 {
        inner_html <= [@game, :score,
                        on_read: ->(value) { "Score: #{value}" }
                      ]
      }
      h3 {
        inner_html <= [@game, :status,
                        on_read: ->(value) { "Status: #{value}" }
                      ]
      }
      
      div {
        button('Restart') {
          onclick do
            @game.restart
          end
        }
        
        button('<') {
          disabled <= [@game, :status, on_read: ->(value) { value != :playing }]
          
          onclick do
            @game.move_left
          end
        }
        
        button('^') {
          disabled <= [@game, :status, on_read: ->(value) { value != :playing }]
          
          onclick do
            @game.move_up
          end
        }
        
        button('V') {
          disabled <= [@game, :status, on_read: ->(value) { value != :playing }]
          
          onclick do
            @game.move_down
          end
        }
        
        button('>') {
          disabled <= [@game, :status, on_read: ->(value) { value != :playing }]
          
          onclick do
            @game.move_right
          end
        }
        
        button('G') {
          disabled <= [@game, :status, on_read: ->(value) { value != :playing }]
          
          onclick do
            @game.grab_gold
          end
        }
        
        button('S<') {
          disabled <= [@game.agent, :has_arrow, on_read: :!]
          disabled <= [@game, :status, on_read: ->(value) { value != :playing }]
          
          onclick do
            @game.shoot_arrow_left
          end
        }
        
        button('S^') {
          disabled <= [@game.agent, :has_arrow, on_read: :!]
          disabled <= [@game, :status, on_read: ->(value) { value != :playing }]
          
          onclick do
            @game.shoot_arrow_up
          end
        }
        
        button('SV') {
          disabled <= [@game.agent, :has_arrow, on_read: :!]
          disabled <= [@game, :status, on_read: ->(value) { value != :playing }]
          
          onclick do
            @game.shoot_arrow_down
          end
        }
        
        button('S>') {
          disabled <= [@game.agent, :has_arrow, on_read: :!]
          disabled <= [@game, :status, on_read: ->(value) { value != :playing }]
          
          onclick do
            @game.shoot_arrow_right
          end
        }
      }
      
      table {
        tbody {
          content(@game, :board, recursive: true) do
            @game.board.each_with_index do |row_cells, row|
              tr {
                row_cells.each_with_index do |cell, column|
                  td(style: {width: 60, height: 60, border: '1px solid black', text_align: :center}) {
                    cell.map(&:to_s).join(' / ') if cell.include?(:agent)
                  }
                end
              }
            end
          end
        }
      }
    }
  }
end
