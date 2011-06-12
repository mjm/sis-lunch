class IpAddresses < ActiveRecord::Migration
  def change
    add_column :people, :signup_ip, :string
    add_column :people, :login_ip, :string
  end
end
