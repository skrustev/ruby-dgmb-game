require 'rspec/its'
require 'pawn'

describe 'Pawn' do
  subject(:pawn) { Pawn.new("name", "player", [7,6]) }

  its(:name) { should eq("name")}
  its(:player_name) { should eq("player") }
  its(:pos) { should eq([7,6])}
  its(:path_pos) { should eq(-1) }
  its(:initial_pos) {should eq([7,6]) }
  its(:is_active) { should eq(false) }
  its(:is_finished) { should eq(false) }
  its(:can_be_moved) { should eq(false) }

  it "can be activated " do
    pawn.activate([1,3])

    expect(pawn.pos).to eq([1,3])
    expect(pawn.path_pos).to eq(0)
    expect(pawn.player_name).to eq("player")
    expect(pawn.initial_pos).to eq([7,6])
    expect(pawn.is_active).to eq(true)
    expect(pawn.is_finished).to eq(false)
    expect(pawn.can_be_moved).to eq(true)
  end

  it "can be moved" do
    pawn.activate([0,4])
    pawn.move(5, [4,3])
    
    expect(pawn.pos).to eq([4,3])
    expect(pawn.path_pos).to eq(5)
    expect(pawn.player_name).to eq("player")
    expect(pawn.initial_pos).to eq([7,6])
    expect(pawn.is_active).to eq(true)
    expect(pawn.is_finished).to eq(false)
    expect(pawn.can_be_moved).to eq(true)
  end

  it "can be destroyed" do
    pawn.activate([0,4])
    pawn.move(4, [4,4])
    pawn.destroy
    
    expect(pawn.pos).to eq(pawn.initial_pos)
    expect(pawn.path_pos).to eq(-1)
    expect(pawn.is_active).to eq(false)
    expect(pawn.can_be_moved).to eq(false)
  end

  it "can finish" do
    pawn.activate([0,5])
    pawn.move(1, [1, 5])
    pawn.destroy
    pawn.finish

    expect(pawn.pos).to eq([-1, -1])
    expect(pawn.path_pos).to eq(-1)
    expect(pawn.player_name).to eq("player")
    expect(pawn.initial_pos).to eq([7,6])
    expect(pawn.is_active).to eq(false)
    expect(pawn.is_finished).to eq(true)
    expect(pawn.can_be_moved).to eq(false)
  end
end 