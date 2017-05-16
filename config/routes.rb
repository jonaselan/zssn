Rails.application.routes.draw do
  scope 'api' do
    resources :survivors do
      collection do
        get ':id/report_infection' => 'survivors#report_infection'
      end
    end

    scope 'reports' do
      get 'avg_infected' => 'reports#avg_infected'
      get 'avg_non_infected' => 'reports#avg_non_infected'
      get 'avg_item_per_person' => 'reports#avg_item_per_person'
      get 'points_lost_infected' => 'reports#points_lost_infected'
    end

  end
end
