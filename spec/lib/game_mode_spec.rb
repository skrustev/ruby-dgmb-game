require 'rspec/its'
require 'game_mode'

describe 'GameMode' do
  player1 = Player.new("Gosho", "blue")
  player2 = Player.new("Pesho", "yellow")
  player3 = Player.new("Ivo", "green")
  player4 = Player.new("Tosho", "red")
  players = { :"player1" => player1,
              :"player2" => player2,
              :"player3" => player3,
              :"player4" => player4 }
  subject(:game) { GameMode.new("player1", players) }
  

  its(:board) { should eq([ ["b:0", "b:1", "", "", "", "" , "", "", "", "r:0", "r:1"],
                            ["b:2", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
                            ["", "", "", "", "", "" , "", "", "", "", ""],
                            ["", "", "", "", "", "" , "", "", "", "", ""],
                            ["", "", "", "", "", "" , "", "", "", "", ""],
                            ["", "", "", "", "", "" , "", "", "", "", ""],
                            ["", "", "", "", "", "" , "", "", "", "", ""],
                            ["", "", "", "", "", "" , "", "", "", "", ""],
                            ["", "", "", "", "", "" , "", "", "", "", ""],
                            ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", "g:1"],
                            ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]])}
  its(:players) { should eq(players)}
  its(:turn) { should eq("player1") }
  its(:selected_pawn) { should eq(Pawn.new) }

  context "#add_player " do
    let(:game_empty) { GameMode.new("player1") }

    it "can add all players " do
      game_empty.add_player(player1)
      game_empty.add_player(player2)
      game_empty.add_player(player3)
      game_empty.add_player(player4)      

      expect(game_empty.players).to eq(players)
    end
  end

  context "can proceed next turns " do
    it "- can iterate 1 turn" do
      game.next_turn
      expect(game.turn).to eq("player2")
    end

    it "- can iterate 2 turns " do
      game.next_turn
      game.next_turn
      expect(game.turn).to eq("player3")
    end

    it "- can iterate 3 turns " do
      game.next_turn
      game.next_turn
      game.next_turn
      expect(game.turn).to eq("player4")
    end

    it "- can iterate 4 turns " do
      game.next_turn
      game.next_turn
      game.next_turn
      game.next_turn
      expect(game.turn).to eq("player1")
    end
  end

  context "blue " do
    let(:blue_turn) { GameMode.new("player1", players) }

    it "cannot select red pawns " do
      expect(blue_turn.select_pawn("r:0")).to eq(nil)
      expect(blue_turn.select_pawn("r:1")).to eq(nil)
      expect(blue_turn.select_pawn("r:2")).to eq(nil)
      expect(blue_turn.select_pawn("r:3")).to eq(nil)
    end

    it "cannot select green pawns " do
      expect(blue_turn.select_pawn("g:0")).to eq(nil)
      expect(blue_turn.select_pawn("g:1")).to eq(nil)
      expect(blue_turn.select_pawn("g:2")).to eq(nil)
      expect(blue_turn.select_pawn("g:3")).to eq(nil)
    end

    it "cannot select yellow pawns " do
      expect(blue_turn.select_pawn("y:0")).to eq(nil)
      expect(blue_turn.select_pawn("y:1")).to eq(nil)
      expect(blue_turn.select_pawn("y:2")).to eq(nil)
      expect(blue_turn.select_pawn("y:3")).to eq(nil)
    end

    it "can select non active pawns when rolled 6" do
      player1.last_roll = 6

      expect(blue_turn.select_pawn("b:0")).to eq(player1.pawns[:"b:0"])
      expect(blue_turn.select_pawn("b:1")).to eq(player1.pawns[:"b:1"])
      expect(blue_turn.select_pawn("b:2")).to eq(player1.pawns[:"b:2"])
      expect(blue_turn.select_pawn("b:3")).to eq(player1.pawns[:"b:3"])
    end

    it "cannot select non active pawns when not rolled 6" do
      player1.last_roll = 3

      expect(blue_turn.select_pawn("b:0")).to eq(nil)
      expect(blue_turn.select_pawn("b:1")).to eq(nil)
      expect(blue_turn.select_pawn("b:2")).to eq(nil)
      expect(blue_turn.select_pawn("b:3")).to eq(nil)
    end

    it "can activate pawn" do
      player1.last_roll = 6
      
      blue_turn.select_pawn("b:1")
      expect(blue_turn.selected_pawn.name).to eq("b:1")

      blue_turn.activate_pawn
      expect(blue_turn.board).to eq([ ["b:0", "", "", "", "b:1", "" , "", "", "", "r:0", "r:1"],
                                      ["b:2", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", "g:1"],
                                      ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]])      
    end

    it "can move pawn to any place" do

    end


  end

  context "yellow " do
    let(:yellow_turn) { GameMode.new("player2", players) }

    it "cannot select red pawns " do
      expect(yellow_turn.select_pawn("r:0")).to eq(nil)
      expect(yellow_turn.select_pawn("r:1")).to eq(nil)
      expect(yellow_turn.select_pawn("r:2")).to eq(nil)
      expect(yellow_turn.select_pawn("r:3")).to eq(nil)
    end

    it "cannot select green pawns " do
      expect(yellow_turn.select_pawn("g:0")).to eq(nil)
      expect(yellow_turn.select_pawn("g:1")).to eq(nil)
      expect(yellow_turn.select_pawn("g:2")).to eq(nil)
      expect(yellow_turn.select_pawn("g:3")).to eq(nil)
    end

    it "cannot select blue pawns " do
      expect(yellow_turn.select_pawn("b:0")).to eq(nil)
      expect(yellow_turn.select_pawn("b:1")).to eq(nil)
      expect(yellow_turn.select_pawn("b:2")).to eq(nil)
      expect(yellow_turn.select_pawn("b:3")).to eq(nil)
        
    end

    it "can select non active pawns when rolled 6" do
      player2.last_roll = 6

      expect(yellow_turn.select_pawn("y:0")).to eq(player2.pawns[:"y:0"])
      expect(yellow_turn.select_pawn("y:1")).to eq(player2.pawns[:"y:1"])
      expect(yellow_turn.select_pawn("y:2")).to eq(player2.pawns[:"y:2"])
      expect(yellow_turn.select_pawn("y:3")).to eq(player2.pawns[:"y:3"])
    end

    it "cannot select non active pawns when not rolled 6" do
      player2.last_roll = 2

      expect(yellow_turn.select_pawn("y:0")).to eq(nil)
      expect(yellow_turn.select_pawn("y:1")).to eq(nil)
      expect(yellow_turn.select_pawn("y:2")).to eq(nil)
      expect(yellow_turn.select_pawn("y:3")).to eq(nil)
    end

    it "can activate pawn" do
      player2.last_roll = 6

      yellow_turn.select_pawn("y:1")
      expect(yellow_turn.selected_pawn.name).to eq("y:1")

      yellow_turn.activate_pawn
      expect(yellow_turn.board).to eq([ ["b:0", "b:1", "", "", "", "" , "", "", "", "r:0", "r:1"],
                                      ["b:2", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["y:1", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["y:0", "", "", "", "", "" , "", "", "", "g:0", "g:1"],
                                      ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]])      
    end

    it "can move pawn to any place" do

    end
  end

  context "green " do
    let(:green_turn) { GameMode.new("player3", players) }

    it "cannot select red pawns " do
      expect(green_turn.select_pawn("r:0")).to eq(nil)
      expect(green_turn.select_pawn("r:1")).to eq(nil)
      expect(green_turn.select_pawn("r:2")).to eq(nil)
      expect(green_turn.select_pawn("r:3")).to eq(nil)
    end

    it "cannot select yellow pawns " do
      expect(green_turn.select_pawn("y:0")).to eq(nil)
      expect(green_turn.select_pawn("y:1")).to eq(nil)
      expect(green_turn.select_pawn("y:2")).to eq(nil)
      expect(green_turn.select_pawn("y:3")).to eq(nil)
    end

    it "cannot select blue pawns " do
      expect(green_turn.select_pawn("b:0")).to eq(nil)
      expect(green_turn.select_pawn("b:1")).to eq(nil)
      expect(green_turn.select_pawn("b:2")).to eq(nil)
      expect(green_turn.select_pawn("b:3")).to eq(nil)      
    end

    it "can select non active pawns when rolled 6" do
      player3.last_roll = 6

      expect(green_turn.select_pawn("g:0")).to eq(player3.pawns[:"g:0"])
      expect(green_turn.select_pawn("g:1")).to eq(player3.pawns[:"g:1"])
      expect(green_turn.select_pawn("g:2")).to eq(player3.pawns[:"g:2"])
      expect(green_turn.select_pawn("g:3")).to eq(player3.pawns[:"g:3"])
    end

    it "cannot select non active pawns when not rolled 6" do
      player3.last_roll = 5

      expect(green_turn.select_pawn("g:0")).to eq(nil)
      expect(green_turn.select_pawn("g:1")).to eq(nil)
      expect(green_turn.select_pawn("g:2")).to eq(nil)
      expect(green_turn.select_pawn("g:3")).to eq(nil)
    end

    it "can activate pawn" do
      player3.last_roll = 6

      green_turn.select_pawn("g:1")
      expect(green_turn.selected_pawn.name).to eq("g:1")

      green_turn.activate_pawn
      expect(green_turn.board).to eq([ ["b:0", "b:1", "", "", "", "" , "", "", "", "r:0", "r:1"],
                                      ["b:2", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", ""],
                                      ["y:2", "y:3", "", "", "", "" , "g:1", "", "", "g:2", "g:3"]])      
    end
  end

  context "red " do
    let(:red_turn) { GameMode.new("player4", players) }

    it "cannot select yellow pawns " do
      expect(red_turn.select_pawn("y:0")).to eq(nil)
      expect(red_turn.select_pawn("y:1")).to eq(nil)
      expect(red_turn.select_pawn("y:2")).to eq(nil)
      expect(red_turn.select_pawn("y:3")).to eq(nil)
    end

    it "cannot select green pawns " do
      expect(red_turn.select_pawn("g:0")).to eq(nil)
      expect(red_turn.select_pawn("g:1")).to eq(nil)
      expect(red_turn.select_pawn("g:2")).to eq(nil)
      expect(red_turn.select_pawn("g:3")).to eq(nil)
    end

    it "cannot select blue pawns " do
      expect(red_turn.select_pawn("b:0")).to eq(nil)
      expect(red_turn.select_pawn("b:1")).to eq(nil)
      expect(red_turn.select_pawn("b:2")).to eq(nil)
      expect(red_turn.select_pawn("b:3")).to eq(nil)
        
      end

    it "can select non active pawns when rolled 6" do
      player4.last_roll = 6

      expect(red_turn.select_pawn("r:0")).to eq(player4.pawns[:"r:0"])
      expect(red_turn.select_pawn("r:1")).to eq(player4.pawns[:"r:1"])
      expect(red_turn.select_pawn("r:2")).to eq(player4.pawns[:"r:2"])
      expect(red_turn.select_pawn("r:3")).to eq(player4.pawns[:"r:3"])
    end

    it "cannot select non active pawns when not rolled 6" do
      player4.last_roll = 4

      expect(red_turn.select_pawn("r:0")).to eq(nil)
      expect(red_turn.select_pawn("r:1")).to eq(nil)
      expect(red_turn.select_pawn("r:2")).to eq(nil)
      expect(red_turn.select_pawn("r:3")).to eq(nil)
    end

    it "can activate pawn" do
      player4.last_roll = 6

      red_turn.select_pawn("r:1")
      expect(red_turn.selected_pawn.name).to eq("r:1")

      red_turn.activate_pawn
      expect(red_turn.board).to eq([ ["b:0", "b:1", "", "", "", "" , "", "", "", "r:0", ""],
                                      ["b:2", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", "r:1"],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", "g:1"],
                                      ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]])      
    end
  end

end