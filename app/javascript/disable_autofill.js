// app/javascript/disable_autofill.js
document.addEventListener('turbo:load', function() {
  // Randomize form field names on page load
  document.querySelectorAll('form.edit-item-form input, form.edit-item-form textarea').forEach(input => {
    if (!input.id.includes('_attributes_')) { // Skip nested attributes
      const randomString = Math.random().toString(36).substring(2, 8);
      input.setAttribute('name', `${input.name}_${randomString}`);
      input.setAttribute('autocomplete', `new-${randomString}`);
    }
  });
});