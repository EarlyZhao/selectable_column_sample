

namespace :data_creation do
  desc "create test data"
  # 如果是 15号之前创建的，则月底就需要续费，如果是15号之后进行创建的，则次月底就需要进行续费（等于送了15号之后的几天时间）
  task :create_test_data => :environment do
    if User.count < 1
      User.create(name: '小王', digest: '小王digest', gender: '0', email: 'xiaowang@test.com', tel: '123456', born_date: Time.now)
      User.create(name: '小王爸', digest: '老王digest', gender: '0', email: 'laowang@test.com', tel: '123456', born_date: Time.now - 20.year)
      User.create(name: '小莉', digest: '小莉digest', gender: '1', email: 'xiaoli@test.com', tel: '123456', born_date: Time.now)
      User.create(name: '小莉爸', digest: '小莉爸digest', gender: '0', email: 'xiaolifa@test.com', tel: '123456', born_date: Time.now- 20.year)
      User.create(name: '小莉ma', digest: '小莉madigest', gender: '1', email: 'xiaolima@test.com', tel: '123456', born_date: Time.now- 20.year)
      User.create(name: '小王妈', digest: '小wangmadigest', gender: '0', email: 'xiaowangma@test.com', tel: '123456', born_date: Time.now- 20.year)
    end

    if Couple.count < 1
      xiaowang = User.find_by_name('小王')
      xiaoli = User.find_by_name('小莉')
      xiaowang.create_couple_male(wife_id: xiaoli.id)

      laowang = User.find_by_name('小王爸')
      xiaowangma = User.find_by_name('小王妈')
      laowang.create_couple_male(wife_id: xiaowangma.id)

      xiaoliba = User.find_by_name('小莉爸')
      xiaolima = User.find_by_name('小莉ma')
      xiaoliba.create_couple_male(wife_id: xiaolima.id)

      if Generation.count < 1
        Generation.create(child_id: xiaowang.id,parent_id: laowang.id,child_gender:  '0', parent_gender: '0')
        Generation.create(child_id: xiaowang.id,parent_id: xiaowangma.id,child_gender:  '0', parent_gender: '1')
        Generation.create(child_id: xiaoli.id,parent_id: xiaoliba.id, child_gender:  '1', parent_gender: '0')
        Generation.create(child_id: xiaoli.id,parent_id: xiaolima.id, child_gender:  '1', parent_gender: '1')
      end
    end

    if Organization.count < 1
      User.all.each do |user|
        Organization.create(name: user.name + '公司', digest: '公司摘要' + user.name , owner_id: user.id, industry: rand(10))
      end
    end

    if Introduction.count < 1
      User.all.each do |user|
        Introduction.create({user_id: user.id, description: user.name + '的详细介绍', digest: user.name + '的简要介绍'})
      end
    end

    if Product.count < 1
      Organization.all.each do |org|
        Product.create(name: org.name.to_s + 'House', organization_id: org.id, price: rand(1000),introduction: "#{org.name}产品介绍")
      end
    end
  end


end
