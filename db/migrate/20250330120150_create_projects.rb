class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :code
      t.string :secret

      t.timestamps
    end
    add_index :projects, :code, unique: true
  end
end
