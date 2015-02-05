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
                            ["", "", "", "", "", "X" , "", "", "", "", ""],
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
    let(:game_blue_start) { GameMode.new("player1", players) }

    it "cannot select red pawns " do
      expect(game_blue_start.select_pawn("r:0")).to eq("Cannot select enemy pawn!")
      expect(game_blue_start.select_pawn("r:1")).to eq("Cannot select enemy pawn!")
      expect(game_blue_start.select_pawn("r:2")).to eq("Cannot select enemy pawn!")
      expect(game_blue_start.select_pawn("r:3")).to eq("Cannot select enemy pawn!")
    end

    it "cannot select green pawns " do
      expect(game_blue_start.select_pawn("g:0")).to eq("Cannot select enemy pawn!")
      expect(game_blue_start.select_pawn("g:1")).to eq("Cannot select enemy pawn!")
      expect(game_blue_start.select_pawn("g:2")).to eq("Cannot select enemy pawn!")
      expect(game_blue_start.select_pawn("g:3")).to eq("Cannot select enemy pawn!")
    end

    it "cannot select yellow pawns " do
      expect(game_blue_start.select_pawn("y:0")).to eq("Cannot select enemy pawn!")
      expect(game_blue_start.select_pawn("y:1")).to eq("Cannot select enemy pawn!")
      expect(game_blue_start.select_pawn("y:2")).to eq("Cannot select enemy pawn!")
      expect(game_blue_start.select_pawn("y:3")).to eq("Cannot select enemy pawn!")
    end

    it "can select 4 non active pawns when rolled 6" do
      player1.last_roll = 6

      expect(game_blue_start.select_pawn("b:0")).to eq(player1.pawns[:"b:0"])
      expect(game_blue_start.select_pawn("b:1")).to eq(player1.pawns[:"b:1"])
      expect(game_blue_start.select_pawn("b:2")).to eq(player1.pawns[:"b:2"])
      expect(game_blue_start.select_pawn("b:3")).to eq(player1.pawns[:"b:3"])
    end

    it "cannot select 4 non active pawns when not rolled 6" do
      expect(game_blue_start.turn).to eq("player1")
      player1.last_roll = 3

      expect(game_blue_start.select_pawn("b:0")).to eq("Cannot select this pawn. You need to roll 6!")
      expect(game_blue_start.select_pawn("b:1")).to eq("Cannot select this pawn. You need to roll 6!")
      expect(game_blue_start.select_pawn("b:2")).to eq("Cannot select this pawn. You need to roll 6!")
      expect(game_blue_start.select_pawn("b:3")).to eq("Cannot select this pawn. You need to roll 6!")
    end

    it "can activate pawn 1" do
      player1.last_roll = 6
      

      expect(game_blue_start.players[:"player1"].pawns[:"b:1"].is_active).to eq(false)
      game_blue_start.select_pawn("b:1")
      expect(game_blue_start.selected_pawn).to eq(player1.pawns[:"b:1"])
      expect(game_blue_start.selected_pawn.pos).to eq([0, 1])

      game_blue_start.activate_selected_pawn
      expect(game_blue_start.board).to eq([ ["b:0", "", "", "", "b:1", "" , "", "", "", "r:0", "r:1"],
                                      ["b:2", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "X" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", "g:1"],
                                      ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]])

      expect(game_blue_start.selected_pawn.pos).to eq([0, 4])
      game_blue_start.destroy_pawn("b:1", [0, 4])
    end

    it "can activate pawn 2" do
      player1.last_roll = 6
      
      game_blue_start.select_pawn("b:2")
      expect(game_blue_start.selected_pawn.name).to eq("b:2")
      expect(game_blue_start.selected_pawn.pos).to eq([1, 0])

      game_blue_start.activate_selected_pawn
      expect(game_blue_start.board).to eq([ ["b:0", "b:1", "", "", "b:2", "" , "", "", "", "r:0", "r:1"],
                                      ["", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "X" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["", "", "", "", "", "" , "", "", "", "", ""],
                                      ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", "g:1"],
                                      ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]])

      expect(game_blue_start.selected_pawn.pos).to eq([0, 4])
      game_blue_start.destroy_pawn("b:2", [0, 4])
    end

    it "can select only 1 active pawn and not 3 non active" do
      player1.last_roll = 6
      expect(game_blue_start.select_pawn("b:1")).to eq(player1.pawns[:"b:1"])
      game_blue_start.activate_selected_pawn

      player1.last_roll = 4

      expect(game_blue_start.select_pawn("b:0")).to eq("Cannot select this pawn. You need to roll 6!")
      expect(game_blue_start.select_pawn("b:1")).to eq(player1.pawns[:"b:1"])
      expect(game_blue_start.select_pawn("b:2")).to eq("Cannot select this pawn. You need to roll 6!")
      expect(game_blue_start.select_pawn("b:3")).to eq("Cannot select this pawn. You need to roll 6!")
      game_blue_start.destroy_pawn("b:1", [0, 4])
    end

    it "can destroy pawn at position" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:0")
      expect(game_blue_start.selected_pawn.pos).to eq([0, 0])

      game_blue_start.activate_selected_pawn
      expect(game_blue_start.selected_pawn.pos).to eq([0, 4])

      game_blue_start.destroy_pawn("b:0", [0, 4])
      expect(game_blue_start.selected_pawn.pos).to eq([0, 0])
    end

    it "can move pawn" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:1")
      expect(game_blue_start.selected_pawn.pos).to eq([0, 1])

      game_blue_start.activate_selected_pawn
      expect(game_blue_start.selected_pawn.pos).to eq([0, 4])

      player1.last_roll = 4
      game_blue_start.select_pawn("b:1")
      expect(game_blue_start.selected_pawn.pos).to eq([0, 4])
      game_blue_start.move_selected_pawn
      expect(game_blue_start.selected_pawn.pos).to eq([4, 4])
      expect(game_blue_start.board).to eq([ ["b:0", "", "", "", "", "" , "", "", "", "r:0", "r:1"],
                                ["b:2", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
                                ["", "", "", "", "", "" , "", "", "", "", ""],
                                ["", "", "", "", "", "" , "", "", "", "", ""],
                                ["", "", "", "", "b:1", "" , "", "", "", "", ""],
                                ["", "", "", "", "", "X" , "", "", "", "", ""],
                                ["", "", "", "", "", "" , "", "", "", "", ""],
                                ["", "", "", "", "", "" , "", "", "", "", ""],
                                ["", "", "", "", "", "" , "", "", "", "", ""],
                                ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", "g:1"],
                                ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]])
      expect(game_blue_start.turn).to eq("player2")

      game_blue_start.override_turn("player1")
      player1.last_roll = 6
      game_blue_start.select_pawn("b:1")
      expect(game_blue_start.selected_pawn.pos).to eq([4, 4])
      game_blue_start.move_selected_pawn
      expect(game_blue_start.selected_pawn.pos).to eq([6, 0])
      expect(game_blue_start.board).to eq([ ["b:0", "", "", "", "", "" , "", "", "", "r:0", "r:1"],
                                ["b:2", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
                                ["", "", "", "", "", "" , "", "", "", "", ""],
                                ["", "", "", "", "", "" , "", "", "", "", ""],
                                ["", "", "", "", "", "" , "", "", "", "", ""],
                                ["", "", "", "", "", "X" , "", "", "", "", ""],
                                ["b:1", "", "", "", "", "" , "", "", "", "", ""],
                                ["", "", "", "", "", "" , "", "", "", "", ""],
                                ["", "", "", "", "", "" , "", "", "", "", ""],
                                ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", "g:1"],
                                ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]])
      expect(game_blue_start.turn).to eq("player1")

      game_blue_start.destroy_pawn("b:1", [6, 0])
    end

    it "cannot move inactive pawn when rolled 6" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:1")
      
      expect(game_blue_start.move_selected_pawn).to eq("You need to activate this pawn first")
    end

    it "can finish pawn" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:2")
      expect(game_blue_start.selected_pawn.name).to eq("b:2")
      expect(game_blue_start.selected_pawn.pos).to eq([1, 0])


      game_blue_start.select_pawn("b:0")
      game_blue_start.activate_selected_pawn
      expect(game_blue_start.selected_pawn.pos).to eq([0, 4])

      [1, 2, 3, 4, 5, 6, 7, 8].each do
        game_blue_start.override_turn("player1")
        player1.last_roll = 5
        game_blue_start.select_pawn("b:0")
        game_blue_start.move_selected_pawn
      end     
      expect(game_blue_start.selected_pawn.pos).to eq([1, 5])

      #should roll exactly 4
      #roll 4
      game_blue_start.override_turn("player1")
      player1.last_roll = 4
      expect(game_blue_start.select_pawn("b:0")).to eq(player1.pawns[:"b:0"])
      game_blue_start.move_selected_pawn

      expect(game_blue_start.selected_pawn.is_active).to eq(false)
      expect(game_blue_start.selected_pawn.is_finished).to eq(true)
      expect(game_blue_start.board).to eq([ ["", "b:1", "", "", "", "" , "", "", "", "r:0", "r:1"],
                                            ["b:2", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "X" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", "g:1"],
                                            ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]])


    end

    it "cannot finish pawn when not rolled proper number" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:2")
      expect(game_blue_start.selected_pawn.name).to eq("b:2")
      expect(game_blue_start.selected_pawn.pos).to eq([1, 0])


      game_blue_start.select_pawn("b:0")
      game_blue_start.activate_selected_pawn
      expect(game_blue_start.selected_pawn.pos).to eq([0, 4])

      [1, 2, 3, 4, 5, 6, 7].each do
        game_blue_start.override_turn("player1")
        player1.last_roll = 5
        game_blue_start.select_pawn("b:0")
        game_blue_start.move_selected_pawn
      end

      game_blue_start.override_turn("player1")
      player1.last_roll = 6
      game_blue_start.select_pawn("b:0")
      game_blue_start.move_selected_pawn

      expect(game_blue_start.selected_pawn.pos).to eq([2, 5])

      #should roll exactly 3
      #roll 5
      game_blue_start.override_turn("player1")
      player1.last_roll = 5
      game_blue_start.select_pawn("b:0")
      
      expect(game_blue_start.select_pawn("b:0")).to eq("You need to roll 3 to use this pawn")

      #roll 4
      game_blue_start.override_turn("player1")
      player1.last_roll = 4
      game_blue_start.select_pawn("b:0")
      
      expect(game_blue_start.select_pawn("b:0")).to eq("You need to roll 3 to use this pawn")
    end

    it "can destroy pawn when stepped on it" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:1")
      game_blue_start.activate_selected_pawn

      expect(game_blue_start.turn).to eq("player1")
      
      player1.last_roll = 1
      game_blue_start.move_selected_pawn

      expect(game_blue_start.board).to eq([ ["b:0", "", "", "", "", "" , "", "", "", "r:0", "r:1"],
                                            ["b:2", "b:3", "", "", "b:1", "" , "", "", "", "r:2", "r:3"],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "X" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", "g:1"],
                                            ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]])
      expect(game_blue_start.turn).to eq("player2")

      game_blue_start.override_turn("player4")
      player4.last_roll = 6
      game_blue_start.select_pawn("r:0")
      game_blue_start.activate_selected_pawn

      [1,2].each do
        game_blue_start.override_turn("player4")
        player4.last_roll = 6
        game_blue_start.move_selected_pawn
      end

      game_blue_start.override_turn("player4")
      player4.last_roll = 2
      game_blue_start.move_selected_pawn

      expect(game_blue_start.board).to eq([ ["b:0", "", "", "", "", "" , "", "", "", "", "r:1"],
                                            ["b:2", "b:3", "", "", "b:1", "" , "", "", "", "r:2", "r:3"],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "r:0", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "X" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", "g:1"],
                                            ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]])
      expect(game_blue_start.turn).to eq("player1")

      player1.last_roll = 3
      game_blue_start.select_pawn("b:1")
      game_blue_start.move_selected_pawn

      expect(player4.pawns[:"r:0"].pos).to eq([0, 9])
      expect(game_blue_start.board).to eq([ ["b:0", "", "", "", "", "" , "", "", "", "r:0", "r:1"],
                                            ["b:2", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "b:1", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "X" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["", "", "", "", "", "" , "", "", "", "", ""],
                                            ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", "g:1"],
                                            ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]])

    end

  end
end