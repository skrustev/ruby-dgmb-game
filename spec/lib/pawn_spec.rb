require 'rspec/its'
require 'pawn'

describe 'Pawn' do
  subject(:pawn) { Pawn.new("name", "player", "7:6") }

  its(:name) { should eq("name")}
  its(:player_name) { should eq("player") }
  its(:pos) { should eq("7:6")}
  its(:original_pos) {should eq("7:6") }
  its(:is_active) { should eq(false) }
  its(:is_finished) { should eq(false) }
  its(:can_be_moved) { should eq(false) }

  it "can be activated " do
    pawn.activate("1:3")

    expect(pawn.pos).to eq("1:3")
    expect(pawn.player_name).to eq("player")
    expect(pawn.original_pos).to eq("7:6")
    expect(pawn.is_active).to eq(true)
    expect(pawn.is_finished).to eq(false)
    expect(pawn.can_be_moved).to eq(true)
  end

  it "can be moved" do
    pawn.activate("1:3")
    pawn.move("4:5")
    
    expect(pawn.pos).to eq("4:5")
    expect(pawn.player_name).to eq("player")
    expect(pawn.original_pos).to eq("7:6")
    expect(pawn.is_active).to eq(true)
    expect(pawn.is_finished).to eq(false)
    expect(pawn.can_be_moved).to eq(true)
  end

  it "can be destroyed" do
    pawn.activate("1:3")
    pawn.move("4:5")
    pawn.destroy
    
    expect(pawn.pos).to eq(pawn.original_pos)
    expect(pawn.is_active).to eq(false)
    expect(pawn.can_be_moved).to eq(false)
  end

  it "can finish" do
    pawn.activate("1:3")
    pawn.move("4:5")
    pawn.destroy
    pawn.finish("5:5")

    expect(pawn.pos).to eq("5:5")
    expect(pawn.player_name).to eq("player")
    expect(pawn.original_pos).to eq("7:6")
    expect(pawn.is_active).to eq(false)
    expect(pawn.is_finished).to eq(true)
    expect(pawn.can_be_moved).to eq(false)
  end
end 