require 'rails_helper'

RSpec.describe Survivor, type: :model do
  describe "Associations" do
    it{ is_expected.to have_one :inventory }
    it{ is_expected.to have_many(:inventory_resources).through(:inventory) }
  end

  it 'have one age related' do
    is_expected.to validate_presence_of(:age)
  end
  it 'have latitude localization related' do
    is_expected.to validate_presence_of(:latitude)
  end
  it 'have longitude localization related' do
    is_expected.to validate_presence_of(:longitude)
  end
  it 'have one gender related' do
    is_expected.to validate_presence_of(:gender)
  end

  it 'with 3 infection count is mark as infected' do
    survivor = build(:survivor, infection_occurrences: 2)
    survivor.report_infection
    expect(survivor.infected).to eq true
  end

  context 'is valid' do
    it 'has a valid factory' do
      expect(build(:survivor)).to be_valid
    end
  end

  context "is invalid" do
    # TODO: without inventory
    it "with a duplicate name" do
      create(:survivor,
        name: 'Zé'
      )
      survivor = build(
        :survivor, name: 'Zé'
      )
      survivor.valid?
      expect(survivor.errors[:name]).to include("has already been taken")
    end
  end
end
