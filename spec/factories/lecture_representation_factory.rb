FactoryGirl.define do
  factory :lecture_representation, class: Hash do
    sequence("links") do |n|
      [{"rel"=>"space", "href"=>"http://www.redu.com.br/api/spaces/1412"},
       {"rel"=>"course", "href"=>"http://www.redu.com.br/api/courses/curso-de-exemplo"},
       {"rel"=>"previous_lecture", "href"=>"http://www.redu.com.br/api/lectures/5607-25"},
       {"rel"=>"environment", "href"=>"http://www.redu.com.br/api/environments/ambiente-de-exemplo-api"},
       {"rel"=>"self", "href"=>"http://www.redu.com.br/api/lectures/#{n}"},
       {"rel"=>"subject", "href"=>"http://www.redu.com.br/api/subjects/3464"},
       {"rel"=>"self_link", "href"=>"http://www.redu.com.br/espacos/1412/modulos/3464/aulas/5608-25"}]
    end

    initialize_with { attributes.with_indifferent_access }
  end
end
