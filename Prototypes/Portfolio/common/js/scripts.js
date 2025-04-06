document.addEventListener("DOMContentLoaded", function () {
  // Load common components
  function loadComponent(id, file) {
    fetch(file)
      .then((response) => response.text())
      .then((data) => {
        document.getElementById(id).innerHTML = data;
      })
      .catch((error) => console.error(`Error loading ${file}:`, error));
  }

  loadComponent("navbar-container", "common/components/navbar.html");
  loadComponent("header-container", "common/components/header.html");
  loadComponent("footer-container", "common/components/footer.html");

  // Navbar Scroll Effect
  window.addEventListener("scroll", function () {
    const navbar = document.querySelector(".navbar");
    if (window.scrollY > 50) {
      navbar.classList.add("bg-white", "shadow-md");
      navbar.classList.remove("bg-transparent");
      navbar.querySelectorAll("a").forEach((a) => {
        a.classList.add("text-black");
        a.classList.remove("text-white");
      });
    } else {
      navbar.classList.add("bg-transparent");
      navbar.classList.remove("bg-white", "shadow-md");
      navbar.querySelectorAll("a").forEach((a) => {
        a.classList.add("text-white");
        a.classList.remove("text-black");
      });
    }
  });
});
