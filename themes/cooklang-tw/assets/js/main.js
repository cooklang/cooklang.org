// Mobile menu toggle
document.addEventListener('DOMContentLoaded', function() {
  const mobileMenuButton = document.getElementById('mobile-menu-button');
  const mobileMenu = document.getElementById('mobile-menu');
  
  if (mobileMenuButton && mobileMenu) {
    mobileMenuButton.addEventListener('click', function() {
      mobileMenu.classList.toggle('hidden');
    });
    
    // Close menu when clicking outside
    document.addEventListener('click', function(event) {
      if (!mobileMenuButton.contains(event.target) && !mobileMenu.contains(event.target)) {
        mobileMenu.classList.add('hidden');
      }
    });
  }
});
