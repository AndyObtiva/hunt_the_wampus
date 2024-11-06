require 'puts_debuggerer'

require 'hunt_the_wampus/model/game'

class HuntTheWampus
  module View
    class HuntTheWampus
      include Glimmer::LibUI::Application
    
      SHOOT_ARROW_DIRECTION_MAP = {
        'w' => 'up',
        'd' => 'right',
        's' => 'down',
        'a' => 'left',
      }
          
      before_body do
        @game = Model::Game.new
        menu_bar
      end
  
      body {
        window {
          # Replace example content below with your own custom window content
          content_size 640, 800
          title 'Hunt The Wampus'
          
          vertical_box {
            area {
              content(@game, :score) do
                rectangle(0, 0, 640, 160) {
                  fill :lightgrey
                }
                
                text(22, 44, 640) {
                  default_font family: 'Arial', size: 60
                    
                  string('score: ')
                    
                  string(@game.score.to_s)
                  
                  if @game.status != :playing
                    string(" (#{@game.status})") {
                      color @game.status == :lost ? :red : :green
                    }
                  end
                }
              end
              
              on_key_down do |area_key_event|
                handled = true # assume we will handle the event
                if %i[up right down left].include?(area_key_event[:ext_key])
                  @game.send("move_#{area_key_event[:ext_key]}")
                elsif %w[w d s a].include?(area_key_event[:key])
                  shoot_arrow_direction = SHOOT_ARROW_DIRECTION_MAP[area_key_event[:key]]
                  @game.send("shoot_arrow_#{shoot_arrow_direction}")
                elsif area_key_event[:key] == 'g'
                  @game.grab_gold
                else
                  handled = false # we won't handle the event after all
                end
                handled
              end
            }
            4.times do |row|
              horizontal_box {
                4.times do |column|
                  area {
                    content(@game, :board, recursive: true) do
                      rectangle(0, 0, 160, 160) {
                        fill :white
                      }
                    
                      text(22, 22, 160) {
                        default_font family: 'Arial', size: 30
                        
                        if [row, column] == @game.agent_location
                          @game.board[row][column].each_with_index do |object, object_index|
                            if object_index > 0
                              string(" / \n") {
                                color @game.status == :playing ? :black : (@game.status == :lost ? :red : :green)
                              }
                            end
                            string(object.to_s) {
                              color @game.status == :playing ? :black :  (@game.status == :lost ? :red : :green)
                            }
                          end
                        end
                      }
                    end
                  }
                end
              }
            end
          }
        }
      }
  
      def menu_bar
        menu('File') {
          menu_item('Restart') {
            on_clicked do
              @game.restart
            end
          }
          
          # Enables quitting with CMD+Q on Mac with Mac Quit menu item
          quit_menu_item if OS.mac?
        }
        menu('Help') {
          if OS.mac?
            about_menu_item {
              on_clicked do
                display_about_dialog
              end
            }
          end
          
          menu_item('About') {
            on_clicked do
              display_about_dialog
            end
          }
        }
      end
  
      def display_about_dialog
        message = "Hunt The Wampus #{VERSION}\n\n#{LICENSE}"
        msg_box('About', message)
      end
    end
  end
end
