# frozen_string_literal: true

Then "I should not see any plans" do
  within plans_table do
    page.should have_css('tbody tr', size: 0)
  end
end

Then "I should see a {published} plan {string}" do |published, name|
  within plans_table do
    assert table_row_with_cells?(name, published ? 'published' : 'hidden')
  end
end

Then "I {should} see plan {string}" do |visible, name|
  within plans_table do
    method = visible ? :have_css : :have_no_css
    page.should send(method, 'td', text: name)
  end
end

When "I follow {string} for {plan}" do |label, plan|
  step %(I follow "#{label}" within "##{dom_id(plan)}")
end

When "I select {string} as default plan" do |plan|
  # TODO: use #pf4_select ?
  select = default_plan_select
  select.find(:css, '.pf-c-button.pf-c-select__toggle-button').click unless select[:class].include?('pf-m-expanded')
  select.find('.pf-c-select__menu-item', text: plan).click
end

Then "I should see {string} in the default plans list" do |plan_name|
  select = default_plan_select
  select.find(:css, '.pf-c-button.pf-c-select__toggle-button').click unless select[:class].include?('pf-m-expanded')
  select.should have_content(plan_name)
end

def plans_table
  if page.has_css?('#plans_table .pf-c-table')
    find('#plans_table .pf-c-table')
  else
    ThreeScale::Deprecation.warn "Detected outdated plans list, pending migration to PF4 React"
    find(:css, '#plans')
  end
end

def default_plan_select
  find(:css, '#default_plan_card .pf-c-select')
end

def new_application_plan_form
  find(:css, '#new_application_plan')
end

When "the provider creates a plan" do
  name = SecureRandom.hex(10)

  step 'I go to the application plans admin page'
  click_on 'Create Application plan'

  within new_application_plan_form do
    fill_in 'Name', with: name
    fill_in 'System name', with: name

    click_on 'Create Application Plan'
  end

  page.should have_content("Created Application plan #{name}")

  @plan = Plan.find_by!(name: name)
end

When "{plan} has been deleted" do |plan|
  plan.destroy
end
