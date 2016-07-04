class Category < ActiveRecord::Base
  belongs_to :site
  has_many :posts

  has_ancestry

  validates :slug, format: /\A\w+\z/, uniqueness: {scope: :site_id}
  validates :order, numericality: :only_integer

  scope :ordered, -> { order(:order) }

  # https://github.com/stefankroes/ancestry/wiki/awesome_nested_set-like-methods-for-scriptaculous-and-acts_as_list
  # Accepts the typical array of ids from a scriptaculous sortable. It is called on the instance being moved
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
      self.update_attributes!(:parent => reference_instance)
      add_to_list_bottom
      save!
    end
  end

  def move_to_left_of(reference_instance)
    transaction do
      remove_from_list
      reference_instance.reload # Things have possibly changed in this list
      self.update_attributes!(:parent_id => reference_instance.parent_id)
      reference_item_order = reference_instance.order
      increment_orders_on_lower_items(reference_item_order)
      self.update_attribute(:order, reference_item_order)
    end
  end

  def move_to_right_of(reference_instance)
    transaction do
      remove_from_list
      reference_instance.reload # Things have possibly changed in this list
      self.update_attributes!(:parent_id => reference_instance.parent_id)
      if reference_instance.lower_item
        lower_item_order = reference_instance.lower_item.order
        increment_orders_on_lower_items(lower_item_order)
        self.update_attribute(:order, lower_item_order)
      else
        add_to_list_bottom
        save!
      end
    end   
  end  
end
