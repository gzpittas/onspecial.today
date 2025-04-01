import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false

// Simple text selection function
function selectAllText(input) {
  // Focus the input first
  input.focus();
  
  // Try multiple methods to ensure selection
  setTimeout(() => {
    input.select();
    input.setSelectionRange(0, input.value.length);
  }, 10);
}

// Setup for cash price field
function setupCashPriceField() {
  const cashInput = document.getElementById('cash-price-input');
  if (!cashInput) return;

  // Remove any existing listeners to prevent duplicates
  cashInput.removeEventListener('focus', handleFocus);
  cashInput.removeEventListener('click', handleClick);
  cashInput.removeEventListener('touchstart', handleTouch);

  // Add new listeners
  cashInput.addEventListener('focus', handleFocus);
  cashInput.addEventListener('click', handleClick);
  cashInput.addEventListener('touchstart', handleTouch);

  function handleFocus() {
    selectAllText(this);
  }

  function handleClick() {
    selectAllText(this);
  }

  function handleTouch() {
    selectAllText(this);
  }

  // If field is already focused when page loads
  if (document.activeElement === cashInput) {
    selectAllText(cashInput);
  }
}

// Price calculation logic
function setupPriceCalculation() {
  const cashInput = document.getElementById('cash-price-input');
  const creditDisplay = document.getElementById('credit-price-display');
  const creditField = document.getElementById('credit-price-field');

  if (cashInput && creditDisplay && creditField) {
    const calculateCreditPrice = () => {
      const cashValue = parseFloat(cashInput.value.replace(/[^\d.-]/g, '')) || 0;
      const creditValue = cashValue / 0.97;
      creditDisplay.value = new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
      }).format(creditValue);
      creditField.value = creditValue.toFixed(2);
    };

    cashInput.addEventListener('input', calculateCreditPrice);
    
    // Initial calculation
    if (cashInput.value) {
      calculateCreditPrice();
    }
  }
}

// Initialize everything
function initializeAll() {
  setupCashPriceField();
  setupPriceCalculation();
}

// Set up event listeners
document.addEventListener('turbo:load', initializeAll);
document.addEventListener('turbo:render', initializeAll);
document.addEventListener('DOMContentLoaded', initializeAll);

// Run immediately if page is already loaded
if (document.readyState === 'complete') {
  initializeAll();
}


// Enable drag-and-drop sorting
document.addEventListener('DOMContentLoaded', function() {
  const sortable = new Sortable(document.querySelector('.menu-items-container'), {
    handle: '.menu-item',
    animation: 150,
    onEnd: function(evt) {
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
});


function addItemToMenu(itemId, categoryId) {

  const menuCategory = window.menuCategories.find(c => c.category_id == categoryId);

  const payload = {
    menu_item: {
      menu_id: <%= @menu.id %>,
      item_id: itemId,
      menu_category_id: categoryId // This should be the Category ID, not MenuCategory ID
    }
  };

  fetch('/menu_items', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    },
    body: JSON.stringify(payload)
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      window.location.reload();
    } else {
      alert('Error: ' + (data.errors || data.error));
    }
  })
  .catch(error => {
    console.error('Error:', error);
    alert('Failed to add item');
  });
}



// When loading the menu show page:
fetch(`/menus/<%= @menu.id %>/categories`)
  .then(response => response.json())
  .then(categories => {
    window.menuCategories = categories; // Store for later use
  });

// Force page reload after deletion
document.addEventListener('turbo:before-fetch-response', function(event) {
  const response = event.detail.fetchResponse;
  if (event.detail.fetchOptions.method === 'DELETE') {
    if (response.succeeded) {
      window.location.href = response.headers.get('Turbo-Location') || window.location.href;
    }
  }
});

// Handle delete links if Turbo is still interfering
document.addEventListener('click', function(event) {
  if (event.target.closest('a[data-method="delete"]')) {
    event.preventDefault();
    const link = event.target.closest('a');
    if (confirm(link.dataset.confirm)) {
      fetch(link.href, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'text/html'  // Force HTML response
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

// app/javascript/application.js
document.addEventListener('DOMContentLoaded', function() {
  // Handle delete buttons
  document.addEventListener('ajax:success', function(event) {
    const [data, status, xhr] = event.detail;
    if (xhr.getResponseHeader('Content-Type').includes('text/html')) {
      window.location.href = xhr.responseURL;
    }
  });

  document.addEventListener('ajax:error', function(event) {
    console.error('Delete failed:', event.detail);
    alert('Failed to delete item');
  });
});
