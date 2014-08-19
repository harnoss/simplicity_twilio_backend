class CreateMessages < ActiveRecord::Migration
  def change
  	create_table :messages do |t|
  		t.string :messagesid
  		t.string :to
  		t.string :from
  		t.string :text
  	end
  end
end
