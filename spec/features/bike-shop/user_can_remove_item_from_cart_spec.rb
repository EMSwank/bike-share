require "rails_helper"

describe 'a visitor' do
  describe 'visiting the bike shop cart' do
    it 'can edit what and how much is in the cart' do
      item_1 = Item.create(title: "Goldfish", description: 'Whoopity scoop', image: 'http://via.placeholder.com/100x100', price: 400, status: 1)
      item_2 = Item.create(title: "Boldfish", description: 'Whoopity doop', image: 'http://via.placeholder.com/100x100', price: 400, status: 1)

      visit "/bike-shop"

      within "#item-#{item_1.id}" do
        click_button('Add to Cart')
      end
      within "#item-#{item_2.id}" do
        click_button('Add to Cart')
      end

      click_on "Cart: "

      within "#item-#{item_1.id}" do
        click_button('Remove')
      end

      expect(page).to_not have_content(item_1.title)
      expect(page).to have_content(item_2.title)

      within "#item-#{item_2.id}" do
        click_button('+')
      end

      within "##{item_2.id}-quantity" do
        expect(page).to have_content(2)
      end

      within "#item-#{item_2.id}" do
        click_button('-')
      end

      within "##{item_2.id}-quantity" do
        expect(page).to have_content(1)
      end
    end
  end
end