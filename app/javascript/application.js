function initializeItemSearch(searchInputId, resultsContainerId, itemsData) {
  const searchInput = document.getElementById(searchInputId);
  const searchResults = document.getElementById(resultsContainerId);

  if (!searchInput || !searchResults) return;

  function highlightText(text, searchTerm) {
    if (!searchTerm) return text;
    const regex = new RegExp(searchTerm, 'gi');
    return text.replace(regex, match => `<span class="highlight">${match}</span>`);
  }

  function showSearchResults(results, searchTerm) {
    searchResults.innerHTML = '';
    
    if (results.length === 0) {
      const noResults = document.createElement('div');
      noResults.className = 'search-result-item';
      noResults.textContent = 'No items found';
      searchResults.appendChild(noResults);
    } else {
      results.forEach(item => {
        const resultElement = document.createElement('div');
        resultElement.className = 'search-result-item';
        resultElement.innerHTML = `
          <div class="d-flex justify-content-between">
            <div>
              <div class="item-name">${highlightText(item.name, searchTerm)}</div>
              ${item.description ? `<div class="item-description">${highlightText(item.description, searchTerm)}</div>` : ''}
            </div>
            <div class="item-price">
              ${item.price}
            </div>
          </div>
        `;
        
        resultElement.addEventListener('click', () => {
          if (item.onClick) item.onClick();
        });
        
        searchResults.appendChild(resultElement);
      });
    }
    
    searchResults.style.display = results.length > 0 || searchTerm ? 'block' : 'none';
  }

  function performSearch() {
    const searchTerm = searchInput.value.toLowerCase().trim();
    
    if (searchTerm === '') {
      searchResults.style.display = 'none';
      return;
    }
    
    const results = itemsData.filter(item => 
      item.name.toLowerCase().includes(searchTerm) || 
      (item.description && item.description.toLowerCase().includes(searchTerm))
    );
    
    showSearchResults(results, searchTerm);
  }

  // Event listeners
  searchInput.addEventListener('input', performSearch);
  searchInput.addEventListener('focus', performSearch);
  
  document.addEventListener('click', function(e) {
    if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
      searchResults.style.display = 'none';
    }
  });

  // Close dropdown when pressing Escape
  searchInput.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      searchResults.style.display = 'none';
    }
  });
}