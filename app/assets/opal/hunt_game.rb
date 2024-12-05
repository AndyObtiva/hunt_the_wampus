require 'glimmer-dsl-web'

require_relative 'hunt_the_wampus/model/game'

class HuntGame
  include Glimmer::Web::Component
  
  before_render do
    @game = HuntTheWampus::Model::Game.new(random_board: true)
  end
  
  after_render do
    Element['body'].on('keydown') do |event|
      case event.key_code
      when 38 # up
        @game.move_up
      when 39 # right
        @game.move_right
      when 40 # down
        @game.move_down
      when 37 # left
        @game.move_left
      when 71 # g (grab gold)
        @game.grab_gold
      when 87 # w (shoot arrow up)
        @game.shoot_arrow_up
      when 68 # d (shoot arrow right)
        @game.shoot_arrow_right
      when 83 # s (shoot arrow down)
        @game.shoot_arrow_down
      when 65 # a (shoot arrow left)
        @game.shoot_arrow_left
      when 82 # r (restart)
        @game.restart
      end
    end
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
        
        button('Restart') {
          onclick do
            @game.restart
          end
        }
      }
      
      table {
        tbody {
          content(@game, :board, recursive: true) do
            @game.board.each_with_index do |row_cells, row|
              tr {
                row_cells.each_with_index do |cell, column|
                  td(style: {width: 150, height: 150, border: '1px solid black', text_align: :center}) {
                    if cell.include?(:agent)
                      cell.each do |object|
                        img(src: "/assets/#{object}.png", style: {width: 40.%})
                      end
                    end
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
