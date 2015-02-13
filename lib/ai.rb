require_relative './player'

class AI < Player
  def initialize(game_mode, name = nil, color = nil)
    super(name, color)

    @game_mode = game_mode
  end

  def choose_pawn
    chosen = []
    if @last_roll == 6
      @pawns.each do |name, pawn|
        unless pawn.is_active
          chosen = [name, "to_activate"]
        end
      end
    elsif @active_pawns == 1
      @pawns.each do |name, pawn|
        if pawn.is_active
          chosen = [name, "to_move"]
        end
      end
    elsif  @active_pawns > 1
      active = []
      @pawns.each do |name, pawn|
        if pawn.is_active
          active << name
        end
      end

      chosen = [active[rand(active.size)], "to_move"]
    end

    chosen
  end
end