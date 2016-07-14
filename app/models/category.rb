class Category < ActiveRecord::Base
  belongs_to :site
  has_many :posts

  has_ancestry
  acts_as_list scope: [:ancestry], column: :order

  validates :slug, format: /\A\w+\z/, uniqueness: {scope: :site_id}
  validates :order, numericality: {only_integer: true, allow_nil: true}

  scope :ordered, -> { order(:order) }
  # For PostgreSQL, doesn't work on MySQL
  # See https://github.com/stefankroes/ancestry/pull/238
  scope :leaves, -> { joins("LEFT JOIN #{quoted_table_name} AS c ON c.#{ancestry_column} = CAST(#{quoted_table_name}.id AS text) OR c.#{ancestry_column} = #{quoted_table_name}.#{ancestry_column} || '/' || #{quoted_table_name}.id").group("#{quoted_table_name}.id").having("COUNT(c.id) = 0").order("#{quoted_table_name}.#{ancestry_column} NULLS FIRST").order(:order) }
  scope :parental, ->(category = nil) { includes(:posts).where("posts.id" => nil).where.not(id: category&.id).order("#{quoted_table_name}.#{ancestry_column} NULLS FIRST").order(:order) }

  def full_name
    (ancestors.pluck(:name) + [name]).join("/")
  end

  # https://github.com/stefankroes/ancestry/wiki/awesome_nested_set-like-methods-for-scriptaculous-and-acts_as_list
  # Accepts the typical array of ids from a scriptaculous sortable. It is called on the instance being moved
  #
  # Not in use for now
  def sort(array_of_ids)
    if array_of_ids.first == id.to_s
      move_to_left_of(siblings.find(array_of_ids.second))
    else
      move_to_right_of(siblings.find(array_of_ids[array_of_ids.index(id.to_s) - 1]))
    end
  end

  def move_to_child_of(reference_instance)
    transaction do
      remove_from_list
      update_attributes!(parent: reference_instance)
      add_to_list_bottom
      save!
    end
  end

  def move_to_left_of(reference_instance)
    transaction do
      remove_from_list
      reference_instance.reload # Things have possibly changed in this list
      update_attributes!(parent_id: reference_instance.parent_id)
      reference_item_order = reference_instance.order
      increment_positions_on_lower_items(reference_item_order)
      update_attribute(:order, reference_item_order)
    end
  end

  def move_to_right_of(reference_instance)
    transaction do
      remove_from_list
      reference_instance.reload # Things have possibly changed in this list
      update_attributes!(parent_id: reference_instance.parent_id)
      if reference_instance.lower_item
        lower_item_order = reference_instance.lower_item.order
        increment_positions_on_lower_items(lower_item_order)
        update_attribute(:order, lower_item_order)
      else
        add_to_list_bottom
        save!
      end
    end
  end

  def move_to(reference_instance, direction:)
    case direction.to_sym
    when :child
      move_to_child_of(reference_instance)
    when :left
      move_to_left_of(reference_instance)
    when :right
      move_to_right_of(reference_instance)
    else
      raise "Unknown direction: #{direction}"
    end
  end
end
