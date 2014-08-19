class CreateCalls < ActiveRecord::Migration
  def change
  create_table :calls do |t|
  		t.string :callsid
  		t.string :to
  		t.string :from
  		t.string :record
  	end
  end
end