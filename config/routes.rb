Rails.application.routes.draw do
  scope 'api' do
    resources :survivors do
      collection do
        get ':id/report_infection' => 'survivors#report_infection'
      end
    end
  end
end
