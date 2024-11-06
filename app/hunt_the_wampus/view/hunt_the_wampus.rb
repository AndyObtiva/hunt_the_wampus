require 'hunt_the_wampus/model/greeting'

class HuntTheWampus
  module View
    class HuntTheWampus
      include Glimmer::LibUI::Application
    
          
      before_body do
        @greeting = Model::Greeting.new
        menu_bar
      end
  
      body {
        window {
          # Replace example content below with your own custom window content
          content_size 240, 240
          title 'Hunt The Wampus'
          
          margined true
          
          label {
            text <= [@greeting, :text]
          }
        }
      }
  
      def menu_bar
        menu('File') {
          menu_item('Preferences...') {
            on_clicked do
              display_preferences_dialog
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
      
      def display_preferences_dialog
        window {
          title 'Preferences'
          content_size 200, 100
          
          margined true
          
          vertical_box {
            padded true
            
            label('Greeting:') {
              stretchy false
            }
            
            radio_buttons {
              stretchy false
              
              items Model::Greeting::GREETINGS
              selected <=> [@greeting, :text_index]
            }
          }
        }.show
      end
    end
  end
end
