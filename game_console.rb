require 'tty'
require_relative "lib/game_mode"
require_relative "lib/player"

class GameMenu

  def initialize()
    @shell = TTY::Shell.new

    initialize_start_menu
  end

  def initialize_start_menu
    puts "Welcome to Don't Get Mad Bro!"
    puts
    puts "Please choose on option to proceed."

    answer = @shell.ask "1. New game\n2. Exit" do
                argument :required
              end.read_string

  end

end

#test out the TTY input reader
shell = TTY::Shell.new
name = shell.ask("What is your name?") do
    argument(:required)
    default('Piotr')
end.read_string

puts "Hello " + name