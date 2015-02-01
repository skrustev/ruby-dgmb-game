require 'tty'

class GameMode
  attr_accessor :players
  attr_reader :turn

  def initialize

  end

end

class GameMenu

  def initialize()
    @shell = TTY::Shell.new

    initialize_start_menu
  end

  def initialize_start_menu
    puts "Welcome to Don't Get Mad Bro!"
    puts
    puts "Please choose on option to proceed."
    start_menu = "1. New game\n2. Exit"

    term = TTY::Terminal.new

    @shell.ask "1. New game\n2. Exit" do
                argument :required
              end.read_string

  end

end

#test out the TTY input reader
shell2 = TTY::Shell.new
shell2.ask("What is your name?").argument(:required).default('Piotr').validate(/\w+\s\w+/).read_string

