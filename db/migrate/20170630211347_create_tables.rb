class CreateTables < ActiveRecord::Migration[5.1]

  def change
    create_table :users do |t|
      t.text :name
      t.text :email
      t.text :password_digest
    end

    create_table :ingredients do |t|
      t.text :name
    end

    create_table :recipes do |t|
      t.text :name
      t.text :difficulty
      t.text :instructions
      t.integer :cook_time
      t.integer :user_id
    end

    create_table :user_ingredients do |t|
      t.integer :user_id
      t.integer :ingredient_id
    end

    create_table :recipe_ingredients do |t|
      t.integer :recipe_id
      t.integer :ingredient_id
    end
  end

end
