import { Turbo } from "@hotwired/turbo-rails"
import Sortable from 'sortablejs';

// Disable Turbo Drive for this page
Turbo.session.drive = false;

// Utility Functions
const Utils = {
  selectAllText: (input) => {
    input.focus();
    setTimeout(() => {
      input.select();
      input.setSelectionRange(0, input.value.length);
    }, 10);
  },

  debounce: (func, wait) => {
    let timeout;
    return function() {
      const context = this, args = arguments;
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(context, args), wait);
    };
  },

  escapeHtml: (unsafe) => {
    return unsafe
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  },

  formatCurrency: (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount);
  }
};

// Price Calculation Module
const PriceCalculator = {
  init: () => {
    const cashInput = document.getElementById('cash-price-input');
    const creditDisplay = document.getElementById('credit-price-display');
    const creditField = document.getElementById('credit-price-field');

    if (cashInput && creditDisplay && creditField) {
      const calculateCreditPrice = () => {
        const cashValue = parseFloat(cashInput.value.replace(/[^\d.-]/g, '')) || 0;
        const creditValue = cashValue / 0.97;
        creditDisplay.value = Utils.formatCurrency(creditValue);
        creditField.value = creditValue.toFixed(2);
      };

      cashInput.addEventListener('input', calculateCreditPrice);
      
      // Initial calculation
      if (cashInput.value) {
        calculateCreditPrice();
      }
    }
  }
};

// Text Selection Module
const TextSelection = {
  init: () => {
    const cashInput = document.getElementById('cash-price-input');
    if (!cashInput) return;

    const handleSelection = () => Utils.selectAllText(cashInput);

    // Remove existing listeners to prevent duplicates
    cashInput.removeEventListener('focus', handleSelection);
    cashInput.removeEventListener('click', handleSelection);
    cashInput.removeEventListener('touchstart', handleSelection);

    // Add new listeners
    cashInput.addEventListener('focus', handleSelection);
    cashInput.addEventListener('click', handleSelection);
    cashInput.addEventListener('touchstart', handleSelection);

    // If field is already focused when page loads
    if (document.activeElement === cashInput) {
      Utils.selectAllText(cashInput);
    }
  }
};

// Drag and Drop Module
const DragAndDrop = {
  init: () => {
    const container = document.querySelector('.menu-items-container');
    if (!container) return;

    new Sortable(container, {
      handle: '.menu-item',
      animation: 150,
      onEnd: (evt) => {
        const itemId = evt.item.dataset.id;
        const newPosition = evt.newIndex + 1;
        
        fetch(`/menu_items/${itemId}/update_position`, {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({ position: newPosition })
        });
      }
    });
  }
};

// Item Search Module
const ItemSearch = {
  init: () => {
    const searchInput = document.getElementById('itemSearch');
    const searchResults = document.getElementById('searchResults');
    if (!searchInput || !searchResults) return;

    searchInput.addEventListener('input', Utils.debounce(() => {
      ItemSearch.performSearch(searchInput.value.trim());
    }, 300));
  },

  performSearch: (query) => {
    const searchResults = document.getElementById('searchResults');
    
    if (query.length < 3) {
      searchResults.innerHTML = '<div class="p-2 text-muted">Type at least 3 characters</div>';
      return;
    }

    searchResults.innerHTML = '<div class="p-2 text-muted">Searching...</div>';

    fetch(`/items/search?q=${encodeURIComponent(query)}`)
      .then(response => {
        if (!response.ok) throw new Error('Network response was not ok');
        return response.json();
      })
      .then(data => {
        if (data.error) throw new Error(data.error);
        ItemSearch.displayResults(data.items || []);
      })
      .catch(error => {
        console.error('Search error:', error);
        searchResults.innerHTML = `<div class="p-2 text-danger">Error: ${error.message}</div>`;
      });
  },

  displayResults: (items) => {
    const searchResults = document.getElementById('searchResults');
    
    if (items.length === 0) {
      searchResults.innerHTML = '<div class="p-2 text-muted">No items found</div>';
      return;
    }

    searchResults.innerHTML = '';
    items.forEach(item => {
      const result = document.createElement('div');
      result.className = 'search-result p-2 border-bottom';
      result.innerHTML = `
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <strong>${Utils.escapeHtml(item.name)}</strong>
            <div class="text-muted small">
              ${item.description ? Utils.escapeHtml(item.description) + '. ' : ''}
              $${parseFloat(item.credit_price || 0).toFixed(2)}
              ($${parseFloat(item.cash_price || 0).toFixed(2)})
            </div>
          </div>
          <button class="btn btn-sm btn-primary add-item-btn"
                  data-item-id="${item.id}"
                  data-category-id="${item.category_id}">
            Add
          </button>
        </div>
      `;
      searchResults.appendChild(result);

      result.querySelector('.add-item-btn').addEventListener('click', () => {
        MenuItems.addItemToMenu(item.id, item.category_id);
      });
    });
  }
};

// Menu Items Module
const MenuItems = {
  init: () => {
    // Load categories when page loads
    fetch(`/menus/${document.body.dataset.menuId}/categories`)
      .then(response => response.json())
      .then(categories => {
        window.menuCategories = categories;
      });

    // Set up delete handlers
    MenuItems.setupDeleteHandlers();
  },

  addItemToMenu: (itemId, categoryId) => {
    const menuId = document.body.dataset.menuId;
    
    fetch('/menu_items', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        menu_item: {
          menu_id: menuId,
          item_id: itemId,
          menu_category_id: categoryId
        }
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        const categorySection = document.querySelector(`#category-${categoryId}`);
        if (categorySection) {
          categorySection.insertAdjacentHTML('beforeend', data.html);
        } else {
          window.location.reload();
        }
      } else {
        alert('Error: ' + (data.errors || data.error));
      }
    })
    .catch(error => {
      console.error('Error:', error);
      alert('Failed to add item');
    });
  },

  setupDeleteHandlers: () => {
    // Handle delete links
    document.addEventListener('click', (event) => {
      if (event.target.closest('a[data-method="delete"]')) {
        event.preventDefault();
        const link = event.target.closest('a');
        if (confirm(link.dataset.confirm)) {
          fetch(link.href, {
            method: 'DELETE',
            headers: {
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
              'Accept': 'text/html'
            },
            credentials: 'same-origin'
          }).then(response => {
            if (response.redirected) {
              window.location.href = response.url;
            }
          });
        }
      }
    });

    // Handle Turbo delete events
    document.addEventListener('turbo:before-fetch-response', (event) => {
      const response = event.detail.fetchResponse;
      if (event.detail.fetchOptions.method === 'DELETE') {
        if (response.succeeded) {
          window.location.href = response.headers.get('Turbo-Location') || window.location.href;
        }
      }
    });
  }
};

// Main Initialization
const initializeAll = () => {
  TextSelection.init();
  PriceCalculator.init();
  DragAndDrop.init();
  ItemSearch.init();
  MenuItems.init();
};

// Set up event listeners
document.addEventListener('turbo:load', initializeAll);
document.addEventListener('turbo:render', initializeAll);
document.addEventListener('DOMContentLoaded', initializeAll);

// Run immediately if page is already loaded
if (document.readyState === 'complete') {
  initializeAll();
}