class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string  :name
      t.string  :brand
      t.integer :units
      t.string  :vendor
      t.integer :price
      t.jsonb    :extra, index: true

      t.timestamps
    end
    add_index :products, :created_at, name: "index_products_on_created_at"
    add_index :products, "(extra->>'color')", name: "index_products_on_extra_color"
    add_index :products, "(extra->>'material')", name: "index_products_on_extra_material"
    add_index :products,"(extra->>'weight')", name: "index_products_on_extra_weight"
    add_index :products, "(extra->>'description')", name: "index_products_on_extra_description"
    add_index :products, "(extra->>'width')",name: "index_products_on_extra_width"
    add_index :products, "(extra->>'length')", name: "index_products_on_extra_length"
    add_index :products, "(extra->>'height')", name: "index_products_on_extra_height"

  end
end
