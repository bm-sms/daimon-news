class PostCategoryValidator < ActiveModel::Validator
  def validate(record)
    category_ids = []
    record.categorizations.each do |categorization|
      category = Category.find(categorization.category_id)
      category_ids << categorization.category_id
      if category.has_children?
        record.errors[:categorizations] << "子カテゴリを持つカテゴリ「#{category.full_name}」に記事を登録することはできません。"
      end
    end
    unless category_ids.size == category_ids.uniq.size
      record.errors[:categorizations] << "同一カテゴリを複数選択することはできません。"
    end
  end
end
