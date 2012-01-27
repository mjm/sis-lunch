class HasSecurePassword < ActiveRecord::Migration
  def up
    remove_column :people, :password
    add_column :people, :password_digest, :string
    
    Person.all.each do |u|
      u.password = "password"
      u.password_confirmation = "password"
      u.save
    end
  end

  def down
    remove_column :people, :password_digest
    add_column :people, :password, :string
  end
end
