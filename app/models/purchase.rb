class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :user

  scope :created_start, lambda {|start_date| where("created_at >= ?", start_date )}
  scope :created_end, lambda {|end_date| where("created_at <= ?", end_date )}
  scope :by_units, lambda {|units| where("units >= ?", units)}
  scope :by_amount, lambda {|amount| where("amount >= ?", amount)}
  scope :by_buyer, lambda {|buyer| where("buyer_name ilike '%#{buyer}%'")}
  scope :by_product, lambda {|product| where("products.name ilike '%?%'", product)}
  scope :by_product_color, lambda {|color| joins(product: :category).where("products.extra->>'color' = ?", color)}
  scope :by_product_material, lambda {|material| joins(product: :category).where("products.extra->>'material' ilike '%#{material}%'")}
  scope :by_product_weigth, lambda {|weigth| joins(product: :category).where("products.extra->>'weigth' > ?", weigth)}
  
  @granularity = ["minute", "hour", "day", "week", "month", "year"]

  def self.purchases_filter(filters = {})

    response = Purchase.includes(product: :category).all

    response = response.by_units(filters[:units]) if filters[:units].present?

    response = response.by_amount(filters[:amount]) if filters[:amount].present?
    
    response = response.by_buyer(filters[:buyer]) if filters[:buyer].present?

    response = response.by_product_color(filters[:color]) if filters[:color].present?

    response = response.by_product_material(filters[:material]) if filters[:material].present?

    response = response.by_product_weigth(filters[:weight]) if filters[:weight].present?

    response = response.by_product(filters[:product]) if filters[:product].present?

    response = response.created_start(filters[:start_date]) if filters[:start_date].present?

    response = response.created_end(filters[:end_date]) if filters[:end_date].present?

    response = response.paginate({ page: filters[:page] ? filters[:page] : 1, per_page: filters[:per_page] ? filters[:per_page] : 10  }) if filters[:per_page].present? || filters[:page].present?

    response
  end

  def self.top(type = 'units')
    clean_top_response(
      ActiveRecord::Base.connection.exec_query(
        "SELECT category_name, product_name, sales
        FROM (
          SELECT products_sales.id product_id, products_sales.product product_name,
          MAX(category) category_name,	 
          SUM(purchases.#{type}) sales,
          ROW_NUMBER() OVER 
          (
            PARTITION BY MAX(category)ORDER BY SUM(purchases.#{type}) DESC
          ) top 
          FROM purchases 
          INNER JOIN (
            SELECT products.id, categories.name as category, products.name as product, purchases.units as sales 
            FROM products 
            INNER JOIN categories_products ON categories_products.product_id = products.id 
            INNER JOIN categories ON categories.id = categories_products.category_id
            INNER JOIN purchases ON purchases.product_id = products.id
          ) products_sales ON products_sales.id = purchases.product_id 
          GROUP BY products_sales.id, products_sales.product
        ) t
        WHERE top <= 3
        ORDER BY category_name ASC, sales DESC"
      ).to_a
    )
  end

  def self.graphic(granularity)
    return { error: 'Granularity is invalid (minute, hour, day, week, month or year)' } if !@granularity.include?(granularity)
    Purchase.select("date_trunc('#{granularity}', created_at) as date, sum(amount) as amount, sum(units) as units").group("date")
  end

  private

  def self.clean_top_response(result)
    return unless result.present? && result.length > 0
    response = {}
    result.each do |item|
      if(!response[item["category_name"]].present?)
        response[item["category_name"]] = []
      end
        response[item["category_name"]] << { "product_name" => item["product_name"], "sales" => item["sales"] }
    end
    response
  end
end
