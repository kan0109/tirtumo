# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Tag.create([
             { tag_type: '食事' },
             { tag_type: '交通' },
             { tag_type: '日用品' },
             { tag_type: 'スマホ' },
             { tag_type: '水道' },
             { tag_type: '電気' },
             { tag_type: 'ガス' },
             { tag_type: '生活' },
             { tag_type: '衣服' },
             { tag_type: '趣味' },
             { tag_type: '医療' },
             { tag_type: '税金' },
             { tag_type: '自動車' },
             { tag_type: '育児' },
             { tag_type: '子供' },
             { tag_type: 'レジャー' },
             { tag_type: '裏技' }
           ])
