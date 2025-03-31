import "@hotwired/turbo-rails"

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