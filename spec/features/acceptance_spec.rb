
feature "Homepage" do
  scenario "logged out user sees contacts" do
    visit "/"

    expect(page).to have_content("Contacts")
  end
end

feature "Login page" do
  scenario "logged out user clicks login link and sees login form" do
    visit "/"

    click_link("Login")
    expect(page).to have_content("username")
    expect(page).to have_content("password")
  end
end

feature "Login page" do
  scenario "log in and redirect to homepage, see welcome" do
  visit "/login"

  click_link("Login")
  expect(page).to have_content("Welcome")
  end
end