class CreateSisGroup < ActiveRecord::Migration
  def up
    group = Group.create(name: "SIS")
    Person.all.each do |person|
      person.group = group
      person.save
    end
  end

  def down
    group = Group.find_by_name("SIS")
    if group
      Membership.destroy_all(group_id: group.id)
    end
  end
end
