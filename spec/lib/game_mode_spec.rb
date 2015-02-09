require 'rspec/its'
require 'game_mode'

describe 'GameMode' do
  player1 = Player.new("Gosho", "blue")
  player2 = Player.new("Tosho", "red")
  player3 = Player.new("Pesho", "yellow")
  player4 = Player.new("Ivo", "green")
  players = { :"player1" => player1,
              :"player2" => player2,
              :"player3" => player3,
              :"player4" => player4 }
  subject(:game) { GameMode.new("player1", players) }
  
  its(:board) { should eq(
    [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
     [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
     [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], ["b:1"], [], []],
     [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
     [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
     [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
     [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
     [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
     [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
     [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
     [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
     [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
     [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
     [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
     [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
  )}

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
      expect(game_blue_start.selected_pawn.pos).to eq([2, 12])

      game_blue_start.activate_selected_pawn
      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], ["b:1"], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], [], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )

      expect(game_blue_start.selected_pawn.pos).to eq([0, 6])
      game_blue_start.destroy_pawns("b:1", [0, 6])
    end

    it "can activate pawn 2" do
      player1.last_roll = 6
      
      game_blue_start.select_pawn("b:2")
      expect(game_blue_start.selected_pawn.name).to eq("b:2")
      expect(game_blue_start.selected_pawn.pos).to eq([3, 11])

      game_blue_start.activate_selected_pawn
      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], ["b:2"], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], ["b:1"], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], [], ["b:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
     )

      expect(game_blue_start.selected_pawn.pos).to eq([0, 6])
      game_blue_start.destroy_pawns("b:2", [0, 6])
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
      game_blue_start.destroy_pawns("b:1", [0, 6])
    end

    it "can destroy pawn at position" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:0")
      expect(game_blue_start.selected_pawn.pos).to eq([2, 11])

      game_blue_start.activate_selected_pawn
      expect(game_blue_start.selected_pawn.pos).to eq([0, 6])

      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], ["b:0"], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], [], ["b:1"], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )
      game_blue_start.destroy_pawns("b:0", [0, 6])
      expect(game_blue_start.selected_pawn.pos).to eq([2, 11])
      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], ["b:1"], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )
    end

    it "can move pawn" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:1")
      expect(game_blue_start.selected_pawn.pos).to eq([2, 12])

      game_blue_start.activate_selected_pawn
      expect(game_blue_start.selected_pawn.pos).to eq([0, 6])

      player1.last_roll = 4
      game_blue_start.select_pawn("b:1")
      expect(game_blue_start.selected_pawn.pos).to eq([0, 6])
      game_blue_start.move_selected_pawn
      expect(game_blue_start.selected_pawn.pos).to eq([4, 6])
      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], [], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], ["b:1"], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
       )
      expect(game_blue_start.turn).to eq("player2")

      game_blue_start.override_turn("player1")
      player1.last_roll = 6
      game_blue_start.select_pawn("b:1")
      expect(game_blue_start.selected_pawn.pos).to eq([4, 6])
      game_blue_start.move_selected_pawn
      expect(game_blue_start.selected_pawn.pos).to eq([6, 2])
      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], [], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["b:1"], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
       )
      expect(game_blue_start.turn).to eq("player1")

      game_blue_start.destroy_pawns("b:1", [6, 2])
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
      expect(game_blue_start.selected_pawn.pos).to eq([3, 11])


      game_blue_start.select_pawn("b:0")
      game_blue_start.activate_selected_pawn
      expect(game_blue_start.selected_pawn.pos).to eq([0, 6])

      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].each do
        game_blue_start.override_turn("player1")
        player1.last_roll = 5
        game_blue_start.select_pawn("b:0")
        game_blue_start.move_selected_pawn
      end     

      game_blue_start.override_turn("player1")
      player1.last_roll = 2
      game_blue_start.select_pawn("b:0")
      game_blue_start.move_selected_pawn

      expect(game_blue_start.selected_pawn.pos).to eq([2, 7])
      #should roll exactly 4
      #roll 4
      game_blue_start.override_turn("player1")
      player1.last_roll = 4
      expect(game_blue_start.select_pawn("b:0")).to eq(player1.pawns[:"b:0"])
      game_blue_start.move_selected_pawn

      expect(game_blue_start.selected_pawn.is_active).to eq(false)
      expect(game_blue_start.selected_pawn.is_finished).to eq(true)
      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], [], ["b:1"], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )
    end

    it "cannot finish pawn when not rolled proper number" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:2")
      expect(game_blue_start.selected_pawn.name).to eq("b:2")
      expect(game_blue_start.selected_pawn.pos).to eq([3, 11])


      game_blue_start.select_pawn("b:0")
      game_blue_start.activate_selected_pawn
      expect(game_blue_start.selected_pawn.pos).to eq([0, 6])

      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].each do
        game_blue_start.override_turn("player1")
        player1.last_roll = 5
        game_blue_start.select_pawn("b:0")
        game_blue_start.move_selected_pawn
      end

      game_blue_start.override_turn("player1")
      player1.last_roll = 3
      game_blue_start.select_pawn("b:0")
      game_blue_start.move_selected_pawn

      expect(game_blue_start.selected_pawn.pos).to eq([3, 7])

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

      #from now on b:0 cannot be tested because it needs to be reset to the table
    end

    it "can destroy pawn when stepped on it" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:1")
      game_blue_start.activate_selected_pawn

      expect(game_blue_start.turn).to eq("player1")
      
      player1.last_roll = 1
      game_blue_start.move_selected_pawn

      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["b:1"], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], [], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )
      expect(game_blue_start.turn).to eq("player2")

      game_blue_start.override_turn("player4")
      player4.last_roll = 6
      game_blue_start.select_pawn("g:0")
      game_blue_start.activate_selected_pawn

      [1,2].each do
        game_blue_start.override_turn("player4")
        player4.last_roll = 6
        game_blue_start.move_selected_pawn
      end

      game_blue_start.override_turn("player4")
      player4.last_roll = 5
      game_blue_start.move_selected_pawn

      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["b:1"], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], [], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], ["g:0"], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], [], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )
      expect(game_blue_start.turn).to eq("player1")

      player1.last_roll = 2
      game_blue_start.select_pawn("b:1")
      game_blue_start.move_selected_pawn

      expect(player4.pawns[:"g:0"].pos).to eq([11, 11])
      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], [], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], ["b:1"], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )
      game_blue_start.destroy_pawns("b:1", [3, 6])
    end

    it "can activate 2 pawns at one position and destroy them" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:1")
      game_blue_start.activate_selected_pawn

      expect(game_blue_start.selected_pawn.pos).to eq([0, 6])
      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], ["b:1"], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], [], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )

      player1.last_roll = 6
      game_blue_start.select_pawn("b:3")
      game_blue_start.activate_selected_pawn

      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], ["b:1", "b:3"], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], [], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )
  
      game_blue_start.destroy_pawns("b:1", [0, 6])
      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], ["b:3"], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], ["b:1"], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )

      game_blue_start.destroy_pawns("b:3", [0, 6])
      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], ["b:1"], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )
      
    end

    it "can move 2 pawns to same position" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:1")
      game_blue_start.activate_selected_pawn

      player1.last_roll = 4
      game_blue_start.select_pawn("b:1")
      game_blue_start.move_selected_pawn

      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], [], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], ["b:1"], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )

      game_blue_start.override_turn("player1")
      player1.last_roll = 6
      game_blue_start.select_pawn("b:2")
      game_blue_start.activate_selected_pawn

      player1.last_roll = 4
      game_blue_start.select_pawn("b:2")
      game_blue_start.move_selected_pawn

      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], [], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], [], ["b:3"], [], []],
         [[], [], [], [], [], [], ["b:1", "b:2"], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )

      game_blue_start.destroy_pawns("b:1", [4, 6])
      game_blue_start.destroy_pawns("b:2", [4, 6])
    end

    it "can move the proper pawn when 2 pawns at one position" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:1")
      game_blue_start.activate_selected_pawn

      player1.last_roll = 6
      game_blue_start.select_pawn("b:3")
      game_blue_start.activate_selected_pawn

      player1.last_roll = 3
      game_blue_start.select_pawn("b:3")
      game_blue_start.move_selected_pawn

      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], ["b:1"], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], [], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], ["b:3"], [], [], [], [], ["b:2"], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )

      game_blue_start.destroy_pawns("b:1", [0, 4])
      game_blue_start.destroy_pawns("b:3", [4, 4])
    end

    it "can destroy 2 pawns when stepping on them" do
      player1.last_roll = 6
      game_blue_start.select_pawn("b:1")
      game_blue_start.activate_selected_pawn

      player1.last_roll = 6
      game_blue_start.select_pawn("b:3")
      game_blue_start.activate_selected_pawn

      game_blue_start.override_turn("player4")
      player4.last_roll = 6
      game_blue_start.select_pawn("g:1")
      game_blue_start.activate_selected_pawn

      [1, 2].each do
        player4.last_roll = 6
        game_blue_start.select_pawn("g:1")
        game_blue_start.move_selected_pawn
      end

      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], ["b:1", "b:3"], [], ["g:1"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], [], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], [], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )

      player4.last_roll = 2
      game_blue_start.select_pawn("g:1")
      game_blue_start.move_selected_pawn

      expect(game_blue_start.board).to eq(
        [[[], [], [], [], [], [], ["g:1"], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], ["b:1"], [], []],
         [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], [], [], []],
         [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
         [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
      )
    end
  end
end