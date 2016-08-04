class PostCategoryValidator < ActiveModel::Validator
  def validate(record)
    record.categorizations.each do |c|
      category = Category.find(c.category_id)
      if category.has_children?
        record.errors[:categorizations] << "子カテゴリを持つカテゴリ「#{category.full_name}」に記事を登録することはできません。"
      end
    end
  end
end
