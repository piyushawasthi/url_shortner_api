class CreateShortVisits < ActiveRecord::Migration
  def change
    create_table :short_visits do |t|
      t.integer :short_url_id
      t.string :visitor_ip
      t.string :visitor_city
      t.string :visitor_state
      t.string :visitor_country_iso2
      t.string :visitor_country

      t.timestamps null: false
    end
  end
end
