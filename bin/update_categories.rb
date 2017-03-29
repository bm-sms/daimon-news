require 'csv'
require 'open-uri'

def detect_category_by_slug(site, slug)
  site.categories.detect {|category| category.slug == slug }
end

def find_category_by_name(site, name)
  site.categories.detect {|category| category.name == name } || raise("Missing category: Category#name=#{name}")
end

def find_post(site, public_id)
  site.posts.detect {|post| post.public_id == Integer(public_id) } || raise("Missing post: Post#public_id=#{public_id.inspect}")
end

def assert_categorization(site)
  posts_has_no_categories = site.posts.preload(:categories).select {|post| post.categories[0].nil? }

  raise "Missing category: Post#id=(#{posts_has_no_categories.map(&:id).join(', ')})" if posts_has_no_categories.present?
end

site = Site.find_by!(fqdn: ENV['SITE_FQDN'])

Site.transaction do
  slugs = CSV.foreach(open(ENV.fetch('PATH_TO_CATEGORIES_CSV')), headers: true).flat_map do |row|
    [row['親カテゴリスラッグ'], row['子カテゴリスラッグ'], row['孫カテゴリスラッグ']]
  end

  unused_slugs = site.categories.where.not(slug: slugs.compact).pluck(:slug)

  parent_category_slug = nil
  child_category_slug  = nil

  parent_category_order = 0

  migration_rule = {
    'othersothers'     => 'health_and_beauty',
    'othersmedically'  => 'news',
    'othersmanagement' => 'news',
    'othersclinical'   => 'news'
  }.map {|old_slug, new_slug|
    [new_slug, detect_category_by_slug(site, old_slug).posts.ids]
  }

  site.categories.update_all order: nil # order のユニーク制約を回避する

  CSV.foreach(open(ENV.fetch('PATH_TO_CATEGORIES_CSV')), headers: true).with_index do |row, i|
    if row['親カテゴリスラッグ']
      parent_category_slug = row['親カテゴリスラッグ']
      child_category_slug  = nil # 一旦リセット
      parent_category_order += 1
    end

    parent_category =
      detect_category_by_slug(site, parent_category_slug) || site.categories.create!(
        slug: parent_category_slug
      )

    if row['親カテゴリ']
      parent_category.update!(
        name: row['親カテゴリ'],
        description: "「#{row['親カテゴリ']}」の記事一覧です。看護のお仕事にすぐに役立つ情報をお届けします。",
        order: parent_category_order
      )
    end

    if row['子カテゴリスラッグ']
      child_category_slug = row['子カテゴリスラッグ']
    end

    if child_category_slug.present?
      child_category =
        detect_category_by_slug(site, child_category_slug) || site.categories.create!(
          slug: child_category_slug,
        )

      if row['子カテゴリ']
        child_category.update!(
          name: row['子カテゴリ'],
          description: "「#{row['子カテゴリ']}」の記事一覧です。看護のお仕事にすぐに役立つ情報をお届けします。",
          parent: parent_category
        )
      end

      if row['孫カテゴリスラッグ']
        grandchild_category =
          detect_category_by_slug(site, row['孫カテゴリスラッグ']) || site.categories.create!(
            slug: row['孫カテゴリスラッグ'],
          )

        if row['孫カテゴリ']
          grandchild_category.update!(
            name: row['孫カテゴリ'],
            description: "「#{row['孫カテゴリ']}」の記事一覧です。看護のお仕事にすぐに役立つ情報をお届けします。",
            parent: child_category
          )
        end
      end
    end
  end

  site.categories.where(slug: unused_slugs).destroy_all

  CSV.foreach(open(ENV.fetch('PATH_TO_POSTS_CSV')), headers: true) do |row|
    post = find_post(site, row['public_id'])

    post.categorizations.delete_all

    categories = []
    categories << find_category_by_name(site, row['カテゴリ1']) if row['カテゴリ1']
    categories << find_category_by_name(site, row['カテゴリ2']) if row['カテゴリ2']
    categories << find_category_by_name(site, row['カテゴリ3']) if row['カテゴリ3']

    categories.each.with_index do |category, index|
      post.categorizations.create!(
        category: category,
        order: index
      )
    end
  end

  migration_rule.each do |new_slug, post_ids|
    site.posts.where(id: post_ids).each do |post|
      unless post.categorizations.exists?
        post.categorizations.create!(
          category: detect_category_by_slug(site, new_slug),
          order: 0
        )
      end
    end
  end

  assert_categorization site
end
